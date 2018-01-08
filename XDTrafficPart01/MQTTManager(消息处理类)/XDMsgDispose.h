//
//  XDMsgDispose.h
//  XDTrafficApp
//
//  Created by xiao dou on 2017/12/25.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDMqttMessage.h"
/**对于MQTT 数据进行解析处理的类*/
@interface XDMsgDispose : NSObject
/**
 获取位置时时改变的位置等信息通过byte
 */
+ (void)getMoveInfoWithData:(NSData *)data  info:(void (^)(XDMqttMessage *msgObj))successBlock fail:(void(^)(NSString *errorMsg))faileBlock;
@end
