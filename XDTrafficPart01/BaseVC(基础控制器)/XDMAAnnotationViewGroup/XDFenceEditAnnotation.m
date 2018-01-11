//
//  XDFenceEditAnnotation.m
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/29.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "XDFenceEditAnnotation.h"
#import "XDCricleModel.h"
@implementation XDFenceEditAnnotation
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected){
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}
- (void)setIndexNum:(int)indexNum
{
    _indexNum =indexNum;
    XDCricleModel *modelObject = [XDFenceManager sharedManager].allFenceArray[indexNum];
    _isStatus =modelObject.statusBool;
    if (_isStatus ==NO) {
        statusLab.text =@"OFF";
        statusBtn.selected =NO;
    }
    else{
        statusLab.text =@"ON";
        statusBtn.selected =YES;
    }
}
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        self.bounds = CGRectMake(0.f, 0.f, 180, 110);
        UIImageView *bgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 70)];
        bgView.userInteractionEnabled = YES;
        bgView.clipsToBounds = YES;
        bgView.layer.cornerRadius=20;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, 35, 17)];
        titLab.text = @"名称";
        titLab.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:titLab];
        
        statusLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 40, 35, 17)];
        statusLab.font = [UIFont systemFontOfSize:16];
        statusLab.textColor =[UIColor blackColor];
        [bgView addSubview:statusLab];
        
        self.fenceField = [[UITextField alloc] initWithFrame:CGRectMake(60, 15, 100, 16)];
        self.fenceField.font = [UIFont systemFontOfSize:16];
        self.fenceField.returnKeyType = UIReturnKeyDone;
        self.fenceField.delegate=self;
        [bgView addSubview:self.fenceField];
        
        statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        statusBtn.frame =CGRectMake(60, 40, 45, 20);
        [statusBtn setImage:[UIImage imageNamed:@"ONIcon"] forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"OFFIcon"] forState:UIControlStateSelected];
        [statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:statusBtn];
        
        UIImageView *iconImgView = [[UIImageView alloc] init];
        iconImgView.image=[UIImage imageNamed:@"historiesIconlist"];
        iconImgView.center = CGPointMake(bgView.center.x, 100);
        iconImgView.bounds = CGRectMake(0, 0, 35, 35);
        [self addSubview:iconImgView];
        
        self.canShowCallout = NO;
        self.draggable = NO;
        self.centerOffset =CGPointMake(0, -30);
    }
    return self;
}
//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self editFenceandStatusStr:textField.text];
     [textField resignFirstResponder];//取消第一响应者
    return YES;
}

#pragma mark- 编辑围栏状态
- (void)editFenceandStatusStr:(NSString *)statusStr{
  XDCricleModel *modelObject = [XDFenceManager sharedManager].allFenceArray[_indexNum];
    NSString *url =[NSString stringWithFormat:@"%@/scope/update",APIHEADStr];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:modelObject.scopeId forKey:@"scopeId"];
    [dataDic setValue:statusStr forKey:@"scopeName"];
    modelObject.scopeName = statusStr;
    [[XDNetWork sharedInstance]postRequestWithUrl:url andParameters:dataDic success:^(NSDictionary *success) {
        if ([success[@"code"] intValue]==200) {
            
            [[XDFenceManager sharedManager].allFenceArray replaceObjectAtIndex:_indexNum withObject:modelObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:XDChageFenceNotification object:[NSNumber numberWithInt:_indexNum]];
        }
    } failure:^(NSError *failure) {
    }];
}

- (void)statusBtnClick:(UIButton *)button{
    XDCricleModel *modelObject = [XDFenceManager sharedManager].allFenceArray[_indexNum];
    NSString *url =[NSString stringWithFormat:@"%@/scope/update",APIHEADStr];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:modelObject.scopeId forKey:@"scopeId"];
    if (modelObject.statusBool==YES) {
        [dataDic setValue:@"off" forKey:@"status"];
    }
    else{
         [dataDic setValue:@"on" forKey:@"status"];
    }
    [[XDNetWork sharedInstance]postRequestWithUrl:url andParameters:dataDic success:^(NSDictionary *success) {
        if ([success[@"code"] intValue]==200) {
            button.selected =!button.selected;
            if (button.selected==YES) {
                statusLab.text = @"ON";
            }
            else{
                 statusLab.text = @"OFF";
            }
            modelObject.status = dataDic[@"status"];
            modelObject.statusBool = !modelObject.statusBool;
            [[NSNotificationCenter defaultCenter] postNotificationName:XDChageFenceNotification object:[NSNumber numberWithInt:_indexNum]];
            [[XDFenceManager sharedManager].allFenceArray replaceObjectAtIndex:_indexNum withObject:modelObject];
        }
    } failure:^(NSError *failure) {
        
        
    }];
}
@end
