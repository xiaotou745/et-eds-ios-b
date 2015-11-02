//
//  EDSOrderStatusView.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSOrderStatusView.h"

@implementation EDSOrderStatusView

- (instancetype)initWithStatusCode:(NSInteger)statusCode{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    if (self) {
        [self layoutSubviewsWithStatus:statusCode];
    }
    return self;
}

- (void)layoutSubviewsWithStatus:(NSInteger)statusCode{
    // 取货中，配送中，已完成
}

- (BOOL)highlightedWithStatusCode:(NSInteger)statusCode IndexInt:(NSInteger)idxInt{
    /*
     OrderStatusAccepted = 2,                        //取货中
     OrderStatusReceive = 4,                         //已到店取餐
     OrderStatusComplete = 1,                        //订单已完成
     */
    if (statusCode == 2 && idxInt < 1) {
        return YES;
    }
    if (statusCode == 4 && idxInt < 2) {
        return YES;
    }
    
    if (statusCode == 1) {
        return YES;
    }
    
    return NO;
}

@end
