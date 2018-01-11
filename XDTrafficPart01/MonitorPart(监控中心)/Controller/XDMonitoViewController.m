//
//  XDMonitoViewController.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDMonitoViewController.h"
#import "XDDeviceManager.h"
/**监控中心*/
@interface XDMonitoViewController ()
@end
@implementation XDMonitoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"监控中心";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editFence:) name:XDChageFenceNotification object:nil];
      self.objectModel= nil;
}
#pragma mark 设备的长按事件
- (void)clickEditLongTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView{
    [self hideMapSupportView];
    _equipmodel = modelObj;
    [self.bgMapView setZoomLevel:17 atPivot:self.view.center animated:NO];
    self.bgMapView.centerCoordinate = CLLocationCoordinate2DMake(_equipmodel.lat, _equipmodel.lon);
    
    self.selectPoint.hidden =NO;
    [self.editDeviceView removeFromSuperview];
    self.editDeviceView =nil;
    self.editDeviceView =[XDDeviceEditTipView shareTipViewWithFrame:CGRectMake(ScreenWidth/2-100, ScreenHeight/2-90, 200, 70)];
    WEAKSELF
    self.editDeviceView.setDeviceClick = ^{
         STRONGSELFFor(weakSelf)
        [strongSelf setDeviceInfoBlock];
    };
    self.editDeviceView.modelObject = modelObj;
    [self.view addSubview:_editDeviceView];
    self.editDeviceView.deviceName.placeholder= modelObj.deviceName;
    self.editDeviceView.speedLab.text =[NSString stringWithFormat:@"%.0f km/h",modelObj.speed];
    self.selectPoint =annotationView;
    self.selectPoint.calloutView.hidden = YES;
    self.selectPoint.tipImgViewIcon.hidden = YES;
    self.bgMapView.scrollEnabled = NO;
    self.bgMapView.centerCoordinate = CLLocationCoordinate2DMake(modelObj.lat, modelObj.lon);
}
#pragma mark 设备的单点事件
- (void)clickEditSingleTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView{
    [self hideMapSupportView];
    _equipmodel = modelObj;
    self.bgMapView.centerCoordinate = CLLocationCoordinate2DMake(_equipmodel.lat, _equipmodel.lon);
    [self.bgMapView setZoomLevel:17 atPivot:self.view.center animated:NO];
    [self.bgMapView selectAnnotation:annotationView.annotation animated:YES];
}
#pragma mark 围栏的 单点 事件
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self hideMapSupportView];
    id selectShape = [XDClloctionManager isIncludePointAtCoordinate:coordinate andShapeLine:self.fenceArray];
    if (selectShape!=nil) {
        [self touchMapWithCoordinate:coordinate andShape:selectShape andTouchType:NO];
    }
}
#pragma mark 围栏的 长按 事件
- (void)mapView:(MAMapView *)mapView didLongPressedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self hideMapSupportView];
    id selectShape = [XDClloctionManager isIncludePointAtCoordinate:coordinate andShapeLine:self.fenceArray];
    if (selectShape!=nil) {
        [self touchMapWithCoordinate:coordinate andShape:selectShape andTouchType:YES];
    }
    else{
        [self.bgMapView removeOverlay:_circleShow];
        [self.bgMapView removeOverlay:_polyLineShow];
        [self.bgMapView removeAnnotation:_annotation];
        _annotation =nil;
    }
}
/**
 touchStyle BOOL
 NO 单点围栏
 YES 为长按围栏
 */
#pragma mark 触碰围栏后的操作
- (void)touchMapWithCoordinate:(CLLocationCoordinate2D)coordinate andShape:(id)shape andTouchType:(BOOL)touchStyle{
    _annotation = [[XDEditFencePointAntion alloc] init];
    if ([shape isKindOfClass:[XDCirlcle class]] ) {
        XDCirlcle *circleobj = (XDCirlcle *)shape;
        _circleShow = [XDCirlcle circleWithCenterCoordinate:circleobj.coordinate radius:circleobj.radius];
        _circleShow.status =circleobj.status;
        _circleShow.colorsStatus = YES;
        _circleShow.indexNum =circleobj.indexNum;
        _annotation.indexNum =circleobj.indexNum;
        _annotation.titleStr =circleobj.fenceName;
        [self.bgMapView addOverlay:_circleShow];
    }
    else{
        XDMAPolygon *polyline = (XDMAPolygon *)shape;
        polyline.isColorStatus = YES;
        [self.bgMapView addOverlay:polyline];
        _polyLineShow = [XDMAPolygon polygonWithCoordinates:polyline.polyLine count:polyline.pointCount];
        _polyLineShow.status =polyline.status;
        _polyLineShow.isColorStatus = YES;
        _polyLineShow.fenceindexNum = polyline.fenceindexNum;
        _annotation.titleStr =polyline.fenceName;
        _annotation.indexNum =polyline.fenceindexNum;
        [self.bgMapView addOverlay:_polyLineShow];
    }
    _annotation.coordinate = coordinate;
    _annotation.fenceStyle =touchStyle;
    [self.bgMapView addAnnotation:_annotation];
    [self.bgMapView setCenterCoordinate:coordinate animated:YES];
}
#pragma mark 设备后位置信息的实时更改 屏幕的中心位置可能实时修改
- (void)deviceMoveWithCLLocationCoordinate2D:(CLLocationCoordinate2D )coordinate andSpeedStr:(NSString *)speedStr andTopic:(NSString *)topic
{
    if ([_equipmodel.realTopic isEqualToString:topic]==YES) {
        self.bgMapView.centerCoordinate = coordinate;
        self.editDeviceView.speedLab.text =speedStr;
    }
}

