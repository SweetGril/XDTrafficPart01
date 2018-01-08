//
//  XDClientManager.m
//  XDTrafficApp
//
//  Created by xiao dou on 2017/12/25.
//  Copyright © 2017年 xiao dou. All rights reserved.
//
#import <UIKit/UIDevice.h>
#import "MQTTStatus.h"
#import "FunBox.h"
#import "XDMsgDispose.h"
#import "XDClientManager.h"
#import "MQTTClientManagerDelegate.h"
@interface XDClientManager ()<MQTTSessionDelegate>
typedef void(^flagBlock)(BOOL flag) ;//定义block
@property(nonatomic, weak)      id<MQTTClientManagerDelegate> delegate;//代理
@property(nonatomic, strong)    MQTTCFSocketTransport *transport;//连接服务器属性
@property(nonatomic, strong)    NSString *ip;//服务器ip地址
@property(nonatomic)            UInt16 port;//服务器ip地址
@property(nonatomic, strong)    NSString *clientID;//用户clientID
@property(nonatomic, strong)    MQTTStatus *mqttStatus;//连接服务器状态
@property(nonatomic, copy)      flagBlock flag;//目前只用于返回token上传结果
@property(nonatomic, assign)    BOOL   isAutoConnect;//是否自动重连标识
@property(nonatomic, assign)    NSUInteger connectCount;//自动重连次数
@property(nonatomic, assign)    NSUInteger nowCount;//当前已经重连的次数
@end
@implementation XDClientManager
#pragma mark 对外方法
/**
 单例
 
 @return self
 */
+(XDClientManager *)shareInstance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc] init];
    });
    return instance;
}
/**
 MQTT登陆，
 ip 服务器ip
 port 服务器端口
 isAutoConnect 是否自动重连标识，默认不自动重连
 coonectCount 自动重连次数
 clientID 当前登录使用的标示
 */
-(void)loginWithIp:(NSString *)ip port:(UInt16)port isAutoConnect:(BOOL)isAutoConnect isAutoConnectCount:(NSUInteger)coonectCount clientID:(NSString *)clientIDStr{
//     [self loginWithIp:ip port:port userName:nil password:nil topics:nil isAutoConnect:isAutoConnect isAutoConnectCount:coonectCount clientID:clientIDStr];
    self.ip=ip;
    self.port=port;
    [self loginMQTT];
    [self registerDelegate:self];
}

#pragma mark 懒加载
-(MQTTSession *)mqttSession{
    if (!_mqttSession) {
        _mqttSession=[[MQTTSession alloc] initWithClientId:_clientID];
    }
    return _mqttSession;
}

-(MQTTCFSocketTransport *)transport{
    if (!_transport) {
        _transport=[[MQTTCFSocketTransport alloc] init];
    }
    return _transport;
}
-(MQTTStatus *)mqttStatus{
    if (!_mqttStatus) {
        _mqttStatus=[[MQTTStatus alloc] init];
    }
    return _mqttStatus;
}

/**
 将推送Token提交给消息服务后台保存，目前没有确定接口以及关联token标识（建议第一次提交失败还要继续提交大概3次，3次都失败返回）
 
 官方文档上建议开发者在每次启动应用时应该都向APNS获取device token并上传给服务器。
 
 @param token 向苹果申请的推送token
 @param flag 提交结果
 */
-(void)pushDeviceToken:(NSString *)token block:(void(^)(BOOL flag))flag{
    self.flag=flag;
    NSLog(@"假装token传输到服务器成功:%@",token);
    self.flag(true);
}
/*实际登陆处理*/
-(void)loginMQTT{
    //当前登录次数增加
    self.nowCount++;
    NSLog(@"-----------------登陆MQTT第%lu次-----------------",(unsigned long)self.nowCount);
    
    /*设置ip和端口号*/
    self.transport.host=_ip;
    self.transport.port=_port;
    
    /*设置MQTT账号和密码*/
    self.mqttSession.transport=self.transport;//给MQTTSession对象设置基本信息
    self.mqttSession.delegate=self;//设置代理
    //会话链接并设置超时时间
    [self.mqttSession connectAndWaitTimeout:20];
}
/**
 断开连接，清空数据
 */
-(void)close{
    NSLog(@"-----------------MQTT主动断开连接-----------------");
    [_mqttSession close];
    _delegate=nil;//代理
    _messageDelegate = nil;
    _mqttSession=nil;
    _transport=nil;//连接服务器属性
    _ip=nil;//服务器ip地址
    _port=0;//服务器ip地址
    _mqttStatus=nil;//连接服务器状态
    _flag=nil;//目前只用于返回token上传结果
    _isAutoConnect=nil;//是否自动重连标识
    _connectCount=0;//自动重连次数
    _nowCount=0;//当前已经重连的次数
}
/**
 注册代理
 @param obj 需要实现代理的对象
 */
-(void)registerDelegate:(id)obj{
    NSLog(@"-----------------MQTT委托代理对象：%@-----------------",NSStringFromClass([obj class]));
    self.delegate=obj;
}
/**
 解除代理
 
 @param obj 需要接触代理的对象
 */
-(void)unRegisterDelegate:(id)obj{
    NSLog(@"-----------------MQTT取消代理对象-----------------");
    self.delegate=nil;
}

