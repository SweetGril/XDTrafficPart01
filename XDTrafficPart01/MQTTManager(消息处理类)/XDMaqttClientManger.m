//
//  XDMaqttClientManger.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/9.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDMaqttClientManger.h"
#import "XDMqttMessage.h"
#import "EquipmentModel.h"
static  XDMaqttClientManger *_clientManager;
/**用于连接，接收消息的类库*/
@implementation XDMaqttClientManger
+ (XDMaqttClientManger*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _clientManager = [[XDMaqttClientManger alloc] init];
    });
    return _clientManager;
}
- (void)connectMqtt{
     
    if ([XDClientManager shareInstance].messageDelegate ==nil) {
        [XDClientManager shareInstance].messageDelegate = self;
        [[XDClientManager shareInstance]loginWithIp:@"4things.cn" port:1883 isAutoConnect:false isAutoConnectCount:19 clientID:[XDUserManager sharedInstance].userClientId];
    }
}


/**连接状态回调*/
-(void)handleEvent:(MQTTSession *)xdSession event:(MQTTSessionEvent)eventCode error:(NSError *)error{
    NSDictionary *events = @{
                             @(MQTTSessionEventConnected): @"connected",
                             @(MQTTSessionEventConnectionRefused): @"账号或密码错误，服务器拒绝连接",
                             @(MQTTSessionEventConnectionClosed): @"connection closed",
                             @(MQTTSessionEventConnectionError): @"connection error",
                             @(MQTTSessionEventProtocolError): @"protocoll error",
                             @(MQTTSessionEventConnectionClosedByBroker): @"connection closed by broker"
                             };
    
    NSString *statusStr =[NSString stringWithFormat:@"==---MQTT连接状态%@--------",[events objectForKey:@(eventCode)]];
    
}
#pragma mark  消息接受的回调方法
- (void)receiveWithType:(XDMessageManagerType)type andResponseData:(id)responseData{
    if (type ==XDDeviceMoveMessageType) {
        XDMqttMessage *msgModel = (XDMqttMessage *)responseData;
        EquipmentModel *objModel = [[XDDeviceManager sharedManager].allDeviceDictionary objectForKey:msgModel.topicStr];
        objModel.location2D = CLLocationCoordinate2DMake(msgModel.deviceLat, msgModel.deviceLng);
        objModel.lat = msgModel.deviceLat;
        objModel.lon = msgModel.deviceLng;
        [[XDDeviceManager sharedManager].allDeviceDictionary setValue:objModel forKey:msgModel.topicStr];
        [[XDClloctionManager sharedManager]searchReGeocodeWithCoordinate:CLLocationCoordinate2DMake(msgModel.deviceLat,msgModel.deviceLng) withTopic:msgModel.topicStr];
        [XDClloctionManager sharedManager].addressBlock = ^(NSString *addressStr, NSString *topic) {
            EquipmentModel *modelObj = [[XDDeviceManager sharedManager].allDeviceDictionary objectForKey:topic];
            modelObj.placeStr =addressStr;
            [[XDDeviceManager sharedManager].allDeviceDictionary setValue:modelObj forKey:topic];
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:XDMoveReceiveMessageNotification object:msgModel];
    }
}
@end