#pragma mark 修改围栏状态信息的方法
-(void)editFence:(NSNotification *)notifiction{
    
    NSNumber * selectNumber = (NSNumber *)notifiction.object;
    int selectNum = [selectNumber intValue];
    XDCricleModel * fenceModel = [XDFenceManager sharedManager].allFenceArray[selectNum];
    id shape = self.fenceArray [selectNum];
    if ([shape isKindOfClass:[XDCirlcle class]] ) {
        XDCirlcle *circle = (XDCirlcle *)shape;
        circle.title = fenceModel.scopeName;
        
        if ([fenceModel.status isEqualToString:@"on"]==YES) {
            circle.status =@"on";
        }
        else{
            circle.status =@"off";
        }
        circle.fenceName =fenceModel.scopeName;
        
        MACircleRenderer *circleRender = (MACircleRenderer *)[self.bgMapView rendererForOverlay:circle];
        MACircleRenderer *circleRenderer2 = (MACircleRenderer *)[self.bgMapView rendererForOverlay:_circleShow];
        if ([fenceModel.status isEqualToString:@"off"]==YES) {
            circleRender.fillColor = [UIColor clearColor];
            circleRender.strokeColor = [UIColor colorWithHexString:@"c0c0c0" withAlpha:1];
            circleRenderer2.fillColor = [UIColor colorWithHexString:@"c0c0c0" withAlpha:0.5];
            circleRenderer2.strokeColor = [UIColor colorWithHexString:@"c0c0c0" withAlpha:1];
        }
        else{
            circleRender.fillColor = [UIColor clearColor];
            circleRender.strokeColor = [UIColor colorWithHexString:@"bf0000" withAlpha:1];
            circleRenderer2.fillColor = [UIColor colorWithHexString:@"FFA0A0" withAlpha:0.5];
            circleRenderer2.strokeColor = [UIColor colorWithHexString:@"bf0000" withAlpha:1];
        }
        [circleRender setNeedsUpdate];
        [circleRenderer2 setNeedsUpdate];
        [self.fenceArray replaceObjectAtIndex:selectNum withObject:circle];
    }
    else{
        XDMAPolygon *polyline = (XDMAPolygon *)shape;
        polyline.status =fenceModel.status;
        polyline.fenceName =fenceModel.scopeName;
        
        MAPolygonRenderer *polylineRenderer = (MAPolygonRenderer *)[self.bgMapView rendererForOverlay:polyline];
        MAPolygonRenderer *polylineRenderer2 =(MAPolygonRenderer *)[self.bgMapView rendererForOverlay:_polyLineShow];
        if ([fenceModel.status isEqualToString:@"off"]==YES) {
            polylineRenderer.fillColor = [UIColor clearColor];
            polylineRenderer.strokeColor = [UIColor colorWithHexString:@"c0c0c0" withAlpha:1];
            polylineRenderer2.fillColor = [UIColor colorWithHexString:@"c0c0c0" withAlpha:0.5];
            polylineRenderer2.strokeColor = [UIColor colorWithHexString:@"c0c0c0" withAlpha:1];
        }
        else{
            polylineRenderer.fillColor = [UIColor clearColor];
            polylineRenderer.strokeColor = [UIColor colorWithHexString:@"bf0000" withAlpha:1];
            polylineRenderer2.fillColor = [UIColor colorWithHexString:@"FFA0A0" withAlpha:0.5];
            polylineRenderer2.strokeColor = [UIColor colorWithHexString:@"bf0000" withAlpha:1];
        }
        [polylineRenderer setNeedsUpdate];
        [polylineRenderer2 setNeedsUpdate];
        [self.fenceArray replaceObjectAtIndex:selectNum withObject:polyline];
    }
}
#pragma mark ----修改设备的名称
- (void)setDeviceInfoBlock{
    [[NSNotificationCenter defaultCenter] postNotificationName:XDChageDeviceNotification object:nil];
    XDVehicleAnnotationView *annotationView = (XDVehicleAnnotationView *)[self.bgMapView viewForAnnotation:_selectPoint.annotation];
    annotationView.calloutView.infoStr =[NSString stringWithFormat:@"%@%@",_editDeviceView.deviceName.text,_editDeviceView.speedLab.text];
    [_editDeviceView removeFromSuperview];
    _editDeviceView=nil;
    _selectPoint.calloutView.hidden = NO;
    _selectPoint.tipImgViewIcon.hidden = NO;
    self.bgMapView.scrollEnabled = YES;
    _equipmodel =nil;
}
#pragma mark 隐藏界面中的 弹出部分View
- (void)hideMapSupportView{
    [self.bgMapView removeAnnotation:_annotation];
    [self.bgMapView removeOverlay:_circleShow];
    [self.bgMapView removeOverlay:_polyLineShow];
    _annotation =nil;
    self.selectPoint.calloutView.hidden = NO;
    self.selectPoint.tipImgViewIcon.hidden = NO;
    self.selectPoint = nil;
    _equipmodel =nil;
    [_editDeviceView removeFromSuperview];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XDChageFenceNotification object:nil];
    NSLog(@"---XDMonitoViewController---dealloc--");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
