//
//  GradientView.m
//  JiaLiMei
//
//  Created by 永来 付 on 15/4/3.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame orientation:(NSString*)orientation {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _orientation = orientation;
        [self bulidView];
    }
    return self;
}

- (void)bulidView {
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor,
                     (id)[UIColor clearColor].CGColor];
    layer.locations = @[@0, @0.9];
    
    if ([_orientation isEqualToString:@"down"]) {
        layer.startPoint = CGPointMake(0.5, 1);
        layer.endPoint = CGPointMake(0.5, 0);
    }
    
    [self.layer addSublayer:layer];
}

@end
