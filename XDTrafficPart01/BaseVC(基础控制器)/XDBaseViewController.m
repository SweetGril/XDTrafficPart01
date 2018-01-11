//
//  XDBaseViewController.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDBaseViewController.h"
#import "XDClientManager.h"
#import "XDMqttMessage.h"
@interface XDBaseViewController (){
    
}
@end

@implementation XDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设备移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liveManagerDidReceiveMessage:) name:XDMoveReceiveMessageNotification object:nil];
}

-(void)liveManagerDidReceiveMessage:(NSNotification *)notifi{
}

- (void)dealloc{
    NSLog(@"----%s-dealloc-",__func__);
      [[NSNotificationCenter defaultCenter] removeObserver:self name:XDMoveReceiveMessageNotification object:nil];
//     [[XDClloctionManager sharedManager] removeObserver:self forKeyPath:@"allDeviceDictionary"];
}
@end
