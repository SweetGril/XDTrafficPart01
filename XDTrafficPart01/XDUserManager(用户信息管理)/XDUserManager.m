//
//  XDUserManager.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDUserManager.h"

static  XDUserManager *_userManager;
/**用户信息管理 manager*/
@implementation XDUserManager
+ (XDUserManager*)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userManager = [[XDUserManager alloc] init];
    });
    return _userManager;
}
/**登录*/
- (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *)password success:(void (^)(NSDictionary *success))successBlock failure:(void (^)(NSError *failure))failureBlock{
    if (!kStringIsEmpty(_userManager.userClientId)) {
         successBlock(nil);
        return;
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:mobile forKey:@"mobile"];
    [dataDic setValue:password forKey:@"password"];
    NSString *url = APIHEADStr(@"/user/login");
    [[XDNetWork sharedInstance]postRequestWithUrl:url andParameters:dataDic success:^(NSDictionary *success) {
        NSMutableDictionary *dataDic =[[NSMutableDictionary alloc] initWithDictionary:success[@"data"]];
        if ([success[@"code"] intValue]==200) {
            NSString *clientString =dataDic[@"userClientId"];
            if (!kStringIsEmpty(clientString)) {
                [dataDic setValue:mobile forKey:@"phoneNum"];
                [self insertDataToManager:dataDic];
                NSMutableData *data = [[NSMutableData alloc] initWithCapacity:0];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                [archiver encodeObject:dataDic];
                [archiver finishEncoding];
                [data writeToFile:[self getFilePath] atomically:YES];
            }
            successBlock(nil);
        }
    } failure:^(NSError *failure) {
        failureBlock(failure);
    }];
}
/**读取本地保存的信息*/
- (void)readLocationData{
    NSData *data = [NSData dataWithContentsOfFile:[self getFilePath]];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dataDic = [unArchiver decodeObject];
    [self insertDataToManager:dataDic];
    [unArchiver finishDecoding];
}


/**清除本地保存的个人信息*/
- (void)clearUserData{
    _userManager.icon = @"";
    _userManager.nick = @"";
    _userManager.phoneNum = @"";
    _userManager.apiKey = @"";
    _userManager.apiSecret = @"";
    _userManager.notify = @"";
    _userManager.userClientId = @"";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDelete=[fileManager removeItemAtPath:[self getFilePath] error:nil];
    NSLog(@"%d",isDelete);
}

- (void)insertDataToManager:(NSDictionary *)dataDic{
    _userManager.icon =dataDic[@"icon"];
    _userManager.nick=dataDic[@"nick"];
    _userManager.phoneNum=dataDic[@"phoneNum"];
    _userManager.apiKey = dataDic[@"apiKey"];
    _userManager.apiSecret = dataDic[@"apiSecret"];
    _userManager.notify = dataDic[@"notify"];
    _userManager.userClientId =dataDic[@"userClientId"];
}
- (NSString *)getFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *file = [path stringByAppendingPathComponent:@"person.data"];
    return file;
}
@end
