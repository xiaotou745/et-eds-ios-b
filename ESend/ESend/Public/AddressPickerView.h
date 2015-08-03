//
//  AddressPickerView.h
//  ESend
//
//  Created by 永来 付 on 15/7/22.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OriginModel.h"
#import "DataBase.h"

@class AddressPickerView;
@protocol AddressPickerViewDelegate <NSObject>

- (void)addressPickerViewSelected:(AddressPickerView*)addressPicker;

@end

@interface AddressPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    DataBase *_database;
    
    NSMutableArray *_provinceList;
    NSMutableArray *_cityList;
    
    UIView *_maskView;
    
    AddressType _addressType;
}
@property (nonatomic, readonly) UIPickerView *picker;

@property (nonatomic, assign) id<AddressPickerViewDelegate> delegate;
@property (nonatomic, strong) OriginModel *provinceOrigin;
@property (nonatomic, strong) OriginModel *cityOrigin;

- (id)initWithFrame:(CGRect)frame withAddressType:(AddressType)addressType;

- (void)setSelectProvince:(NSString*)province;
- (void)setSelectCity:(NSString*)city;

- (void)showInView:(UIView*)view;
- (void)hidden;

@end
