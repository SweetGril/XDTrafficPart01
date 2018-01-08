//
//  FunBox.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/9.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunBox : NSObject

+ (FunBox *) sharedAmap;
/**
 json格式字符串转字典：
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 字典转json格式字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/**
 根据时间戳计算时间显示 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)timeWithMoreString:(NSString *)timeStr;

@end
