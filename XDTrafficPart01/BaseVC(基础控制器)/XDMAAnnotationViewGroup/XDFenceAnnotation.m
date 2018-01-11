//
//  XDFenceAnnotation.m
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "XDFenceAnnotation.h"
#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0
@interface XDFenceAnnotation ()
@property (nonatomic, strong) UILabel *nameLabel;
@end
@implementation XDFenceAnnotation

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
   CGSize lblSize = [name boundingRectWithSize:CGSizeMake(120, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    self.nameLabel.text = name;
    self.nameLabel.frame =CGRectMake(0,0, lblSize.width+30,30);
    [iconImgView removeFromSuperview];
    iconImgView = [[UIImageView alloc] init];
    iconImgView.image=[UIImage imageNamed:@"fence-center"];
    iconImgView.center = CGPointMake(self.nameLabel.center.x, self.nameLabel.center.y+30);
    iconImgView.bounds = CGRectMake(0, 0, 35, 35);
    [self addSubview:iconImgView];
    self.bounds = CGRectMake(0.f, 0.f, lblSize.width+30, 70);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected){
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.clipsToBounds = YES;
        self.nameLabel.layer.cornerRadius =15;
        self.nameLabel.backgroundColor  = [UIColor colorWithWhite:1 alpha:0.7];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor blackColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:16];
        self.canShowCallout = NO;
        self.draggable = NO;
        self.centerOffset =CGPointMake(0, -30);
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
