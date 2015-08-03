//
//  CustomTextView.m
//  SuperMark2.0
//
//  Created by 永来 付 on 14/10/29.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [self addSubview:_imageView];
        [self bringSubviewToFront:_imageView];
//        self.layer.cornerRadius = 6;
//        self.layer.borderColor = [UIColor colorWithHexString:@"87bfeb"].CGColor;
//        self.layer.borderWidth = 0.5;
    
    }
    return self;
}

- (BOOL)resignFirstResponder {
    if ([self.text isEqualToString:@""]) {
        self.text = self.placeholder;
        self.textColor = LightGrey;
    } else {
        self.textColor = DeepGrey;
    }
    self.layer.borderColor = [UIColor colorWithHexString:@"87bfeb"].CGColor;
    
    _imageView.image = _backgroundImage;
    
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    if ([self.text isEqualToString:self.placeholder]) {
        self.text = @"";
    }
    if (_highlightImage) {
        _imageView.image = _highlightImage;
    }
    self.layer.borderColor = [UIColor colorWithHexString:@"87bfeb"].CGColor;
    self.textColor = DeepGrey;
    
    return [super becomeFirstResponder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    self.text = _placeholder;
    self.textColor = LightGrey;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (![text isEqualToString:self.placeholder]) {
        self.textColor = DeepGrey;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    
    _backgroundImage = [_backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(7, 10, 7, 10) resizingMode:UIImageResizingModeTile];
    _imageView.image = _backgroundImage;
    
    
}

- (void)setHighlightImage:(UIImage *)highlightImage {
    _highlightImage = highlightImage;
    
    _highlightImage = [_highlightImage resizableImageWithCapInsets:UIEdgeInsetsMake(7, 10, 7, 10) resizingMode:UIImageResizingModeTile];
}

@end
