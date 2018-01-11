//
//  XDDetailsPartView.m
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "XDDetailsPartView.h"

@implementation XDDetailsPartView

+(instancetype)shareDetailsPartViewWithFrame:(CGRect)objFrame{
    XDDetailsPartView * sliderView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    sliderView.frame = objFrame;
    return sliderView;
}
- (IBAction)detailViewBtnClick:(UIButton *)sender {
    if (_detailViewPartClick) {
        _detailViewPartClick(sender);
    }
}
@end
