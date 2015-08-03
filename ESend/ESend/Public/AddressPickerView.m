//
//  AddressPickerView.m
//  ESend
//
//  Created by 永来 付 on 15/7/22.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "AddressPickerView.h"
#import "DataBase.h"

@implementation AddressPickerView

- (id)initWithFrame:(CGRect)frame withAddressType:(AddressType)addressType {
    
    frame = CGRectMake(0, ScreenHeight, MainWidth, 162 + 44);
    _addressType = addressType;
    self = [super initWithFrame:frame];
    if (self) {
        [self bulidView];
    }
    return self;
}

- (void)bulidView {
    
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    _maskView.alpha = 0;
    _maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    [_maskView addGestureRecognizer:tap];
    
    _database = [DataBase shareDataBase];
    
    _provinceList = [NSMutableArray arrayWithArray:[_database getProvinceWithAddressType:_addressType]];
    _provinceOrigin = _provinceList[0];
    
    _cityList = [_database getCityListWithProvince:_provinceOrigin.idCode withAddressType:_addressType];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, MainWidth, 162 )];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.backgroundColor = [UIColor whiteColor];
    [self addSubview:_picker];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 44)];
    bar.backgroundColor = [UIColor whiteColor];
    [self addSubview:bar];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, 0, 80, 44);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:DeepGrey forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:cancel];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitleColor:DeepGrey forState:UIControlStateNormal];
    okBtn.frame = CGRectMake(MainWidth - 90, 0, 80, 44);
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:okBtn];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceList.count;
    }
    
    if (component == 1) {
        return _cityList.count;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    OriginModel *origin;
    
    if (component == 0) {
        origin = _provinceList[row];
        return origin.name;
    }
    
    if (component == 1) {
        origin = _cityList[row];
        return origin.name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _provinceOrigin = _provinceList[row];
        _cityList = [_database getCityListWithProvince:_provinceOrigin.idCode withAddressType:_addressType];
        [pickerView reloadComponent:1];
    }
    
    if (component == 1) {
        _cityOrigin = _cityList[row];
    }
}

- (void)confirm {
    [self hidden];
    
    if ([_delegate respondsToSelector:@selector(addressPickerViewSelected:)]) {
        [_delegate addressPickerViewSelected:self];
    }
}

- (void)showInView:(UIView *)view {
    
    [view addSubview:_maskView];
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 1;
        [self changeFrameOriginY:ScreenHeight - 162 - 44];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self changeFrameOriginY:ScreenHeight];
        _maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setSelectProvince:(NSString*)province {
    for (OriginModel *origin in _provinceList) {
        if ([origin.name isEqualToString:province]) {
            NSInteger index = [_provinceList indexOfObject:origin];
            [_picker selectRow:index inComponent:0 animated:NO];
            [_picker reloadComponent:1];
            break;
        }
    }
}

- (void)setSelectCity:(NSString*)city {
    
    OriginModel *province = _provinceList[[_picker selectedRowInComponent:0]];
    _cityList = [_database getCityListWithProvince:province.idCode withAddressType:_addressType];
    [_picker reloadComponent:1];
    for (OriginModel *origin in _cityList) {
        if ([origin.name isEqualToString:city]) {
            NSInteger index = [_cityList indexOfObject:origin];
            [_picker selectRow:index inComponent:1 animated:YES];
            break;
        }
    }
}

- (OriginModel*)provinceOrigin {
    return _provinceList[[_picker selectedRowInComponent:0]];
}

- (OriginModel*)cityOrigin {
    return _cityList[[_picker selectedRowInComponent:1]];
}

@end
