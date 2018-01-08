//
//  XDClloctionManager.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 位置管理类方法 CLLocation
 */
@interface XDClloctionManager : NSObject
/**当前定位的坐标*/
@property (nonatomic,assign) CLLocationCoordinate2D nowPoint;
+ (XDClloctionManager *)sharedManager;
@end
