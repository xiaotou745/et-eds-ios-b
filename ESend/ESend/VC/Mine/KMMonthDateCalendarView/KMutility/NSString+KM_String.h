//
//  NSString+KM_String.h
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/8.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KM_String)

/// string to date, format yyyy-MM-dd hh:mm:ss
- (NSDate*)km_toDate;

@end
