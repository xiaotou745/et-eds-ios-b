//
//  ConsigneeInfoCell.m
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ConsigneeInfoCell.h"

@implementation ConsigneeInfoCell

- (void)awakeFromNib {
    self.consigneeAddress.font = [UIFont systemFontOfSize:14];
    self.consigneePhone.font = [UIFont boldSystemFontOfSize:16];
    self.consigneeAddress.textColor =
    self.consigneePhone.textColor = [UIColor colorWithHexString:@"333333"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setConsigneeInfo:(ConsigneeModel *)consigneeInfo{
    _consigneeInfo = consigneeInfo;
    self.consigneePhone.text = _consigneeInfo.consigneePhone;
    self.consigneeAddress.text = _consigneeInfo.consigneeAddress;
}

@end
