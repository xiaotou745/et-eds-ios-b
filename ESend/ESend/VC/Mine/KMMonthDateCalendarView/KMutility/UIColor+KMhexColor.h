//
//  UIColor+KMhexColor.h
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/6.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KMhexColor)

+ (UIColor *)km_colorWithHexString:(NSString *)hexString;
+ (UIColor *)km_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
