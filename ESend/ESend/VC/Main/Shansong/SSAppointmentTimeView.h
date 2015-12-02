//
//  SSAppointmentTimeView.h
//  ESend
//
//  Created by 台源洪 on 15/12/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSAppointmentTimeView;
@protocol SSAppointmentTimeViewDelegate <NSObject>

@optional
- (void)SSAppointmentTimeView:(SSAppointmentTimeView*)view selectedDate:(NSDate *)date;

@end

@interface SSAppointmentTimeView : UIView

@property (weak,nonatomic) id<SSAppointmentTimeViewDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *actionBg;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;


- (id)initWithDelegate:(id <SSAppointmentTimeViewDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
