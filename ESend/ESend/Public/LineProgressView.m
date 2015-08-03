//
//  LineProgressView.m
//  JiaLiMei
//
//  Created by 永来 付 on 15/4/9.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import "LineProgressView.h"

@implementation LineProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        frame.size.height = 8;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor colorWithHexString:@"f5f5f5" alpha:0.5] set];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    bgPath.lineWidth = 8;
    bgPath.lineCapStyle = kCGLineCapRound;
    
    [bgPath moveToPoint:CGPointMake(bgPath.lineWidth/2, rect.size.height/2)];
    [bgPath addLineToPoint:CGPointMake(rect.size.width - bgPath.lineWidth/2, rect.size.height/2)];
    [bgPath stroke];
    
    [[UIColor whiteColor] set];
    UIBezierPath *overPath = [UIBezierPath bezierPath];
    overPath.lineWidth = bgPath.lineWidth;
    overPath.lineCapStyle = kCGLineCapRound;
    [overPath moveToPoint:CGPointMake(overPath.lineWidth/2, rect.size.height/2)];
    CGFloat overLineWith = rect.size.width*_progress - overPath.lineWidth*2;
    overLineWith = overLineWith <  overPath.lineWidth/2 ? overPath.lineWidth/2 : overLineWith;
    [overPath addLineToPoint:CGPointMake(overLineWith, rect.size.height/2)];
    [overPath stroke];
    
}


@end
