//
//  XDMaqttClientManger.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/9.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**用于连接，接收消息的类库*/
@interface XDMaqttClientManger : NSObject<XDClientManagerDelegate>
+ (XDMaqttClientManger*)sharedInstance;
- (void)connectMqtt;
@end
