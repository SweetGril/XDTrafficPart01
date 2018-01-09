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

//    self.view.backgroundColor = [UIColor orangeColor];
//    XDDeviceManager * deviceManager = [XDDeviceManager sharedManager];
//
//    [deviceManager addObserver:self forKeyPath:@"allDeviceDictionary" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"AAAAA"];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[XDDeviceManager sharedManager].allDeviceDictionary setValue:@"111" forKey:@"1133"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
   
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
