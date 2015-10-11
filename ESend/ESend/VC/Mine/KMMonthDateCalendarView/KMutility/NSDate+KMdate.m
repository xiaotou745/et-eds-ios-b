//
//  NSDate+KMdate.m
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/6.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import "NSDate+KMdate.h"

@implementation NSDate (KMdate)

- (NSString *)dateToStringWithFormat:(NSString *)printFormat{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    NSDate *localeDate = [self  dateByAddingTimeInterval: interval];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:printFormat];
    return [dateFormatter stringFromDate:localeDate];
}

- (NSString *)km_toString{
    return [self dateToStringWithFormat:@"yyyy-MM-dd hh:mm:ss"];
}

- (NSDate *)addDays:(NSInteger)day{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = day;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent toDate:self options:0];
}

- (NSDate *)addMonths:(NSInteger)month {
    NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
    monthComponent.month = month;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:monthComponent toDate:self options:0];
}

- (BOOL)isToday{
    return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}

- (NSDate*)midnightDate {
    return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
}

-(BOOL) isSameDateWith: (NSDate *)date{
    return  ([[self midnightDate] isEqualToDate: [date midnightDate]])?YES:NO;
}

- (BOOL)isTheCurrentMonth{
    BOOL result = NO;
    // [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compsDate = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    compsDate = [calendar components:unitFlags fromDate:self];
    //NSInteger weekDate = [compsDate weekday];
    NSInteger yearDate=[compsDate year];
    NSInteger monthDate = [compsDate month];
    //NSInteger dayDate = [compsDate day];
    
    NSDateComponents *compsToday = [[NSDateComponents alloc] init];
    compsToday = [calendar components:unitFlags fromDate:[NSDate new]];
    //NSInteger weekToday = [compsToday weekday];
    NSInteger yearToday = [compsToday year];
    NSInteger monthToday = [compsToday month];
    //NSInteger datToday = [compsToday day];
    
    if (yearDate == yearToday && monthDate == monthToday) {
        result = YES;
    }
    return result;
}




@end
