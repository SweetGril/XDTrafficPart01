//
//  XDClloctionManager.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDClloctionManager.h"
static XDClloctionManager *_manager;
/**位置管理类方法 CLLocation */
@implementation XDClloctionManager
+ (XDClloctionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[XDClloctionManager alloc] init];
    });
    return _manager;
}
@end
