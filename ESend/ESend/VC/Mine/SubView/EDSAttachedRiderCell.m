//
//  EDSAttachedRiderCell.m
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSAttachedRiderCell.h"

@implementation EDSAttachedRiderCell

- (void)awakeFromNib {
    self.AR_SeparatorLine.backgroundColor = SeparatorLineColor;
    
    self.AR_RiderPortrait.layer.masksToBounds = YES;
    self.AR_RiderPortrait.layer.cornerRadius = 25.0f;
    self.AR_RiderPortrait.layer.borderWidth = 2.0f;
    self.AR_RiderPortrait.layer.borderColor = [SeparatorLineColor CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.AR_SeparatorLine.backgroundColor = SeparatorLineColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.AR_SeparatorLine.backgroundColor = SeparatorLineColor;

}

- (void)setRiderInfo:(EDSRiderInfoModel *)riderInfo{
    _riderInfo = riderInfo;
    self.AR_RiderName.text = _riderInfo.riderName;
    self.AR_RiderPhone.text = _riderInfo.riderPhone;
    self.AR_RiderOrderCount.text = [NSString stringWithFormat:@"完成订单量 %@",_riderInfo.riderOrderCount];
}

@end
