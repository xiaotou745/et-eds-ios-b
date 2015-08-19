//
//  NSString+evaluatePhoneNumber.h
//  etaoshi3.0
//
//  Created by Maxwell on 14/12/23.
//  Copyright (c) 2014年 etaostars. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (evaluatePhoneNumber)
/// 正确地手机号格式
- (BOOL)isRightPhoneNumberFormat;

/// 正确地邮箱格式
- (BOOL)isValidateEmail;

// 6到16位数字字母
- (BOOL)isRightPasswordFormat;

// 0到6位数字字母
- (BOOL)isRightVerifyFormat;


@end
