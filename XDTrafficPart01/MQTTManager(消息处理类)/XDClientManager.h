//
//  XDClientManager.h
//  XDTrafficApp
//
//  Created by xiao dou on 2017/12/25.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTClient.h"
typedef NS_ENUM(NSInteger, XDMessageManagerType) {
    XDWarmingMessageType,           //设备的预警信息
    XDRequestDeviceMessageType,     //作为设备管理者收到请求进行管理设备
    XDAgreeDeviceMessageType,       //被允许管理某设备
    XDInvitedDeviceMessageType,     //收到邀请去管理某设备
    XDRemoveDeviceMessageType,      //某设备的管理权限被移除
    XDDeviceMoveMessageType         //设备实时移动数据
};
@protocol XDClientManagerDelegate <NSObject>
/**MQTT链接状态*/
-(void)connectedEvent:(MQTTSession *)xdSession;
/**连接状态回调*/
-(void)handleEvent:(MQTTSession *)xdSession event:(MQTTSessionEvent)eventCode error:(NSError *)error;

/**代理返回接收数据*/
- (void)receiveWithType:(XDMessageManagerType)type andResponseData:(id)responseData;
@end
/**统一进行
   消息的处理接受 转为XDMessageManager类型进行分发；
   设备的订阅；
   设备的取消订阅；
 */
@interface XDClientManager : NSObject
@property(nonatomic, strong)    MQTTSession *mqttSession;
@property(nonatomic, strong)    NSMutableArray *topicArray;
@property (nonatomic, assign) XDMessageManagerType messageStyle;
@property (nonatomic,weak) id<XDClientManagerDelegate>messageDelegate;
/**
 单例
 
 @return self
 */
+(XDClientManager *)shareInstance;
/**
 MQTT登陆
 ip 服务器ip
 port 服务器端口
 isAutoConnect 是否自动重连标识，默认不自动重连
 coonectCount 自动重连次数
 clientID 当前登录使用的标示
 */
-(void)loginWithIp:(NSString *)ip port:(UInt16)port isAutoConnect:(BOOL)isAutoConnect isAutoConnectCount:(NSUInteger)coonectCount clientID:(NSString *)clientIDStr;

/**
 将推送Token提交给消息服务后台保存，目前没有确定接口以及关联token标识（建议第一次提交失败还要继续提交大概3次，3次都失败返回）
 
 官方文档上建议开发者在每次启动应用时应该都向APNS获取device token并上传给服务器。
 
 @param token 向苹果申请的推送token
 @param flag 提交结果
 */
-(void)pushDeviceToken:(NSString *)token block:(void(^)(BOOL flag))flag;
/**
 断开连接，清空数据
 */
-(void)close;
/**
 注册代理
 @param obj 需要实现代理的对象
 */
-(void)registerDelegate:(id)obj;
/**
 解除代理
 @param obj 需要接触代理的对象
 */
-(void)unRegisterDelegate:(id)obj;
@end
