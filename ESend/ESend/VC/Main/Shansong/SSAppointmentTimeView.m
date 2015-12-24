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

#define SSAppointToday @"今天"
#define SSAppointTomorrow @"明天"

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
        
        _dayTimes = [[NSMutableArray alloc] initWithCapacity:0];
        _hourTimes = [[NSMutableArray alloc] initWithCapacity:0];
        
        _minutes = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i <= 55; i = i + 5) {
            [_minutes addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        self.datePicker.delegate = self;
        self.datePicker.dataSource = self;
        
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
    
    [self configTimes];
    [self.datePicker reloadAllComponents];
    //
    self.frame = CGRectMake(0, view.frame.size.height, ScreenWidth, self.frame.size.height);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, ScreenWidth, self.frame.size.height);
        _mask.alpha = 0.8f;
    }completion:^(BOOL finished) {

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

    NSString * selectedDay = [[NSDate new] km_todayYYYY_MM_DD];
    
    NSString * title = [_dayTimes objectAtIndex:selectedDayRow];
    if ([title isEqualToString:SSAppointToday]) { // 今天,明天都有,显示今天
        selectedDay = [[NSDate new] km_todayYYYY_MM_DD];
    }else if ([title isEqualToString:SSAppointTomorrow]){
        selectedDay = [[NSDate new] km_tomorrowYYYY_MM_DD];
    }
    
    
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

- (void)configTimes{
    [_dayTimes removeAllObjects];
    [_hourTimes removeAllObjects];
    NSInteger currentHourInt = [[NSDate new] km_hourInt];
    if (currentHourInt +2 < 24) {   // 有今天
        [_dayTimes addObject:SSAppointToday];
        [_dayTimes addObject:SSAppointTomorrow];
        currentHourInt += 2;
        for (NSInteger i = currentHourInt; i< 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
    }else{ // 只有明天
        [_dayTimes addObject:SSAppointTomorrow];
        currentHourInt = currentHourInt + 2 - 24;
        for (NSInteger i = currentHourInt; i< 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
    }
}

- (void)hourTimesWithRow:(NSInteger)row{
    [_hourTimes removeAllObjects];
    NSString * title = [_dayTimes objectAtIndex:row];
    if ([title isEqualToString:SSAppointToday]) { // 今天,明天都有,显示今天
        NSInteger currentHourInt = [[NSDate new] km_hourInt];
        currentHourInt += 2;
        for (NSInteger i = currentHourInt; i< 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
    }else if ([title isEqualToString:SSAppointTomorrow] && _dayTimes.count == 1){ // 只有明天
        NSInteger currentHourInt = [[NSDate new] km_hourInt];
        currentHourInt = (currentHourInt + 3 - 24);
        for (NSInteger i = currentHourInt; i< 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
    }else if ([title isEqualToString:SSAppointTomorrow] && _dayTimes.count == 2){   // 有明天，有今天，显示明天
        for (NSInteger i = 0; i< 24; i++) {
            [_hourTimes addObject:[NSString stringWithFormat:@"%02ld",i]];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [self hourTimesWithRow:row];
        [pickerView reloadComponent:1];
    }

}

@end
