//
//  KMMonthDateCalendarView.h
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/6.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, KMMonthDateCalendarViewStyle) {
    KMMonthDateCalendarViewStyleDate,     // Date view
    KMMonthDateCalendarViewStyleMonth     // Month view
};

#define KMMonthDateCalenderViewHeight 100.0f
#define KMDateTimeMargin 50.0f
#define KMDateTimeTopPadding 23.0f
#define KMDateTimeHeight 26.0f

#define KMIndicatorMargin 10.0f
#define KMIndicatorWidthHeight 15.5f

#define KMOrderOverviewHeight 21.0f
#define KMOrderOverviewTextDefault @"出账          入账       "

@class KMMonthDateCalendarView;

@protocol KMMonthDateCalendarViewDelegate <NSObject>

- (void)calendarViewDidStartChangeDate:(KMMonthDateCalendarView *)calendarView;
- (void)calendarView:(KMMonthDateCalendarView *)calendarView didStopChangeDate:(NSDate *)date;

@end


@interface KMMonthDateCalendarView : UIView

@property (nonatomic, weak) id<KMMonthDateCalendarViewDelegate>delegate;

@property (nonatomic, assign) KMMonthDateCalendarViewStyle style;

@end
