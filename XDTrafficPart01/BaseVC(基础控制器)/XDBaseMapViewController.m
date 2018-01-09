//
//  XDBaseMapViewController.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDBaseMapViewController.h"
#import "XDMAPointAnnotation.h"
#import "XDMqttMessage.h"
@interface XDBaseMapViewController ()<XDVehicleAnnotationViewDelegate,MAMapViewDelegate>
{
    NSMutableDictionary *_allDeviceDictionary;//所有的设备信息字典
    NSMutableArray *_annotationArray;
    EquipmentModel *_objectModel;
}
@end

@implementation XDBaseMapViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     _annotationArray = [[NSMutableArray alloc] init];
     _allDeviceDictionary = [[NSMutableDictionary alloc] init];
     self.view.backgroundColor = [UIColor whiteColor];
     [self creatMapView];
}
- (void)creatMapView{
    [AMapServices sharedServices].enableHTTPS = YES;
    _bgMapView = [[MAMapView alloc] init];
    _bgMapView.showsCompass = NO;
    _bgMapView.rotateEnabled =NO;
    _bgMapView.rotateCameraEnabled = NO;
    _bgMapView.showsUserLocation = YES;
    _bgMapView.delegate = self;
    [_bgMapView setCenterCoordinate:[XDClloctionManager sharedManager].nowPoint];
    [self.view addSubview:_bgMapView];
    [_bgMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(self.view.mas_width).offset(0);
        make.height.equalTo(self.view.mas_height).offset(0);
    }];
}

#pragma mark -  viewForAnnotation ------- 地图代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    else if ([annotation isKindOfClass:[XDMAPointAnnotation class]]){
        XDMAPointAnnotation *pointAnnotation2 = (XDMAPointAnnotation *)annotation;
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        XDVehicleAnnotationView *annotationView = (XDVehicleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[XDVehicleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        annotationView.modelObj = pointAnnotation2.model;
        annotationView.delegate = self;
        if (_objectModel!=nil) {
            annotationView.selected = YES;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    view.selected =YES;
}
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    view.selected =NO;
}
#pragma mark 判断是否为设备全部显示
- (void)setObjectModel:(EquipmentModel *)objectModel{
    if (objectModel) {
        _objectModel = objectModel;
        [self creatAnnotationPoint];
    }
    else{
        [[XDDeviceManager sharedManager]postDeviceListsuccess:^(NSDictionary *success) {
            _allDeviceDictionary = [XDDeviceManager sharedManager].getDeviceDictionary;
            [self creatAnnotationPoint];
        } failure:^(NSError *failure) {
        }];
    }
}
#pragma mark 绘制所有的标点
- (void)creatAnnotationPoint{
    if (_allDeviceDictionary.allKeys.count>0) {
        [_bgMapView setClearsContextBeforeDrawing:YES];
        [_bgMapView removeAnnotations:_annotationArray];
        [_annotationArray removeAllObjects];
        for (int a=0; a<_allDeviceDictionary.allKeys.count; a++) {
            NSString *keyStr =_allDeviceDictionary.allKeys[a];
            EquipmentModel *model = [_allDeviceDictionary objectForKey:keyStr];
            CLLocationCoordinate2D point = model.location2D;
            XDMAPointAnnotation *annotation = [[XDMAPointAnnotation alloc] init];
            annotation.coordinate = point;
            annotation.model = model;
            [_bgMapView addAnnotation:annotation];
            [_annotationArray addObject:annotation];
        }
        //设置地图缩放比例
        [_bgMapView showAnnotations:_annotationArray animated:NO];
        CGFloat zoomLevel = _bgMapView.zoomLevel;
        [_bgMapView setZoomLevel:zoomLevel-1 atPivot:self.view.center animated:NO];
    }
    else{
        [_bgMapView setZoomLevel:13 atPivot:self.view.center animated:NO];
        [_bgMapView setClearsContextBeforeDrawing:YES];
        [_bgMapView removeAnnotations:_annotationArray];
    }
}
#pragma mark 设备发生位置移动 进行界面修改
-(void)liveManagerDidReceiveMessage:(NSNotification *)notifi{
    XDMqttMessage * message = (XDMqttMessage *)notifi.object;
    NSArray *allPoint = [_bgMapView annotations];
    for (int a =0; a<allPoint.count; a++) {
        MAPointAnnotation *annotation = allPoint[a];
        if ([annotation isKindOfClass:[XDMAPointAnnotation class]]==YES) {
            XDMAPointAnnotation *objanntation = (XDMAPointAnnotation *)annotation;
            if ([objanntation.model.realTopic isEqualToString:message.topicStr]) {
                XDVehicleAnnotationView *tagView = (XDVehicleAnnotationView*)[_bgMapView viewForAnnotation:annotation];
                if (tagView.modelObj.deviceName.length>5) {
                    NSString *string2 = [tagView.modelObj.deviceName substringToIndex:4];
                    tagView.modelObj.deviceName =[NSString stringWithFormat:@"%@... ",string2];
                }
                NSString *contentStr= [NSString stringWithFormat:@"%@ %.1fkm/h",tagView.modelObj.deviceName,tagView.modelObj.speed];
                if (message.speed ==0) {
                    contentStr= [NSString stringWithFormat:@"%@ 静止",tagView.modelObj.deviceName];
                }
                tagView.calloutView.infoLab.text = contentStr;
                CLLocationCoordinate2D currentPos = CLLocationCoordinate2DMake(message.deviceLat,message.deviceLng);
                [self deviceMoveWithCLLocationCoordinate2D:currentPos andSpeedStr:[NSString stringWithFormat:@"%.0fkm/h",message.speed]andTopic:message.topicStr];
                annotation.coordinate = currentPos;
                float angle = message.angleNum/360.0*2;
                float angle2 =M_PI*angle;
                 //如果是图钉类型的 不进行旋转操作
                if (objanntation.model.deviceType ==3) {
                    return;
                }
                tagView.pointImageView.transform=CGAffineTransformMakeRotation(-M_PI*0.5+angle2);
                return;
            }
        }
    }
}
#pragma mark 设备后位置信息的实时更改
- (void)deviceMoveWithCLLocationCoordinate2D:(CLLocationCoordinate2D )coordinate andSpeedStr:(NSString *)speedStr andTopic:(NSString *)topic{
    
}
- (void)dealloc{
    NSLog(@"-XDBaseMapViewController---- dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
