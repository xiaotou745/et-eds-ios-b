//
//  DateFromNowOn.m
//  KitchenPro
//
//  Created by qianfeng on 15-3-13.
//  Copyright (c) 2015年 赵英奎. All rights reserved.
//

#import "DateFromNowOn.h"

@implementation DateFromNowOn
+(NSArray *)getDate
{
    //NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    //int week = [comps weekday];
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
  
    NSString *strYear=[NSString stringWithFormat:@"%i",year];
    
    NSString *strMonth=[NSString stringWithFormat:@"%i",month];
    NSString *strDay=[NSString stringWithFormat:@"%i",day];
    NSArray *arr=@[strYear,strMonth,strDay ];
    return arr;
}
@end
