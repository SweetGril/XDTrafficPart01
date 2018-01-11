//
//  XDFenceAnnotation.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
/**围栏点击后的显示*/
@interface XDFenceAnnotation : MAAnnotationView
{
    UIImageView *iconImgView;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIView *calloutView;

@end
