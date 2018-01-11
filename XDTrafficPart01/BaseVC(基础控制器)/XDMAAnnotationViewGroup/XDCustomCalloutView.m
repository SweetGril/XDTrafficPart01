//
//  XDCustomCalloutView.m
//  AiMapDemo
//
//  Created by xiao dou on 2017/10/26.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "XDCustomCalloutView.h"

@implementation XDCustomCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.infoLab =[[UILabel alloc] init];
        [self addSubview:self.infoLab];
    }
    return self;
}
- (void)setInfoStr:(NSString *)infoStr{
    
    self.infoLab.font = [UIFont systemFontOfSize:13];
    self.infoLab.text =infoStr;
    self.infoLab.numberOfLines = 0;//多行显示，计算高度
    self.infoLab.textAlignment = NSTextAlignmentCenter;
    self.infoLab.textColor = [UIColor whiteColor];
    self.infoLab.backgroundColor =[UIColor colorWithHexString:@"#4d4d4d" withAlpha:0.7];
    self.infoLab.clipsToBounds = YES;
    
    CGSize lblSize = [self.infoLab.text boundingRectWithSize:CGSizeMake(120, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if (lblSize.width<130&&self.infoLab.text.length>5) {
        lblSize.width=130;
    }
    self.infoLab.bounds = CGRectMake(0, 0, lblSize.width+10, lblSize.height+10);
    self.infoLab.center = self.center;
    self.infoLab.layer.cornerRadius =lblSize.height/2+5;
    
}

@end
