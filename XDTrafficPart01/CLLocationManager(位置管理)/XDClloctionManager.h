//
//  XDClloctionManager.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
/**
 位置管理类方法 CLLocation
 */
@interface XDClloctionManager : NSObject<AMapSearchDelegate>
/**当前定位的坐标*/
@property (nonatomic,assign) CLLocationCoordinate2D nowPoint;
@property (nonatomic,strong)AMapSearchAPI *search;
@property(copy,nonatomic) void (^addressBlock)(NSString * addressStr,NSString *topic);
@property(copy,nonatomic) void (^addressSecondBlock)(NSString * addressStr,int cellNum,int indexNum);
+ (XDClloctionManager *)sharedManager;
/**单行查询*/
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate withTopic:(NSString *)topicString;
/**
 单行 多次查询
 每行都有两个地理位置
 */
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate withIntIndex:(int)index andCellNum:(int)cellNum;
/**判断点是否在为列表中*/
+(id)isIncludePointAtCoordinate:(CLLocationCoordinate2D)coordinate andShapeLine:(NSMutableArray *)fenceArray;
@end
