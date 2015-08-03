//
//  BankTableViewCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/9.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BankTableViewCell.h"

@implementation BankTableViewCell

- (void)bulidView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 95, 55)];
    self.titleLabel.text = @"开户行";
    self.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.titleLabel.textColor = DeepGrey;
    [self.contentView addSubview:self.titleLabel];
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, MainHeight - CGRectGetMaxY(self.titleLabel.frame), 55)];
    [self.contentView addSubview:self.rightView];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(0, 54.5, MainWidth, 0.5);
    [self addSubview:line];
}

@end
