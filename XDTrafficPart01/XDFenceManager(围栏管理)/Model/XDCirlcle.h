//
//  XDCirlcle.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/28.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface XDCirlcle : MACircle
/**状态是否开启*/
@property (nonatomic,strong)NSString *status;
/**颜色填充是否是实心*/
@property (nonatomic,assign)BOOL colorsStatus;
/**围栏名称*/
@property (nonatomic,strong )NSString *fenceName;
/**围栏ID*/
@property (nonatomic,strong )NSString *fenceID;
/**围栏索引*/
@property (nonatomic,assign)int indexNum;
/***/
+ (MACircleRenderer *)creatRendererWith:(id)circle;
@end
