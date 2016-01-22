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


- (NSString *)km_simpleToString{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)km_toString{
    return [self dateToStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
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

- (BOOL)is201401Month{
    BOOL result = NO;
    NSDateComponents *compsToday = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    compsToday = [calendar components:unitFlags fromDate:self];
    //NSInteger weekToday = [compsToday weekday];
    NSInteger yearToday = [compsToday year];
    NSInteger monthToday = [compsToday month];
    if (2014 == yearToday && 1 == monthToday) {
        result = YES;
    }
    return result;
}

- (BOOL)is20140101Day{
    BOOL result = NO;
    NSDateComponents *compsToday = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    compsToday = [calendar components:unitFlags fromDate:self];
    //NSInteger weekToday = [compsToday weekday];
    NSInteger yearToday = [compsToday year];
    NSInteger monthToday = [compsToday month];
    NSInteger dayToday = [compsToday day];
    
    if (2014 == yearToday && 1 == monthToday && 1 == dayToday) {
        result = YES;
    }
    return result;
}

- (NSInteger)km_hourInt{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSHourCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    return [comps hour];
}

- (NSInteger)km_MinuteInt{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSMinuteCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    return [comps minute];
}


- (NSString *)km_todayYYYY_MM_DD{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compsDate = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit;
    compsDate = [calendar components:unitFlags fromDate:self];
    NSInteger yearDate=[compsDate year];
    NSInteger monthDate = [compsDate month];
    NSInteger dayDate = [compsDate day];
    return [NSString stringWithFormat:@"%ld-%ld-%ld",yearDate,monthDate,dayDate];
}


- (NSString *)km_tomorrowYYYY_MM_DD{
    NSDate * tomorrow = [self addDays:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *compsDate = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit;
    compsDate = [calendar components:unitFlags fromDate:tomorrow];
    NSInteger yearDate=[compsDate year];
    NSInteger monthDate = [compsDate month];
    NSInteger dayDate = [compsDate day];
    return [NSString stringWithFormat:@"%ld-%ld-%ld",yearDate,monthDate,dayDate];
}

@end
