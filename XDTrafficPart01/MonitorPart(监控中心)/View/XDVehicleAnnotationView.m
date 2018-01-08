//
//  XDVehicleAnnotationView.m
//  AiMapDemo
//
//  Created by xiao dou on 2017/10/26.
//  Copyright © 2017年 xiao dou. All rights reserved.
//
#import "XDVehicleAnnotationView.h"
#define kWidth  146
#define kHeight 90
#define kHoriMargin 5.f
#define kVertMargin 5.f
@implementation XDVehicleAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self){
        UILongPressGestureRecognizer*longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration=0.8;//定义按的时间
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        [self creatBubble];
        self.pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 90-50, self.frame.size.width-100, 50)];
        self.pointImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.pointImageView];
        
        _tipImgViewIcon =[[UIImageView alloc] init];
        _tipImgViewIcon.center = CGPointMake(_pointImageView.center.x, 40.4);
        _tipImgViewIcon.bounds = CGRectMake(0, 0, 15, 6);
        _tipImgViewIcon.image =[UIImage imageNamed:@"gray-j"];
        [self addSubview:_tipImgViewIcon];
        [self addGestureRecognizer:longPress];
        UITapGestureRecognizer *tapSuperGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuperView:)];
        [self addGestureRecognizer:tapSuperGesture];

        self.canShowCallout = NO;
        self.draggable = NO;
        self.calloutOffset = CGPointMake(0, -5);
    }
    return self;
}

-(void)btnLong:(UILongPressGestureRecognizer*)gestureRecognizer{
    if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
        if ([self.delegate respondsToSelector:@selector(clickEditLongTouchModel:andAnnotation:)]) {
            [self.delegate clickEditLongTouchModel:_modelObj andAnnotation:self];
        }
    }
}
- (void)tapSuperView:(UITapGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(clickEditSingleTouchModel:andAnnotation:)] ){
        [self.delegate clickEditSingleTouchModel:_modelObj andAnnotation:self];
    }
}
- (void)setSelected:(BOOL)selected{
    [self setSelected:selected animated:NO];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected ==NO) {
           self.calloutView.infoLab.backgroundColor =[UIColor colorWithHexString:@"#4d4d4d" withAlpha:0.7];
         _tipImgViewIcon.image =[UIImage imageNamed:@"gray-j"];
        if (_typeNum==1) {
            self.pointImageView.image =[UIImage imageNamed:@"device-icon"];
        }
        else if (_typeNum==2){
           self.pointImageView.image =[UIImage imageNamed:@"motorbike"];
        }
        else if (_typeNum==3){
            self.pointImageView.image =[UIImage imageNamed:@"monitoring_noPoint"];
        }
    }
    else{
         _tipImgViewIcon.image =[UIImage imageNamed:@"red-j"];
       self.calloutView.infoLab.backgroundColor =[UIColor colorWithHexString:@"#d0021b" withAlpha:0.7];
        if (_typeNum==1) {
            self.pointImageView.image =[UIImage imageNamed:@"Fill_icon"];
        }
        else if (_typeNum==2){
            self.pointImageView.image =[UIImage imageNamed:@"hdmotorbike"];
       }
        else if (_typeNum==3){
           self.pointImageView.image =[UIImage imageNamed:@"monitoring_point"];
        }
    }
}

- (void)creatBubble{
    if (self.calloutView == nil)
    {
        self.calloutView = [[XDCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    }
    [self addSubview:self.calloutView];
}
- (void)setTypeType:(float)typeType{
    _typeNum = typeType;
    if (typeType==1) {
        self.pointImageView.image =[UIImage imageNamed:@"device-icon"];
    }
    else if (typeType==2){
        self.pointImageView.image =[UIImage imageNamed:@"motorbike"];
    }
    else if (typeType==3){
        self.pointImageView.image =[UIImage imageNamed:@"monitoring_noPoint"];
    }
}
- (void)setModelObj:(EquipmentModel *)modelObj{
    _modelObj = modelObj;
    if (_modelObj.deviceName.length>5) {
        NSString *string2 = [_modelObj.deviceName substringToIndex:4];
        _modelObj.deviceName = [NSString stringWithFormat:@"%@... ",string2];
    }
    NSString *contentStr= [NSString stringWithFormat:@"%@ %.1fkm/h",_modelObj.deviceName,_modelObj.speed];
    if (_modelObj.speed == 0) {
        contentStr = [NSString stringWithFormat:@"%@ 静止",_modelObj.deviceName];
    }
    self.calloutView.infoStr = contentStr;
   
}

@end
