//
//  XDBaseViewController.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDBaseViewController.h"
#import "XDClientManager.h"
#import "XDMqttMessage.h"
@interface XDBaseViewController ()<XDClientManagerDelegate>

@end

@implementation XDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    XDClloctionManager *clloctionManager = [XDClloctionManager sharedManager];
    [clloctionManager addObserver:self forKeyPath:@"nowPoint" options:NSKeyValueObservingOptionNew context:@"AAAAA"];
    
    [[XDDeviceManager sharedManager] addObserver:self forKeyPath:@"allDeviceDictionary" options:NSKeyValueObservingOptionNew context:@"AAAAA"];

}
#pragma mark 链接MQTT 需要用户注册时的clientID
- (void)contentClientBtnclick:(id)sender {
   
}
- (void)logoutBtnclick:(id)sender {
    [[XDClientManager shareInstance]close];
}
#pragma mark 单条 设备订阅
- (void)subscriptionBtnClick:(id)sender {
    [[XDClientManager shareInstance].mqttSession subscribeTopic:@"/10001/09/0A/10A5C0000/REAL"];
}
#pragma mark 单条 设备取消订阅
- (void)unsubscriptBtnClick:(id)sender {
    [[XDClientManager shareInstance].mqttSession unsubscribeTopic:@"/10001/09/0A/10A5C0000/REAL"];
    
}
#pragma mark 多条 设备订阅
- (void)subscriptionsBtnClick:(id)sender {
    
//    [[XDClientManager shareInstance].mqttSession subscribeToTopics:_topicDictionary];
}
#pragma mark 多条 设备取消订阅
- (void)unsubscriptsBtnClick:(id)sender {

//    [[XDClientManager shareInstance].mqttSession unsubscribeTopics:_topicArray];
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
        
        NSString *responseDataStr = [NSString stringWithFormat:@"==-%@--------+++%f===%f==\r\n",msgModel.topicStr,msgModel.deviceLat,msgModel.deviceLng];
      
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//     [XDClloctionManager sharedManager].nowPoint = CLLocationCoordinate2DMake(39.9046900000, 116.4071700000);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"-- XDBaseViewController---%f",[XDClloctionManager sharedManager].nowPoint.latitude);
    NSLog(@"-- XDBaseViewController  allDeviceDictionary---%@",[XDDeviceManager sharedManager].allDeviceDictionary);
}

- (void)mqttClientMsg:(id)model{
    
}
- (void)dealloc{
     [[XDClloctionManager sharedManager] removeObserver:self forKeyPath:@"nowPoint"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
