//
//  SSAppointmentTimeView.m
//  ESend
//
//  Created by 台源洪 on 15/12/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSAppointmentTimeView.h"
#import "NSDate+KMdate.h"
#import "NSString+KM_String.h"

@interface SSAppointmentTimeView ()
{
    UIView * _mask;
}
@end

@implementation SSAppointmentTimeView

- (id)initWithDelegate:(id<SSAppointmentTimeViewDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSAppointmentTimeView class]) owner:self options:nil] objectAtIndex:0];
    if (self) {
        
        self.actionBg.layer.masksToBounds = YES;
        self.actionBg.layer.borderColor = [SeparatorLineColor CGColor];
        self.actionBg.layer.borderWidth = 0.5f;
        
        self.delegate = delegate;
        [self.datePicker setCalendar:[NSCalendar currentCalendar]];
        [self.datePicker setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT:8]];
        
        NSDate * date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate: date];
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        [self.datePicker setMinimumDate:localeDate];
        
        NSDate * tomorrow = [[NSDate new] addDays:1];
        NSString * aString = [[[tomorrow km_toString] componentsSeparatedByString:@" "] firstObject];
        NSString * tomorrowString = [aString stringByAppendingString:@" 23:59:59"];
        tomorrow = [tomorrowString km_toDate];
        [self.datePicker setMaximumDate:tomorrow];
        
    }
    
    return self;
}


- (void)showInView:(UIView *)view{
    
    _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _mask.backgroundColor = SeparatorLineColor;
    _mask.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_mask];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)];
    [_mask addGestureRecognizer:tap];
    
    //

    //
    self.frame = CGRectMake(0, view.frame.size.height, ScreenWidth, self.frame.size.height);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, ScreenWidth, self.frame.size.height);
        _mask.alpha = 0.8f;
    }completion:^(BOOL finished) {

//        if ([self.delegate respondsToSelector:@selector(MNDatePickerDidCompleteShowed:)]) {
//            [self.delegate MNDatePickerDidCompleteShowed:self];
//        }
    }];
}

- (void)cancelPicker{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, ScreenWidth, self.frame.size.height);
                         _mask.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [_mask removeFromSuperview];
                         _mask = nil;
                         [self removeFromSuperview];
                         
                     }];
//    if ([self.delegate respondsToSelector:@selector(MNDatePickerDidCancel:)]) {
//        [self.delegate MNDatePickerDidCancel:self];
//    }
}



- (IBAction)cancelClicked:(UIButton *)sender {
    [self cancelPicker];
}
- (IBAction)confirmClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SSAppointmentTimeView:selectedDate:)]) {
        [self.delegate SSAppointmentTimeView:self selectedDate:self.datePicker.date];
    }
    [self cancelPicker];
}

@end
