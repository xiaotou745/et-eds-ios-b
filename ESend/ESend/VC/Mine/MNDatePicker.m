//
//  MNDatePicker.m
//  with
//
//  Created by Maxwell on 15/5/3.
//  Copyright (c) 2015年 Maxwell. All rights reserved.
//

#import "MNDatePicker.h"
#import "AppDelegate.h"
#import "Tools.h"

#define MNDatePickerYearKey @"MNDatePickerYearKey"
#define MNDatePickerMonthKey @"MNDatePickerMonthKey"

@interface MNDatePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation MNDatePicker{
    UIView * _mask;
    NSMutableArray * _years;
    NSMutableArray * _monthsInYear;
    
    NSString * _currentYearString;
    NSString * _currentMonthString;
    
//    // 记录年月下标
//    NSInteger _currentYearIdx;
//    NSInteger _currentMonthIdx;
}

- (id)initWithDelegate:(id <MNDatePicerDelegate>)delegate year:(NSString *)year month:(NSString *)month{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNDatePicker" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        
        self.actionBg.layer.masksToBounds = YES;
        self.actionBg.layer.borderColor = [SeparatorLineColor CGColor];
        self.actionBg.layer.borderWidth = 0.5f;
        
        // data source
        _years = [[NSMutableArray alloc] initWithCapacity:0];
        _monthsInYear = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSDictionary * YandM = [self currentYearAndMonth];
        _currentYearString = [YandM objectForKey:MNDatePickerYearKey];
        _currentMonthString = [YandM objectForKey:MNDatePickerMonthKey];
        
        NSArray * fullMonthInYear = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
        
        for (int i = 2014; i <= _currentYearString.integerValue; i++) {
            [_years addObject:[NSString stringWithFormat:@"%d",i]];
//            if (i == _currentYearString.integerValue) {
//                // 今年
//                NSMutableArray * monthOfThisYear = [NSMutableArray array];
//                for (int j = 1; j <= _currentMonthString.integerValue; j ++) {
//                    [monthOfThisYear addObject:[NSString stringWithFormat:@"%02d",j]];
//                }
//                [_monthsInYear addObject:monthOfThisYear];
//            }else{
//                // 去年及以前
//                [_monthsInYear addObject:fullMonthInYear];
//            }

        }
        [_monthsInYear addObjectsFromArray:fullMonthInYear];

        // _dataSource = [[NSArray alloc] initWithObjects:_years,_monthsInYear, nil];
        
        self.datePicker.dataSource = self;
        self.datePicker.delegate = self;
        
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
    
    self.frame = CGRectMake(0, view.frame.size.height, ScreenWidth, self.frame.size.height);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, ScreenWidth, self.frame.size.height);
        _mask.alpha = 0.8f;
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(MNDatePickerDidCompleteShowed:)]) {
            [self.delegate MNDatePickerDidCompleteShowed:self];
        }
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
    if ([self.delegate respondsToSelector:@selector(MNDatePickerDidCancel:)]) {
        [self.delegate MNDatePickerDidCancel:self];
    }
}



- (IBAction)cancelClicked:(UIButton *)sender {
    [self cancelPicker];
}
- (IBAction)confirmClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(MNDatePickerDidSelected:YearMonthString:year:month:)]) {
        NSInteger yearIdx = [self.datePicker selectedRowInComponent:0];
        NSInteger monthIdx = [self.datePicker selectedRowInComponent:1];
        NSString * yearString = [_years objectAtIndex:yearIdx];
        NSString * monthString = [_monthsInYear objectAtIndex:monthIdx];
        NSString * ymString = [NSString stringWithFormat:@"%@-%@",yearString,monthString];
        [self.delegate MNDatePickerDidSelected:self YearMonthString:ymString year:yearString month:monthString];
    }
    [self cancelPicker];
}


- (NSDictionary *)currentYearAndMonth{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString * year = [dateFormatter stringFromDate:localeDate];
    [dateFormatter setDateFormat:@"MM"];
    NSString * month = [dateFormatter stringFromDate:localeDate];
    return @{
             MNDatePickerYearKey:year,
             MNDatePickerMonthKey:month,
             };
}


#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component) {
        return _years.count;
    }else if (1 == component){
//        NSInteger selectedFirstComponent = [pickerView selectedRowInComponent:0];
//        return [[_monthsInYear objectAtIndex:selectedFirstComponent] count];
        return _monthsInYear.count;
    }else{
        return 0;
    }
    //return [[_dataSource objectAtIndex:component] count];
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return ScreenWidth / 2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return [NSString stringWithFormat:@"%@年",[_years objectAtIndex:row]];
    }else if (1 == component) {
//        NSInteger selectedFirstComponent = [pickerView selectedRowInComponent:0];
//        return [[_monthsInYear objectAtIndex:selectedFirstComponent] objectAtIndex:row];
        return [NSString stringWithFormat:@"%@月",[_monthsInYear objectAtIndex:row]];
    }else{
        return nil;
    }
    //return [[_dataSource objectAtIndex:component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (0 == component) {
//        [pickerView reloadComponent:1];
//    }
}

@end
