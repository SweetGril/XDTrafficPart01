//
//  XDCricleModel.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/14.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 这里面是有两个数据元素的
 */
@interface XDCricleModel : NSObject
@property(nonatomic,strong) NSString *expired;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *scope;
@property(nonatomic,strong) NSString *shape;
@property(nonatomic,assign) float  deviceLat;
@property(nonatomic,assign) float  deviceLng;
@property(nonatomic,strong) NSString * deviceRadius;
@property(nonatomic,strong) NSString * location;
@property(nonatomic,strong) NSString * scopeId;
@property(nonatomic,strong)NSString *scopeName;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)BOOL statusBool;
/**
多边形的点数组信息
 */
@property(nonatomic,strong)NSMutableArray *allPointlocationArray;
@end
