//
//  XDFenceManager.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/10.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDFenceManager.h"
#import "XDCricleModel.h"
/**
 设备管理类方法
 */
static XDFenceManager *_fenceManager;
@implementation XDFenceManager
+ (XDFenceManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fenceManager = [[XDFenceManager alloc] init];
    });
    return _fenceManager;
}

- (void)postFenceDicSuccess:(void (^)(NSDictionary *success))successBlock
                    failure:(void (^)(NSError *failure))failureBlock{
    NSString *url = APIHEADStr(@"/scope/list");
    if (_allFenceArray.count!=0) {
        successBlock(nil);
    }
    else{
        _allFenceArray = [[NSMutableArray alloc] init];
        [[XDNetWork sharedInstance]postRequestWithUrl:url andParameters:nil success:^(NSDictionary *success) {
            NSDictionary *listDic =success[@"data"];
            NSArray *listDeviceArray =listDic[@"list"];
            
            for (int a=0; a<listDeviceArray.count; a++) {
                XDCricleModel *model =[XDCricleModel yy_modelWithJSON:listDeviceArray[a]];
                NSDictionary *shapeDic = [FunBox dictionaryWithJsonString:model.scope];
                if ([model.status isEqualToString:@"on"]==YES){
                    model.statusBool = YES;
                }
                else{
                    model.statusBool = NO;
                }
                model.shape = shapeDic[@"shape"];
                model.location = shapeDic[@"location"];
                //圆形数据
                if ([model.shape isEqualToString:@"circle"]==YES) {
                    NSDictionary *scopeDic = shapeDic[@"scope"];
                    NSDictionary *centerDic = scopeDic[@"center"];
                    model.deviceLng = [centerDic[@"lon"] floatValue];
                    model.deviceLat = [centerDic[@"lat"] floatValue];
                    model.deviceRadius = scopeDic[@"radius"];
                }
                else{
                    NSArray *vertexesArray =shapeDic[@"vertexes"];
                    NSDictionary *centerDic = shapeDic[@"center"];
                    model.deviceLat = [centerDic[@"lat"] floatValue];
                    model.deviceLng = [centerDic[@"lon"] floatValue];
                    model.allPointlocationArray =[[NSMutableArray alloc] init];
                    for (int a= 0; a<vertexesArray.count; a++) {
                        NSDictionary *locationDic = vertexesArray[a];
                        CLLocationCoordinate2D  paert2D=CLLocationCoordinate2DMake([locationDic[@"lat"] floatValue], [locationDic[@"lon"] floatValue]);
                        CLLocation *towerLocation = [[CLLocation alloc] initWithLatitude:paert2D.latitude longitude:paert2D.longitude];
                        [model.allPointlocationArray addObject:towerLocation];
                    }
                }
                [_allFenceArray addObject:model];
            }
            successBlock(nil);
        } failure:^(NSError *failure) {
            failureBlock(nil);
        }];
    }
    
}
/**获取所有的设备 列表信息*/
- (NSMutableArray *)allFenceArray{
    NSLog(@"----_allFenceDic---%@",_allFenceArray);
    return _allFenceArray;
}
@end
