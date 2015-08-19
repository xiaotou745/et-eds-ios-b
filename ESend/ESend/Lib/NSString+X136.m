//
//  NSString+X136.m
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "NSString+X136.h"

@implementation NSString (X136)
/// 剔除136位
- (NSString *)x136{
    if (self.length < 6) {
        return self;
    }
    NSString * x6 = [self stringByReplacingCharactersInRange:NSMakeRange(5, 1) withString:@""];
    NSString * x3 = [x6 stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@""];
    NSString * x1 = [x3 stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    return x1;
}
@end
