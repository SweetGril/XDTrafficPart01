//
//  XDDeviceManager.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/8.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDDeviceManager.h"
#import "EquipmentModel.h"
/**
 设备管理类方法 
 */
static XDDeviceManager *_manager;
@implementation XDDeviceManager

+ (XDDeviceManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[XDDeviceManager alloc] init];
    });
    return _manager;
}
- (void)postDeviceListsuccess:(void (^)(NSDictionary *success))successBlock
                      failure:(void (^)(NSError *failure))failureBlock{
    NSString *url = APIHEADStr(@"/device/list");
    if (_allDeviceDictionary.allKeys.count!=0) {
        successBlock(nil);
    }
    _allDeviceDictionary = [[NSMutableDictionary alloc] init];
    [[XDNetWork sharedInstance]postRequestWithUrl:url andParameters:nil success:^(NSDictionary *success) {
        NSDictionary *listDic =success[@"data"];
        NSArray *listDeviceArray =listDic[@"list"];
        NSMutableDictionary *topicDic =[[NSMutableDictionary alloc] init];
        NSMutableArray *topicArray = [[NSMutableArray alloc] init];
        for (int a=0; a<listDeviceArray.count; a++){
            EquipmentModel *model =[EquipmentModel yy_modelWithJSON:listDeviceArray[a]];
            [topicDic setValue:model.realTopic forKey:model.realTopic];
            [topicArray addObject:model.realTopic];
            [_allDeviceDictionary setObject:model forKey:model.realTopic];
        }
        successBlock(nil);
    } failure:^(NSError *failure) {
        failureBlock(nil);
    }];
}

- (NSMutableDictionary *)getDeviceDictionary{
    NSLog(@"----_allDeviceDictionary---%@",_allDeviceDictionary);
    return _allDeviceDictionary;
}
@end
