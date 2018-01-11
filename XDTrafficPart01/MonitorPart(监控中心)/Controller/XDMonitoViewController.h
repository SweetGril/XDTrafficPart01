//
//  XDMonitoViewController.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDBaseMapViewController.h"
#import "XDDeviceEditTipView.h"
#import "XDDetailsPartView.h"
@interface XDMonitoViewController : XDBaseMapViewController
{
    BOOL isPushOther;
    NSString *mapTypeStr;
    UIView *selectPoint;//被长按选中的备注标签
}
@property (nonatomic,strong)UIImageView *unreadIcon;
@property (nonatomic,strong)XDDetailsPartView *detailPartView;
@property (nonatomic,strong)XDEditFencePointAntion *annotation;
@property (nonatomic,strong)XDCirlcle * circleShow;//作为点击展示的圆形围栏
@property (nonatomic,strong)XDMAPolygon * polyLineShow;//作为点击现实的多边形围栏
@property (nonatomic,strong)XDDeviceEditTipView *editDeviceView;
@property (nonatomic,strong)XDVehicleAnnotationView *selectPoint;
@property (nonatomic,strong)EquipmentModel *equipmodel;//选中的设备的信息
@end
