//
//  XDBaseMapViewController.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDBaseMapViewController.h"
#import "XDMAPointAnnotation.h"
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
    [self bgMapView];
}
- (MAMapView *)bgMapView{
    if (_bgMapView==nil) {
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
    return _bgMapView;
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
        annotationView.typeType = pointAnnotation2.model.deviceType;
        annotationView.delegate = self;
        if (_objectModel!=nil) {
            annotationView.selected = YES;
        }
        return annotationView;
    }
    return nil;
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
              NSLog(@"--model---%f--%f",model.lat,model.lon);
            CLLocationCoordinate2D point = CLLocationCoordinate2DMake(model.lat, model.lon);
            XDMAPointAnnotation *annotation = [[XDMAPointAnnotation alloc] init];
            annotation.coordinate = point;
            annotation.model = model;
            [_bgMapView addAnnotation:annotation];
            [_annotationArray addObject:annotation];
        }
        //设置地图缩放比例
        [_bgMapView showAnnotations:_annotationArray animated:YES];
        CGFloat zoomLevel = _bgMapView.zoomLevel;
        [_bgMapView setZoomLevel:zoomLevel-3 atPivot:self.view.center animated:YES];
    }
    else{
        [_bgMapView setZoomLevel:13 atPivot:self.view.center animated:NO];
        [_bgMapView setClearsContextBeforeDrawing:YES];
        [_bgMapView removeAnnotations:_annotationArray];
    }
}
#pragma mark 长按事件
- (void)clickEditLongTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView{
    [_bgMapView selectAnnotation:annotationView.annotation animated:YES];
    if (self.longTouchButton) {
        self.longTouchButton(modelObj, annotationView);
    }
}
#pragma mark 单点事件
- (void)clickEditSingleTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView{
    [_bgMapView selectAnnotation:annotationView.annotation animated:YES];
    if (self.clickDeviceDetail) {
        self.clickDeviceDetail(modelObj);
    }
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
- (void)dealloc{
    NSLog(@"-XDBaseMapViewController---- dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
