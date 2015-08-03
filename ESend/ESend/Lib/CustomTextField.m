//
//  CustomTextField.m
//  SuperMark2.0
//
//  Created by 永来 付 on 14/10/29.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
        self.tintColor = [UIColor blueColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeyNext;
        self.font = [UIFont systemFontOfSize:BigFontSize];
        self.layer.cornerRadius = 5;
        self.layer.backgroundColor = self.normalBorderColor.CGColor;
        
    }
    return self;
}

- (void)setNormalLeftView:(UIView *)normalLeftView {
    _normalLeftView = normalLeftView;
    self.leftView = normalLeftView;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    _normalBackgroundColor = normalBackgroundColor;
    self.layer.backgroundColor = normalBackgroundColor.CGColor;
}

- (void)setNormalBorderColor:(UIColor *)normalBorderColor {
    _normalBorderColor = normalBorderColor;
    self.layer.borderColor = normalBorderColor.CGColor;
}

- (void)setBorderWitdh:(CGFloat)borderWitdh {
    _borderWitdh = borderWitdh;
    self.layer.borderWidth = borderWitdh;
}

- (BOOL) becomeFirstResponder {
    
    self.leftView = self.highlightLeftView ? self.highlightLeftView : self.normalLeftView;
    
    self.layer.borderColor = self.highlightBorderColor.CGColor;
    self.layer.borderWidth = self.borderWitdh;
    self.layer.backgroundColor = self.highlightBackgroundColor.CGColor;
    return [super becomeFirstResponder];
}

- (BOOL) resignFirstResponder {
    
    self.leftView = self.normalLeftView;
    
    self.layer.borderColor = self.normalBorderColor.CGColor;
    self.layer.borderWidth = self.borderWitdh;
    self.layer.backgroundColor = self.normalBackgroundColor.CGColor;

    return [super resignFirstResponder];
}

@end
