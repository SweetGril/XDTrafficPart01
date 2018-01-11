//
//  XDCirlcle.m
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/28.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "XDCirlcle.h"

@implementation XDCirlcle
+ (MACircleRenderer *)creatRendererWith:(id)overlay{
    XDCirlcle *circleobj = (XDCirlcle *)overlay;
    MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
    circleRenderer.lineWidth   = 4.f;
    if ([circleobj.status isEqualToString:@"on"]==YES) {
        if (circleobj.colorsStatus == NO) {
            circleRenderer.fillColor = [UIColor clearColor];
        }
        else{
            circleRenderer.fillColor = [UIColor colorWithHexString:@"FFA0A0" withAlpha:0.5];
        }
        circleRenderer.strokeColor = [UIColor colorWithHexString:@"bf0000" withAlpha:1];
    }
    else{
        if (circleobj.colorsStatus == NO) {
            circleRenderer.fillColor = [UIColor clearColor];
        }
        else{
            circleRenderer.fillColor = [UIColor colorWithHexString:@"#c0c0c0" withAlpha:0.5];
        }
        circleRenderer.strokeColor = [UIColor colorWithHexString:@"#c0c0c0"];
    }

    return circleRenderer;
}
@end
