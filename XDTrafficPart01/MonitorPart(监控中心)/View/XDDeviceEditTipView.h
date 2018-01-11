//
//  XDDeviceEditTipView.h
//  TrafficAPP
//
//  Created by xiao dou on 2017/9/30.
//  Copyright © 2017年 xiao dou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipmentModel.h"
@interface XDDeviceEditTipView : UIView<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextField *deviceName;
@property (strong, nonatomic) IBOutlet UILabel *speedLab;
@property (strong, nonatomic)EquipmentModel *modelObject;
/**按钮block*/
@property (copy, nonatomic)void (^setDeviceClick)();
+(instancetype)shareTipViewWithFrame:(CGRect)objFrame;
@end
