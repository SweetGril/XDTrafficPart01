//
//  XDMAPointAnnotation.h
//  AiMapDemo
//
//  Created by xiao dou on 2017/11/2.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "EquipmentModel.h"
@interface XDMAPointAnnotation : MAPointAnnotation
@property (nonatomic,assign)float typeType;
@property (nonatomic,strong)EquipmentModel *model;
@end
