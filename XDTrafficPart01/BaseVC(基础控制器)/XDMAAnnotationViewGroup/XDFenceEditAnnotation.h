//
//  XDFenceEditAnnotation.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
/**围栏编辑时的类型*/
@interface XDFenceEditAnnotation : MAAnnotationView<UITextFieldDelegate>{
    UILabel *statusLab;
    UIButton *statusBtn;
    int _indexNum;
}
@property (nonatomic,strong)UITextField *fenceField;
/**围栏是否时选中状态*/
@property (nonatomic,assign)BOOL isStatus;
@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic,assign)int indexNum;
@end
