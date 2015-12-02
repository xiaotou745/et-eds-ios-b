//
//  NSString+KM_String.m
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/8.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import "NSString+KM_String.h"

@implementation NSString (KM_String)

/// string to date, format yyyy-MM-dd hh:mm:ss
- (NSDate*)km_toDate
{
    //
//    NSDate * date = [NSDate date];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    //
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

@end
