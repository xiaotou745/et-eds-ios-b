//
//  SelectBankPicker.h
//  ESend
//
//  Created by 永来 付 on 15/6/10.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectBankPicker;
@protocol SelectBankPickerDelegate <NSObject>

- (void)selectBankPickerSelect:(SelectBankPicker*)selecterPicker;

@end

@interface SelectBankPicker : UIView

@property (nonatomic, readonly) UIPickerView *picker;
@property (nonatomic, weak) id<SelectBankPickerDelegate> delegate;

- (void)loadData:(NSArray*)data;
- (void)showInView:(UIView*)view;

- (void)setSelectBank:(NSString*)bankName;
@end
