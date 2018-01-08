//
//  XDDeviceManager.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XDNetWork.h"
/**
 设备管理类方法
 */
@interface XDDeviceManager : NSObject
/**
 所有的设备字典
 topic 作为键
 相关信息作为值
 */
@property (nonatomic,strong)NSMutableDictionary *allDeviceDictionary;
+ (XDDeviceManager *)sharedManager;
/**获取所有的设备 列表信息*/
- (NSMutableDictionary *)getDeviceDictionary;
- (void)postDeviceListsuccess:(void (^)(NSDictionary *success))successBlock
                      failure:(void (^)(NSError *failure))failureBlock;


@end
