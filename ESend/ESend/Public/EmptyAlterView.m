//
//  EmptyAlterView.m
//  ESend
//
//  Created by 永来 付 on 15/7/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EmptyAlterView.h"

@implementation EmptyAlterView

- (id)initWithMessage:(NSString*)message {
    CGRect frame = CGRectMake(0, ScreenHeight * 0.3, MainWidth, 100);
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidViewWithMessage:message];
    }
    return self;
}

- (void)bulidViewWithMessage:(NSString*)message {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainWidth - 61)/2, 0, 61, 61)];
    imageView.image = [UIImage imageNamed:@"gray_icon"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, MainWidth, 20)];
    label.text = message;
    label.textColor = LightGrey;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:BigFontSize];
    [self addSubview:label];
}

@end
