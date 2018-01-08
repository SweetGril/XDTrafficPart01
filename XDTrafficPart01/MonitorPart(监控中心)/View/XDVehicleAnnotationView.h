//
//  XDVehicleAnnotationView.h
//  AiMapDemo
//
//  Created by xiao dou on 2017/10/26.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "XDCustomCalloutView.h"
#import "EquipmentModel.h"
@class XDVehicleAnnotationView;
@protocol XDVehicleAnnotationViewDelegate <NSObject>
@optional
- (void)clickEditLongTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView;
- (void)clickEditSingleTouchModel:(EquipmentModel *)modelObj andAnnotation:(XDVehicleAnnotationView *)annotationView;
@end

@interface XDVehicleAnnotationView : MAAnnotationView
{
    float _typeNum;
    EquipmentModel *_modelObj;
}
@property (nonatomic,strong) UIImageView *tipImgViewIcon;
@property (nonatomic, strong) XDCustomCalloutView *calloutView;
@property (nonatomic, strong) UIImageView *pointImageView;
@property (nonatomic,assign)float typeType;
@property (nonatomic , weak) id<XDVehicleAnnotationViewDelegate> delegate;
@property (nonatomic,strong)EquipmentModel *modelObj;
/**
 进行编辑按钮点击回调
 */
@property (copy, nonatomic)void (^clickEditButton)(NSString *titleStr);
@end
