//
//  CustomTextField.h
//  SuperMark2.0
//
//  Created by 永来 付 on 14/10/29.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

//失去焦点时左侧视图
@property (nonatomic, strong) UIView *normalLeftView;
//获取焦点时左侧视图
@property (nonatomic, strong) UIView *highlightLeftView;

//失去焦点时边框颜色
@property (nonatomic, strong) UIColor *normalBorderColor;
//获取焦点时边框颜色
@property (nonatomic, strong) UIColor *highlightBorderColor;

//失去焦点时背景色
@property (nonatomic, strong) UIColor *normalBackgroundColor;
//获取焦点时背景色
@property (nonatomic, strong) UIColor *highlightBackgroundColor;

//边框宽度
@property (nonatomic, assign) CGFloat borderWitdh;

@end
