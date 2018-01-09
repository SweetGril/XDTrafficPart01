//
//  XDouHeader.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/8.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Constants : NSObject
//加载与刷新
extern NSString * const headerPullToRefreshText;
extern NSString * const headerReleaseToRefreshText;
extern NSString * const headerRefreshingText;
extern NSString * const footerPullToRefreshText;
extern NSString * const footerReleaseToRefreshText;
extern NSString * const footerRefreshingText;
//设备修改
extern NSString * const XDChageDeviceNotification;
//围栏修改
extern NSString * const XDChageFenceNotification ;
/**
 MQTT 设备移动通知接收
 */
extern NSString * const XDMoveReceiveMessageNotification;
/**
 MQTT 设备 申请管理接收
 */
extern NSString * const XDDeviceMangerNotification;
/**
 MQTT 设备 邀请进行管理
 */
extern NSString * const XDInviteDeviceMangerNotification;
/**
 同意加入后的 设备通知，需要重新请求设备列表
 */
extern NSString * const XDNotifatinDeviceAdd;

/**
 删除对某设备的管理权限，需要重新请求设备列表
 */
 extern NSString * const XDNotifatinDeviceDelete ;
/**
 队伍
 */
extern NSString * const XDNotifatinDeviceTream;
/**
 MQTT 设备预警接收
 */
extern NSString * const XDWarningMessageNotification;
//个人接收
extern NSString * const XDLiveManagerUserNotification;
extern NSString * const serverUrl;
extern NSString * const mapKey;
extern NSString * const XDAO_SERVER;
extern NSString * const APIHEADStr;
@end
