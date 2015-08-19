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


// 6到16位数字字母
- (BOOL)isRightPasswordFormat
{
    NSString *passWordRegex        = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}



// 0到6位数字字母
- (BOOL)isRightVerifyFormat
{
    NSString *passWordRegex        = @"^[a-zA-Z0-9]{0,6}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}


/// 字符串包含字符串
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
