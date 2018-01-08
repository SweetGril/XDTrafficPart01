//
//  XDMqttMessage.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/18.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDMqttMessage : NSObject
/**设备ID*/
@property (nonatomic,strong)NSString * deviceId;
/**设备的纬度*/
@property (nonatomic,assign)float deviceLat;
/**设备的经度*/
@property (nonatomic,assign)float deviceLng;
/**设备的topic*/
@property (nonatomic,strong)NSString * topicStr;
/**设备的速度*/
@property (nonatomic,assign)float speed;
/**方位角*/
@property(nonatomic,assign) float  angleNum;
/**电量*/
@property(nonatomic,strong) NSString * electric;
/**信号强度： 取值范围 -128 ~ 127，单位dB*/
@property(nonatomic,strong) NSString * signal;
/**设备的定位时间*/
@property(nonatomic,strong) NSString * dateTime;
/**设备的位置信息*/
@property(nonatomic,strong) NSString * datePlace;
@end
