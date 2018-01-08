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
/**
 说明：这个控制器用于显示地图以及上面的所有的设备，围栏；
 */
@interface XDBaseMapViewController : XDBaseViewController
@property (nonatomic,strong)MAMapView *bgMapView;
/**这个属性如果是空则表示显示所有的设备，否则就是单个设备*/
@property (nonatomic, strong) EquipmentModel *objectModel;
/**单击设备操作*/
@property (copy, nonatomic)void (^clickDeviceDetail)(EquipmentModel *indexModel);
/**长按设备操作*/
@property (copy, nonatomic)void (^longTouchButton)(EquipmentModel *modelObj,XDVehicleAnnotationView *selectView);
@end
