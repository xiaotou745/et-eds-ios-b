//
//  NSString+SSDateFormat.m
//  ESend
//
//  Created by 台源洪 on 15/12/18.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "NSString+SSDateFormat.h"

@implementation NSString (SSDateFormat)
- (NSString *)MMDDHHmmString{
    if (self.length < 12) {
        return self;
    }
    NSArray * components = [self componentsSeparatedByString:@" "];
    NSString * mmdd = [[components firstObject] substringFromIndex:5];
    NSString * hhmm = [[components objectAtIndex:1] substringToIndex:5];
    return [NSString stringWithFormat:@"%@ %@",mmdd,hhmm];
}
@end
