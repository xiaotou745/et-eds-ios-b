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
        result = [self stringByReplacingOccurrencesOfString:@"+86" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 3)];
    }
    //NSString *strUrl = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""]
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"%lu",(unsigned long)result.length);
    return result;
}
@end
