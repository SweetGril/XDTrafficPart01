//
//  XDBaseMapViewController.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDBaseViewController.h"
#import "EquipmentModel.h"
#import "XDVehicleAnnotationView.h"
#import "XDEditFencePointAntion.h"
#import "XDMAPointAnnotation.h"
#import "XDFenceAnnotation.h"
#import "XDFenceEditAnnotation.h"
#import "XDMqttMessage.h"
#import "XDMAPolygon.h"
#import "XDCricleModel.h"
#import "XDCirlcle.h"
/**
 说明：这个控制器用于显示地图以及上面的所有的设备，围栏；
 */
@interface XDBaseMapViewController : XDBaseViewController
@property (nonatomic,strong)MAMapView *bgMapView;
/**这个属性如果是空则表示显示所有的设备，否则就是单个设备*/
@property (nonatomic, strong) EquipmentModel *objectModel;
@property (nonatomic,strong) NSMutableArray *fenceArray;//电子围栏的展示数组
#pragma mark 设备后位置信息的实时更改
- (void)deviceMoveWithCLLocationCoordinate2D:(CLLocationCoordinate2D )coordinate andSpeedStr:(NSString *)speedStr andTopic:(NSString *)topic;
@end
