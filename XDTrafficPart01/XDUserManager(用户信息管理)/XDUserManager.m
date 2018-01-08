//
//  XDUserManager.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDUserManager.h"

static  XDUserManager *_manager;
/**用户信息管理 manager*/
@implementation XDUserManager
+ (XDUserManager*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[XDUserManager alloc] init];
        _manager.apiKey = @"DtHDuy4m";
        _manager.apiSecret = @"EqHjOPUj7CZSgsxltxXuFauM";
        _manager.icon = @"http://static.4things.cn/icon/MTM1MTY3MDY4MDI=.jpg?t=1511955544106";
        _manager.nick = @"JY";
        _manager.notify = @"13625811915";
        _manager.userClientId = @"k1mr5c0ESQNJln3I";
    });
    return _manager;
}
//- (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *)mobile{
//    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
//    [dataDic setValue:mobile forKey:@"mobile"];
//    [dataDic setValue:mobile forKey:@"password"];
//    NSString *url = APIHEADStr(@"/user/login");
//    
//
//}
@end
