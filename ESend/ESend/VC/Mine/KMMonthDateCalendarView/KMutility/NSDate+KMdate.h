//
//  NSDate+KMdate.h
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/6.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KMdate)

- (NSString *)dateToStringWithFormat:(NSString *)printFormat;

/// to string, format yyyy-MM-dd hh:mm:ss
- (NSString *)km_toString;

- (NSDate *)addDays:(NSInteger)day;

- (NSDate *)addMonths:(NSInteger)month;

/// 判断是否是今天
- (BOOL)isToday;

/// 判断是否是当月
- (BOOL)isTheCurrentMonth;

@end
