//
//  XDNetWork.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDNetWork.h"
@interface XDNetWork()
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end
@implementation XDNetWork

+ (XDNetWork *) sharedInstance
{
    static  XDNetWork *sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        //初始化自己
        sharedInstance = [[self alloc] init];
        //实例化请求对象
        sharedInstance.manager = [AFHTTPSessionManager manager];
        //设置请求和接收数据类型(JSON)
        sharedInstance.manager.responseSerializer = [AFJSONResponseSerializer serializer];                //响应
        sharedInstance.manager.responseSerializer.acceptableContentTypes =[NSSet  setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        //设置请求超时的时间(8s)
        sharedInstance.manager.requestSerializer.timeoutInterval = 18.0f;
    });
    return  sharedInstance;
}

/**
 基础的网络请求
 */
- (void)postRequestWithUrl:(NSString *)url andParameters:(NSDictionary *)dic success:(void (^)(NSDictionary *success))success failure:(void (^)(NSError *failure))failure
{
    NSString * cookie = [[NSUserDefaults standardUserDefaults] objectForKey:@"KHFCOOKIEKEY"];
    if (!kStringIsEmpty(cookie)) {
        [self.manager.requestSerializer setValue:cookie forHTTPHeaderField:@"cookie"];
    }
    
    NSString * apiKey = [XDUserManager sharedInstance].apiKey;
    if (!kStringIsEmpty(apiKey)) {
        [self.manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"apiKey"];
    }
    
    NSString * apiSecret = [XDUserManager sharedInstance].apiSecret;
    if (!kStringIsEmpty(apiSecret)) {
        [self.manager.requestSerializer setValue:apiSecret forHTTPHeaderField:@"apiSecret"];
    }
    [self.manager.requestSerializer setValue:@"0.0.3" forHTTPHeaderField:@"apiVersion"];
    [self.manager.requestSerializer setValue:@"1.0.1" forHTTPHeaderField:@"appVersion"];
    
    [self.manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self getRequestHeaderCookie:task];
        NSDictionary *dataDic =(NSDictionary *)responseObject;
        //用户被挤下线
        if ([dataDic[@"code"] intValue]==401) {
            
            NSLog(@"====用户被挤下线====");
//            LoginViewController *loginView = [[LoginViewController alloc] init];
//            UINavigationController * navigationView = [[UINavigationController alloc]initWithRootViewController:loginView];
//            navigationView.navigationBarHidden = YES;
//            [AppDelegate appDelegate].window.rootViewController = navigationView;
            
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}
#pragma mark- 获取请求头cookie信息
-(void)getRequestHeaderCookie:(NSURLSessionDataTask * )task{
    // 获取所有数据报头信息
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
    if (fields) {
        NSString * set_cookie = [fields objectForKey:@"Set-Cookie"];
        if (set_cookie && set_cookie.length > 0) {
            NSArray * cookies = [set_cookie componentsSeparatedByString:@";"];
            if (cookies) {
                NSString * hfcookie = cookies.firstObject;
                if (hfcookie && hfcookie.length > 0) {
                    [[NSUserDefaults standardUserDefaults] setValue:hfcookie forKey:@"KHFCOOKIEKEY"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }
}

@end
