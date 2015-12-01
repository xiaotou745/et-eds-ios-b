//
//  NSString+allSpace.m
//  ESend
//
//  Created by 台源洪 on 15/12/1.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "NSString+allSpace.h"

@implementation NSString (allSpace)
- (BOOL)allSpace{
    BOOL result = NO;
    if (self.length <= 0) {
        result = YES;
    }else{
        NSString * noSpaceStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (noSpaceStr.length <= 0) {
            result = YES;
        }
    }
    return result;
}
@end
