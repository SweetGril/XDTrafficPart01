//
//  XDClloctionManager.m
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/5.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import "XDClloctionManager.h"
#import "XDAMapReGeocodeSearchRequest.h"
#import "XDMAPolygon.h"
static XDClloctionManager *_manager;
/**位置管理类方法 CLLocation */
@implementation XDClloctionManager
+ (XDClloctionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[XDClloctionManager alloc] init];
    });
    return _manager;
}
/**判断点是否在为列表中*/
+(id)isIncludePointAtCoordinate:(CLLocationCoordinate2D)coordinate andShapeLine:(NSMutableArray *)fenceArray
{
    id selectShape;
    int verifyNum =0;
    for (int a=0; a<fenceArray.count; a++) {
        id shape = fenceArray[a];
        if ([shape isKindOfClass:[MACircle class]] ) {
            MACircle *circle = (MACircle *)shape;
            if (MACircleContainsCoordinate(coordinate, circle.coordinate, circle.radius)) {
                verifyNum ++;
                selectShape = circle;
            }
        }
        else{
            XDMAPolygon *polyline = (XDMAPolygon *)shape;
            if (MAPolygonContainsCoordinate(coordinate, polyline.polyLine, polyline.pointCount)) {
                verifyNum ++;
                selectShape = polyline;
            }
        }
    }
    
    if (verifyNum==1) {
        return selectShape;
    }
    return nil;
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate withTopic:(NSString *)topicString
{
    if (self.search==nil) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    XDAMapReGeocodeSearchRequest *regeo = [[XDAMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    regeo.topicStr =topicString;
    [self.search AMapReGoecodeSearch:regeo];
}
#pragma mark 计算多行cell，每行都包含地址的情况
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate withIntIndex:(int )index andCellNum:(int)cellNum
{
    if (self.search==nil) {
        self.search =[[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    XDAMapReGeocodeSearchRequest *regeo = [[XDAMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    regeo.indextNum =cellNum;
    regeo.labNum =index;
    regeo.isMore = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil){
        XDAMapReGeocodeSearchRequest *requestObj = (XDAMapReGeocodeSearchRequest *)request;
        if (requestObj.isMore ==NO) {
            if (_addressBlock) {
                _addressBlock(response.regeocode.formattedAddress,requestObj.topicStr);
            }
        }
        else{
            //地址内容，数组位置，行中位置
            if (_addressSecondBlock) {
                _addressSecondBlock(response.regeocode.formattedAddress,requestObj.indextNum,requestObj.labNum);
            }
        }
    }
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}
@end
