//
//  XDMAPolygon.h
//  XDTrafficPart01
//
//  Created by xiao dou on 2018/1/10.
//  Copyright © 2018年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface XDMAPolygon : MAPolygon
@property (nonatomic,assign)int indexNum;//在绘制的过程中链条中的位置个数
@property (nonatomic,assign)BOOL isCheck; //作为展示的点
/**状态是否开启*/
@property (nonatomic,strong)NSString *status;
/**填充是否实心*/
@property (nonatomic,assign)BOOL isColorStatus;
/**围栏名称*/
@property (nonatomic,strong )NSString *fenceName;
/**围栏ID*/
@property (nonatomic,strong )NSString *fenceID;
@property (nonatomic,assign)CLLocationCoordinate2D *polyLine;
/**围栏索引*/
@property (nonatomic,assign)int fenceindexNum;
@end
