//
//  XDDetailsPartView.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDetailsPartView : UIView
/**定位追踪按钮*/
@property (strong, nonatomic) IBOutlet UIButton *orientationBtn;
/**历史轨迹按钮*/
@property (strong, nonatomic) IBOutlet UIButton *historyBtn;
/**按钮block*/
@property (copy, nonatomic)void (^detailViewPartClick)(UIButton *selectbtn);
/**初始化创建*/
+(instancetype)shareDetailsPartViewWithFrame:(CGRect)objFrame;
@end
