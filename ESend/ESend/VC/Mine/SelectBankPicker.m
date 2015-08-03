//
//  SelectBankPicker.m
//  ESend
//
//  Created by 永来 付 on 15/6/10.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "SelectBankPicker.h"

@interface SelectBankPicker ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_picker;
    NSArray *_bankList;
    
    UIView *_maskerView;
}

@end

@implementation SelectBankPicker

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = 162 + 45;
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidView];
    }
    return self;
}

- (void)loadData:(NSArray *)data {
    _bankList = [NSArray arrayWithArray:data];
    [_picker reloadAllComponents];
}

- (void)setSelectBank:(NSString *)bankName {
    for (NSInteger i = 0; i < _bankList.count; i++) {
        NSDictionary *bankDic = _bankList[i];
        if ([[bankDic getStringWithKey:@"Name"] isEqualToString:bankName]) {
            [_picker selectRow:i inComponent:0 animated:YES];
            break;
        }

    }
    
}

- (void)bulidView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 45)];
    topView.backgroundColor = RGBCOLOR(240, 240, 240);
    [self addSubview:topView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, 45);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:DeepGrey forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelBtn];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(MainWidth - 80, 0, 80, 45);
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:DeepGrey forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:selectBtn];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, MainWidth, 90)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    [self addSubview:_picker];
    
    _maskerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, ScreenHeight)];
    _maskerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _bankList.count;
}

- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[_bankList objectAtIndex:row] getStringWithKey:@"Name"]];
    [str addAttributes:@{NSForegroundColorAttributeName : DeepGrey,
                         NSFontAttributeName            : [UIFont systemFontOfSize:SmallFontSize]}
                 range:NSMakeRange(0, str.length)];
    return str;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)showInView:(UIView*)view {
    
    [Tools hiddenKeyboard];
    
    _maskerView.alpha = 0;
    [self changeFrameOriginY:ScreenHeight];

    [view addSubview:_maskerView];
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskerView.alpha = 1;
        [self changeFrameOriginY:ScreenHeight - 162 - 45];
    }];

    
}

- (void)hidden {
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskerView.alpha = 0;
        [self changeFrameOriginY:ScreenHeight];
    } completion:^(BOOL finished) {
        [_maskerView removeFromSuperview];
        [self removeFromSuperview];
    }];


}

- (void)select {
    if ([_delegate respondsToSelector:@selector(selectBankPickerSelect:)]) {
        [_delegate selectBankPickerSelect:self];
    }
    [self hidden];
}

@end