#pragma mark MQTTClientManagerDelegate
/*连接成功回调*/
-(void)connected:(MQTTSession *)session{
    
    if ([self.messageDelegate respondsToSelector:@selector(connectedEvent:)]) {
        [self.messageDelegate connectedEvent:session];
    }

}
/*连接状态回调*/
-(void)handleEvent:(MQTTSession *)session event:(MQTTSessionEvent)eventCode error:(NSError *)error{
    NSDictionary *events = @{
                             @(MQTTSessionEventConnected): @"connected链接成功",
                             @(MQTTSessionEventConnectionRefused): @"账号或密码错误，服务器拒绝连接",
                             @(MQTTSessionEventConnectionClosed): @"connection closed",
                             @(MQTTSessionEventConnectionError): @"connection error",
                             @(MQTTSessionEventProtocolError): @"protocoll error",
                             @(MQTTSessionEventConnectionClosedByBroker): @"connection closed by broker"
                             };
//    NSLog(@"-----------------MQTT连接状态%@-----------------",[events objectForKey:@(eventCode)]);
    
    if ([self.messageDelegate respondsToSelector:@selector(handleEvent:event:error:)]) {
        [self.messageDelegate handleEvent:session event:eventCode error:error];
    }
    
    switch (eventCode) {
        case MQTTSessionEventConnected:
        {
            [self handleMQTTResults:events event:eventCode];
        }
            break;
        case MQTTSessionEventConnectionClosed:
        {
            //Closed目前情况看不管什么错误都会通知，再和实际的错误通知一起就等于通知了2次
            [session connect];
        }
            break;
        case MQTTSessionEventConnectionRefused:{
            //服务器拒绝的账号密码错误直接提示
            [self handleMQTTResults:events event:eventCode];
        }
        default:
        {
            //是否自动重连
            if (self.isAutoConnect) {
                //当前重连次数是否超过最大限制
                if (self.nowCount<self.connectCount) {
                    //延迟重登，避免mqtt缓冲区处理不及时崩溃
                    [self performSelector:@selector(loginMQTT) withObject:nil afterDelay:0.3];
                }else{
                    [self handleMQTTResults:events event:eventCode];
                }
            }else{
                [self handleMQTTResults:events event:eventCode];
            }
        }
            break;
    }
}

/*处理服务器结果*/
-(void)handleMQTTResults:(NSDictionary *)events event:(MQTTSessionEvent)eventCode{
    self.nowCount=0;
    [self.mqttStatus setStatusCode:eventCode];
    [self.mqttStatus setStatusInfo:[events objectForKey:@(eventCode)]];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didMQTTReceiveServerStatus:)]) {
        [self.delegate didMQTTReceiveServerStatus:self.mqttStatus];
    }
}
/*收到消息，消息的回执MQTTClient里面自己处理了(acknowledged)*/
-(void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid{
    NSLog(@"=---------------------------/n=MQTT 数据接收的===%@",topic);
    NSString *notify = [[NSUserDefaults standardUserDefaults] objectForKey:@"notify"];
    NSString *phoneTopic =[NSString stringWithFormat:@"/%@/",notify];
    //设备移动消息
    if ([topic isEqualToString:phoneTopic]==NO) {
        self.messageStyle = XDDeviceMoveMessageType;
        __weak typeof(self) weakSelf = self;
        [XDMsgDispose getMoveInfoWithData:data info:^(XDMqttMessage *msgObj) {
            XDMqttMessage *messageObj =msgObj;
            messageObj.topicStr = topic;
            if ([self.messageDelegate respondsToSelector:@selector(receiveWithType:andResponseData:)]) {
                 [weakSelf.messageDelegate receiveWithType:XDDeviceMoveMessageType andResponseData:messageObj];
            }
        } fail:^(NSString *errorMsg){
            return ;
        }];
    }
    else{
        NSString *jsonStr =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *requestDic =[FunBox dictionaryWithJsonString:jsonStr];
        //接收设备管理加入申请
        if ([requestDic[@"event"] isEqualToString:@"BindRequest"]==YES) {
          self.messageStyle = XDRequestDeviceMessageType;
        }
        //被邀请加入设备管理加入
        else if ([requestDic[@"event"] isEqualToString:@"invite"]==YES){
          self.messageStyle = XDInvitedDeviceMessageType;
        }
        //被同意加入某设备需要重新请求列表数据
        else if ([requestDic[@"event"] isEqualToString:@"BindResponse"]==YES){
          self.messageStyle = XDAgreeDeviceMessageType;
        }
        //被 删除 某设备的管理权限 需要重新请求列表数据
        else if ([requestDic[@"event"] isEqualToString:@"UnbindByAdmin"]==YES){
            NSLog(@"----===---%@",requestDic);
            self.messageStyle = XDRemoveDeviceMessageType;
        }
        //预警消息
        else{
            self.messageStyle = XDWarmingMessageType;
        }
        if ([self.messageDelegate respondsToSelector:@selector(receiveWithType:andResponseData:)]) {
            [self.messageDelegate receiveWithType:self.messageStyle andResponseData:requestDic];
        }
    }
 
}

@end
