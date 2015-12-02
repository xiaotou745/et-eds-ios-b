//
//  NSString+PhoneFormat.m
//  ESend
//
//  Created by 台源洪 on 15/12/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "NSString+PhoneFormat.h"

@implementation NSString (PhoneFormat)
- (NSString *)phoneFormat{
    NSString * result = self;
    if ([result hasPrefix:@"+86"]) {
        result = [[self componentsSeparatedByString:@" "] lastObject];
    }
    return [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
@end
