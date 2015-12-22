//
//  NSString+moneyFormat.m
//  ESend
//
//  Created by 台源洪 on 15/12/22.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "NSString+moneyFormat.h"

@implementation NSString (moneyFormat)
- (BOOL)rightMoneyFormat{
    BOOL result = NO;
    if (self.length > 0 && [self includesAString:@"."]) {
        NSArray * components = [self componentsSeparatedByString:@"."];
        
    }
    return result;
}

- (BOOL)includesAString:(NSString *)astring{
    if ([self respondsToSelector:@selector(containsString:)]) {
        return [self containsString:astring];
    }else{
        NSRange arange = [self rangeOfString:astring options:NSCaseInsensitiveSearch];
        //NSLog(@"%@",NSStringFromRange(arange));
        if (arange.length == 0) {
            return NO;
        }else{
            return YES;
        }
    }
}


@end
