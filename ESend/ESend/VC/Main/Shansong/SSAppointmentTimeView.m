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

@interface SSAppointmentTimeView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView * _mask;
}
@property (nonatomic,strong) NSMutableArray * dayTimes;
@property (nonatomic,strong) NSMutableArray * hourTimes;
@property (nonatomic,strong) NSMutableArray * minutes;
@end

@implementation SSAppointmentTimeView

- (id)initWithDelegate:(id<SSAppointmentTimeViewDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSAppointmentTimeView class]) owner:self options:nil] objectAtIndex:0];
    if (self) {
        

        self.actionBg.layer.masksToBounds = YES;
        self.actionBg.layer.borderColor = [SeparatorLineColor CGColor];
        self.actionBg.layer.borderWidth = 0.5f;
        
        self.delegate = delegate;
        
        _dayTimes = [[NSMutableArray alloc] initWithObjects:@"今天",@"明天", nil];
        _hourTimes = [[NSMutableArray alloc] initWithCapacity:0];
//        NSMutableArray * tomorrowHours = [[NSMutableArray alloc] init];
//        for (int i =0; i < 24; i++) {
//            [tomorrowHours addObject:[NSString stringWithFormat:@"%02d",i]];
//        }
//        [_hourTimes addObject:tomorrowHours];
        
        _minutes = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i <= 55; i = i + 5) {
            [_minutes addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        self.datePicker.delegate = self;
        self.datePicker.dataSource = self;
//        NSDate * date = [NSDate date];
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSInteger interval = [zone secondsFromGMTForDate: date];
//        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//        [self.datePicker setMinimumDate:localeDate];
//        
//        NSDate * tomorrow = [[NSDate new] addDays:1];
//        NSString * aString = [[[tomorrow km_toString] componentsSeparatedByString:@" "] firstObject];
//        NSString * tomorrowString = [aString stringByAppendingString:@" 23:59:59"];
//        tomorrow = [tomorrowString km_toDate];
//        [self.datePicker setMaximumDate:tomorrow];
        
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
    
    [self hourTimesWithComponent:0];
    [self.datePicker reloadAllComponents];
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
    NSInteger selectedDayRow = [self.datePicker selectedRowInComponent:0];
    NSInteger selectedHourRow = [self.datePicker selectedRowInComponent:1];
    NSInteger selectedMinuteRow = [self.datePicker selectedRowInComponent:2];
    
    if (selectedDayRow == -1 || selectedHourRow == -1 || selectedMinuteRow == -1) {
        [Tools showHUD:@"您未选择时间"];
        return;
    }

    NSString * selectedDay = (selectedDayRow == 0)?[[NSDate new] km_todayYYYY_MM_DD]:[[NSDate new] km_tomorrowYYYY_MM_DD];
    NSString * selectedHour = [_hourTimes objectAtIndex:selectedHourRow];
    NSString * selectedMinute = [_minutes objectAtIndex:selectedMinuteRow];

    if ([self.delegate respondsToSelector:@selector(SSAppointmentTimeView:selectedDate:)]) {
        [self.delegate SSAppointmentTimeView:self selectedDate:[NSString stringWithFormat:@"%@ %@:%@:00",selectedDay,selectedHour,selectedMinute]];
    }
    [self cancelPicker];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component) {
        return _dayTimes.count;
    }else if (1 == component){
        return _hourTimes.count;
    }else if (2 == component){
        return _minutes.count;
    }else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (0 == component) {
        return [_dayTimes objectAtIndex:row];
    }else if (1 == component){
        return [_hourTimes objectAtIndex:row];
    }else if (2 == component){
        return [_minutes objectAtIndex:row];
    }else{
        return nil;
    }
}

- (void)hourTimesWithComponent:(NSInteger)component{
    [_hourTimes removeAllObjects];
    if (0 == component) {
        NSInteger currentHourInt = [[NSDate new] km_hourInt];
        if (currentHourInt + 2 < 24) {
            currentHourInt += 2;
        }
        for (NSInteger i = currentHourInt; i< 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
        
    }else if (1 == component){
        for (int i =0; i < 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [self hourTimesWithComponent:row];
        [pickerView reloadComponent:1];
    }

}

@end
