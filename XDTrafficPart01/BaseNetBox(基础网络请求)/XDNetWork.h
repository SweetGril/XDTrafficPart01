//
//  XDNetWork.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@interface XDNetWork : NSObject
+ (XDNetWork *) sharedInstance;
/**
 基础的网络请求
 */
- (void)postRequestWithUrl:(NSString *)url andParameters:(NSDictionary *)dic success:(void (^)(NSDictionary *success))success failure:(void (^)(NSError *failure))failure;
@end
