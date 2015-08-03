//
//  ControlsFactory.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ControlsFactory.h"

@implementation ControlsFactory

+ (UILabel *)label1WithFrame:(CGRect)frame text:(NSString *)title superView:(UIView *)view{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text          = title;
    label.textColor     = LightGrey;
    label.font          = FONT_SIZE(NormalFontSize);
    label.numberOfLines = 0;
    [view addSubview:label];
    
    return label;
}

+ (UILabel *)label2WithFrame:(CGRect)frame text:(NSString *)title superView:(UIView *)view{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text          = title;
    label.textColor     = [UIColor blackColor];
    label.font          = FONT_SIZE(NormalFontSize);
    label.numberOfLines = 0;
    [view addSubview:label];
    
    
    return label;
}

+ (UILabel *)label3WithFrame:(CGRect)frame text:(NSString *)title superView:(UIView *)view{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text          = title;
    label.textColor     = MiddleGrey;
    label.font          = FONT_SIZE(NormalFontSize);
    label.numberOfLines = 0;
    [view addSubview:label];
    
    
    return label;
}

@end
