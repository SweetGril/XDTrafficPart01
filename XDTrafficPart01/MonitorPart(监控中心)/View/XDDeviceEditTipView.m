//
//  XDDeviceEditTipView.m
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/30.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import "XDDeviceEditTipView.h"

@implementation XDDeviceEditTipView
+(instancetype)shareTipViewWithFrame:(CGRect)objFrame{
    XDDeviceEditTipView * tipView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    tipView.frame = objFrame;
    tipView.bgView.clipsToBounds = YES;
    tipView.bgView.layer.cornerRadius =25;
    tipView.deviceName.returnKeyType = UIReturnKeyDone;
    [tipView.deviceName becomeFirstResponder];
    return tipView;
}
//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (kStringIsEmpty(textField.text)) {
        return YES;
    }
    [self keepTitleWithNssString:textField.text];
    [textField resignFirstResponder];//取消第一响应者
    return YES;
}
- (IBAction)deleteBtnClick:(id)sender {
    _deviceName.text =@"";
}
#pragma mark 编辑设备名称保存
- (void)keepTitleWithNssString:(NSString *)titleStr{
    NSString *url =[NSString stringWithFormat:@"%@/device/update",APIHEADStr];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:_modelObject.deviceId forKey:@"deviceId"];
    [dataDic setValue:titleStr forKey:@"deviceName"];
    _modelObject.deviceName = titleStr;
    [[XDNetWork sharedInstance]postRequestWithUrl:url andParameters:dataDic success:^(NSDictionary *success) {
        if ([success[@"code"] intValue]==200) {
            [[XDDeviceManager sharedManager].allDeviceDictionary setValue:_modelObject forKey:_modelObject.realTopic];
            if (_setDeviceClick) {
                _setDeviceClick();
            }
        }
    } failure:^(NSError *failure) {
        if (_setDeviceClick) {
            _setDeviceClick();
        }
    }];
}

@end
