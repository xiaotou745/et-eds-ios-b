//
//  ThirdOrderTableViewCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/24.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ThirdOrderTableViewCell.h"

@interface ThirdOrderTableViewCell ()
{
    UILabel *_originLabel;
    UILabel *_sumLabel;
    UILabel *_numberLabel;
    UILabel *_addressLabel;
    
    UIView *_baseView;
}

@end

@implementation ThirdOrderTableViewCell

- (void)bulidView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _baseView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_baseView];
    
    _originLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 44)];
    _originLabel.textColor = DeepGrey;
    _originLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_baseView addSubview:_originLabel];
    
    _sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_originLabel.frame), 0, 120, 44)];
    _sumLabel.textColor = LightGrey;
    _sumLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_baseView addSubview:_sumLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 130, 0, 120, 44)];
    _numberLabel.textColor = LightGrey;
    _numberLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _numberLabel.textAlignment = NSTextAlignmentRight;
    [_baseView addSubview:_numberLabel];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(10, CGRectGetMaxY(_numberLabel.frame), MainWidth - 20, 0.5);
    [self addSubview:line];
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame) + 15, MainWidth - 20, 20)];
    _addressLabel.textColor = DeepGrey;
    _addressLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_baseView addSubview:_addressLabel];
    
    NSLog(@"%f",CGRectGetMaxY(_addressLabel.frame));
}

- (void)loadData:(id)data {
    _originLabel.text = @"来源：美团";
    _sumLabel.text = @"金额￥123.00";
    _numberLabel.text = @"商品4份";
    _addressLabel.text = @"北京市朝阳区 华腾北塘商务大厦2705室";
}

@end
