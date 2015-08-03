//
//  PlaceholderTextView.h
//  YXTextView
//
//  Created by YouXianMing on 14/12/23.
//  Copyright (c) 2014年 YouXianMing. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlaceholderTextViewDelete<NSObject>
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView ;
@end
@interface PlaceholderTextView : UIView

@property (nonatomic ,assign) id<PlaceholderTextViewDelete>delegete ;
// 获取的字符串
@property (nonatomic, strong, readonly) NSString *string;

// textView
@property (nonatomic, strong) UITextView  *textView;

// 占位字符
@property (nonatomic, strong) NSString    *placeHolderString;

// 文本边缘留白
@property(nonatomic, assign) UIEdgeInsets  textContainerInset;

// 颜色设置
@property (nonatomic, strong) UIColor     *editTextColor;
@property (nonatomic, strong) UIColor     *placeHolderColor;

// 返回键是否用来做取消第一响应者
@property (nonatomic, assign) BOOL         returnButtonToResignFirstResponder;

// 取消第一响应者
- (void)resignTextViewFirstResponder;

@end