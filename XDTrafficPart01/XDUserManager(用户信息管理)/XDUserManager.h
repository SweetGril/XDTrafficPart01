//
//  XDUserManager.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**用户信息管理 manager*/
@interface XDUserManager : NSObject
@property (nonatomic,strong)NSString *apiKey;
@property (nonatomic,strong)NSString *apiSecret;
@property (nonatomic,strong)NSString *icon;
@property (nonatomic,strong)NSString *nick;
@property (nonatomic,strong)NSString *notify;
@property (nonatomic,strong)NSString *userClientId;
+ (XDUserManager*)sharedInstance;
//- (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *)mobile;
@end
