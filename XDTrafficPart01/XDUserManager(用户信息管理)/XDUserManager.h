//
//  XDUserManager.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**用户信息管理 manager*/
@interface XDUserManager : NSObject <NSCopying>
@property (nonatomic,strong)NSString *apiKey;
@property (nonatomic,strong)NSString *apiSecret;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *nick;
@property (nonatomic,strong)NSString *notify;
@property (nonatomic,strong)NSString *userClientId;
@property (nonatomic,strong)NSString *phoneNum;
+ (XDUserManager*)sharedInstance;
/**登录*/
- (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *)password success:(void (^)(NSDictionary *success))successBlock failure:(void (^)(NSError *failure))failureBlock;
/**读取本地保存的信息*/
- (void)readLocationData;
/**清除本地保存的个人信息*/
- (void)clearUserData;
@end
