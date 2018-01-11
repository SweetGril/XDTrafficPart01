//
//  XDEditFencePointAntion.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
/**这个是用于围栏编辑查看时的MAPointAnnotation*/
@interface XDEditFencePointAntion : MAPointAnnotation
@property (nonatomic,assign)BOOL fenceStyle;//如果是0查看，1编辑
@property (nonatomic,strong)NSString *titleStr;//围栏名称
@property (nonatomic,assign)int indexNum;
@end
