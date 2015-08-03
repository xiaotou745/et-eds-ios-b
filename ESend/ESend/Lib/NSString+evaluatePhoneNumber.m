//
//  NSString+evaluatePhoneNumber.m
//  etaoshi3.0
//
//  Created by Maxwell on 14/12/23.
//  Copyright (c) 2014年 etaostars. All rights reserved.
//

#import "NSString+evaluatePhoneNumber.h"

@implementation NSString (evaluatePhoneNumber)

// 1开头，11位
- (BOOL)isRightPhoneNumberFormat{
    BOOL result = NO;
    if ([self hasPrefix:@"1"] && self.length == 11) {
        result = YES;
    }
    return result;
}



-(BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
@end
