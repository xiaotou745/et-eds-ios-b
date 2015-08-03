//
//  AddOrderTableViewCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/17.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "AddOrderTableViewCell.h"

@interface AddOrderTableViewCell ()
{
    UILabel *_numberLabel;
    UILabel *_unitLabel;
}

@end

@implementation AddOrderTableViewCell

- (void)bulidView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenDeletIcon) name:HiddenDeleteIconNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDeleteIcon) name:ShowDeleteIconNotification object:nil];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImageNor:@"delete_icon" imagePre:@"" imageSelected:@""];
    _deleteBtn.frame = CGRectMake(10, 0, 24, 55);
    [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    
    self.titleNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_deleteBtn.frame) + 15, 0, 60, 55)];
    self.titleNumberLabel.textColor = DeepGrey;
    self.titleNumberLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [self addSubview:_titleNumberLabel];
    
//    self.numberTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleNumberLabel.frame) + 5, 10, 60, 35)];
//    self.numberTF.textColor = DeepGrey;
//    self.numberTF.textAlignment = NSTextAlignmentCenter;
//    self.numberTF.font = [UIFont systemFontOfSize:NormalFontSize];
//    self.numberTF.layer.borderColor = LightGrey.CGColor;
//    self.numberTF.layer.borderWidth = 0.5;
//    [self addSubview:_numberTF];
    
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(170 + 10, 0, 40, 55)];
    _unitLabel.text = @"元";
    _unitLabel.textColor = DeepGrey;
    _unitLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [self addSubview:_unitLabel];
}

- (void)delete {
    if ([_delegate respondsToSelector:@selector(removeNewOrderCell:)]) {
        [_delegate removeNewOrderCell:self];
    }
}

- (void)hiddenDeletIcon {
    _deleteBtn.hidden = YES;
}

- (void)showDeleteIcon {
    _deleteBtn.hidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
