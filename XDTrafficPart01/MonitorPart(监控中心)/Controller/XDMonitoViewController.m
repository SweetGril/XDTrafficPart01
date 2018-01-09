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
    self.objectModel= nil;

}
#pragma mark 长按事件
- (void)clickEditLongTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView{
    [self.bgMapView selectAnnotation:annotationView.annotation animated:YES];

}
#pragma mark 单点事件
- (void)clickEditSingleTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView{
    [self.bgMapView selectAnnotation:annotationView.annotation animated:YES];
}
#pragma mark 设备后位置信息的实时更改
- (void)deviceMoveWithCLLocationCoordinate2D:(CLLocationCoordinate2D )coordinate andSpeedStr:(NSString *)speedStr andTopic:(NSString *)topic
{
//    if (_editDeviceView!=nil &&[self.editDeviceView.modelObject.realTopic isEqualToString:topic]==YES) {
//        self.MAMapView.centerCoordinate = coordinate;
//        self.editDeviceView.speedLab.text =speedStr;
//    }
//    if (_detailPartView!=nil&&[self.equipmodel.realTopic isEqualToString:topic]==YES&&_equipmodel!=nil&&_annotation==nil) {
//        self.MAMapView.centerCoordinate = coordinate;
//    }
}
- (void)dealloc{
    NSLog(@"---XDMonitoViewController---dealloc--");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
