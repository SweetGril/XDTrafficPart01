//
//  XDAMapReGeocodeSearchRequest.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/11/7.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <AMapSearchKit/AMapSearchKit.h>

@interface XDAMapReGeocodeSearchRequest : AMapReGeocodeSearchRequest
@property (nonatomic,assign)int labNum;//行中位置
@property (nonatomic,strong)NSString * topicStr;
@property (nonatomic,assign)BOOL isMore;//多条参数
@property (nonatomic,assign)int indextNum;//数组中位置
@end
