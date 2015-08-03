//
//  PlaceholderTextView.m
//  YXTextView
//
//  Created by YouXianMing on 14/12/23.
//  Copyright (c) 2014年 YouXianMing. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()<UITextViewDelegate>

@property (nonatomic, strong) NSString *string;

@end

@implementation PlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTextView];
    }
    return self;
}

- (void)createTextView {
    self.textView                 = [[UITextView alloc] initWithFrame:self.bounds];
    self.textView.delegate        = self;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor       = [UIColor grayColor];
    [self addSubview:self.textView];
}

#pragma mark - 代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    // 设置编辑状态文字颜色
    textView.textColor = (self.editTextColor == nil ? [UIColor blackColor] : self.editTextColor);
    
    // 如果文字为placeHolder文字
    if ([textView.text isEqualToString:self.placeHolderString]) {
        textView.text = @"" ;
    }
    
    if (_delegete && [_delegete respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        [_delegete textViewShouldBeginEditing:textView];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // 如果长度为0，则显示placeHolder文字
    if (textView.text.length == 0) {
        textView.text      = self.placeHolderString;
        textView.textColor = (self.placeHolderColor == nil ? [UIColor grayColor] : self.placeHolderColor);
    }
    
    return YES ;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (_returnButtonToResignFirstResponder == YES) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    return YES ;
}

- (void)resignTextViewFirstResponder {
    [self.textView resignFirstResponder];
}

#pragma mark - 重写setter，getter方法
@synthesize string = _string;
- (NSString *)string {
    if ([self.textView.text isEqualToString:self.placeHolderString]) {
        return @"";
    } else {
        return self.textView.text;
    }
}

@synthesize placeHolderColor = _placeHolderColor ;
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor       = placeHolderColor ;
    self.textView.textColor = _placeHolderColor;
}

- (UIColor *)placeHolderColor {
    return _placeHolderColor ;
}

@synthesize placeHolderString = _placeHolderString;
- (void)setPlaceHolderString:(NSString *)placeHolderString {
    _placeHolderString = placeHolderString;
    _textView.text     = placeHolderString;
}

- (NSString *)placeHolderString {
    return _placeHolderString;
}

@synthesize textContainerInset = _textContainerInset;
- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    _textContainerInset          = textContainerInset;
    _textView.textContainerInset = textContainerInset;
}

- (UIEdgeInsets)textContainerInset {
    return _textContainerInset;
}

@end