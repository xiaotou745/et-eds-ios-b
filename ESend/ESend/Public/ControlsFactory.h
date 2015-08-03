//
//  ControlsFactory.h
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControlsFactory : NSObject

+ (UILabel *)label1WithFrame:(CGRect)frame text:(NSString *)title superView:(UIView *)view;

+ (UILabel *)label2WithFrame:(CGRect)frame text:(NSString *)title superView:(UIView *)view;

+ (UILabel *)label3WithFrame:(CGRect)frame text:(NSString *)title superView:(UIView *)view;

@end
