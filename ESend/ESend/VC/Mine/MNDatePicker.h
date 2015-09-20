//
//  MNDatePicker.h
//  with
//
//  Created by Maxwell on 15/5/3.
//  Copyright (c) 2015年 Maxwell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNDatePicker;

@protocol MNDatePicerDelegate<NSObject>

- (void)MNDatePickerDidSelected:(MNDatePicker *)datePicker YearMonthString:(NSString *)yearMonth year:(NSString *)year month:(NSString *)month;
- (void)MNDatePickerDidCancel:(MNDatePicker *)datePicker;
- (void)MNDatePickerDidCompleteShowed:(MNDatePicker *)datePicker;

@end



@interface MNDatePicker : UIView

@property (weak,nonatomic) id<MNDatePicerDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *actionBg;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;


- (id)initWithDelegate:(id <MNDatePicerDelegate>)delegate year:(NSString *)year month:(NSString *)month;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
