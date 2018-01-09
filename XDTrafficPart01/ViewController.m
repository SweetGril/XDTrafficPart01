//
//  ViewController.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "ViewController.h"
#import "XDMonitoViewController.h"

@interface ViewController ()
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if ([self isFileExist:@"person.data"]==YES) {

        [[XDUserManager sharedInstance] readLocationData];
        [[XDMaqttClientManger sharedInstance] connectMqtt];
       
//       UIWindow *myWindow = [UIApplication sharedApplication].keyWindow;
//        XDMonitoViewController *vc =[[XDMonitoViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        myWindow.rootViewController = nav;
        XDMonitoViewController *vc =[[XDMonitoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [[XDUserManager sharedInstance]loginWithMobile:@"13625811915" andPassword:@"111111" success:^(NSDictionary *success) {
              [[XDMaqttClientManger sharedInstance] connectMqtt];
//            UIWindow *myWindow = [UIApplication sharedApplication].keyWindow;
//            XDMonitoViewController *vc =[[XDMonitoViewController alloc] init];
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            myWindow.rootViewController = nav;
            XDMonitoViewController *vc =[[XDMonitoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(NSError *failure) {
        
        }];
    }
}



-(BOOL) isFileExist:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
