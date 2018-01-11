//
//  FunBox.m
//  TrafficAPP
//
//  Created by xiao dou on 2017/8/9.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "FunBox.h"
int64_t javaByteToInt64(uint8_t* bytes) {
#if __BYTE_ORDER == __BIG_ENDIAN
    int64_t value = 0;
    for (int i = 1; i < 9; i++) {
        ((uint8_t*)&value)[i-1] = bytes[i];
    }
    return value;
#else
    return ((int64_t*)bytes)[0];
#endif
}

@implementation FunBox

+ (FunBox *) sharedAmap
{
    static  FunBox *search = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        search = [[FunBox alloc] init];
        
    });
    return  search;
}

/**
 根据时间戳计算时间显示 yyyy-MM-dd HH:ss
 */
+ (NSString *)timeWithMoreString:(NSString *)timeStr
{
    if ([timeStr isEqualToString:@"4133952000000"]==YES) {
        return @"永久有效";
    }
    NSString * timeStampString = timeStr;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [objDateformat stringFromDate: date];
}
/**
 json格式字符串转字典：
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
/**
 字典转json格式字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *placeInfoStr = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
    return placeInfoStr;
}
/**
 字典转json格式字符串
 */
+(NSString *)byteTimeStr:(Byte *)testByte{
    
    long long timeStr = javaByteToInt64(testByte);
    NSString *stopTime = [NSString stringWithFormat:@"%lld",timeStr];
    return stopTime;
}

@end
