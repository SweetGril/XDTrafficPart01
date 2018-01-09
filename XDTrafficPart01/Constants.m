//
//  XDouHeader.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/8.
//  Copyright © 2017年 xiao dou. All rights reserved.
//
#import "Constants.h"


//#define APIHEADStr @"http://172.16.1.40/alarm"
//@"http://api.4things.cn";

//加载与刷新
NSString * const headerPullToRefreshText = @"下拉刷新";
NSString * const headerReleaseToRefreshText = @"松开马上刷新";
NSString * const headerRefreshingText = @"正在赶来...";
NSString * const footerPullToRefreshText = @"上拉加载";
NSString * const footerReleaseToRefreshText = @"松开马上加载";
NSString * const footerRefreshingText = @"正在赶来...";

//设备修改
NSString * const XDChageDeviceNotification = @"XDChageDeviceNotification";
/**
 MQTT 设备移动通知接收
 */
NSString * const XDMoveReceiveMessageNotification = @"XDMoveReceiveMessageNotification";
/**
 MQTT 设备预警接收
 */
NSString * const XDWarningMessageNotification = @"XDWarningMessageNotification";
/**
 MQTT 设备 申请管理接收
 */
NSString * const XDDeviceMangerNotification = @"XDDeviceMangerNotification";
/**
 MQTT 设备 邀请进行管理
 */
NSString * const XDInviteDeviceMangerNotification = @"XDInviteDeviceMangerNotification";
/**
 同意加入后的 设备通知，需要重新请求设备列表
 */
NSString * const XDNotifatinDeviceAdd = @"XDNotifatinDeviceAdd";
/**
 队伍
 */
NSString * const XDNotifatinDeviceTream = @"XDNotifatinDeviceTream";

/**
 删除对某设备的管理权限，需要重新请求设备列表
 */
NSString * const XDNotifatinDeviceDelete = @"XDNotifatinDeviceDelete";
//围栏修改
NSString * const XDChageFenceNotification = @"XDChageFenceNotification";
//个人接收
NSString * const XDLiveManagerUserNotification = @"XDLiveManagerUserNotification";
NSString * const serverUrl = @"http://www.xdao.org";
NSString * const mapKey = @"7c97e3be11edd1be8865acdbe183d3c6";
NSString * const XDAO_SERVER = @"http://www.xdao.org";
NSString * const APIHEADStr =@"http://api.4things.cn";
@implementation Constants

@end
