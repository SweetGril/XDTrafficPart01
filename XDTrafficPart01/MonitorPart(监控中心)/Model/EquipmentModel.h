//
//  EquipmentModel.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/14.
//  Copyright © 2017年 xiao dou. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface EquipmentModel : NSObject
@property(nonatomic,strong) NSString * deviceId;
@property(nonatomic,assign) float  lat;
@property(nonatomic,assign) float  lon;
@property(nonatomic,assign) float  deviceType;
@property(nonatomic,strong) NSString * deviceName;
@property(nonatomic,strong) NSString * bindTime;
@property(nonatomic,strong) NSString * sdkName;
@property(nonatomic,strong) NSString * sdkVersion;
@property(nonatomic,assign) float  speed;
@property(nonatomic,strong) NSString * realTopic;
@property(nonatomic,strong) NSString * topicFormat;
@property(nonatomic,strong) NSString * userId;
@property(nonatomic,strong) NSString * placeStr;
@property(nonatomic,strong) NSString * status;
/**方位角*/
@property(nonatomic,assign) float  angleNum;
/**电量*/
@property(nonatomic,strong) NSString * electric;
/**信号强度： 取值范围 -128 ~ 127，单位dB*/
@property(nonatomic,strong) NSString * signal;
/**接受到的位置移动时间*/
@property(nonatomic,strong) NSString * time;
@end
