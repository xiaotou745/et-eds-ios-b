//
//  EDSFullfillOptionCell.m
//  ESend
//
//  Created by 台源洪 on 15/9/14.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSFullfillOptionCell.h"


@implementation EDSPaymentTypeModel



@end



@implementation EDSFullfillOptionCell

- (void)awakeFromNib {
    self.FFOC_CellSeparatorLine.backgroundColor = SeparatorLineColor;
    
    self.FFOC_PaymentMarker.highlightedImage = [UIImage imageNamed:@"radio_pre"];
    self.FFOC_PaymentMarker.image = [UIImage imageNamed:@"radio_nor"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.FFOC_CellSeparatorLine.backgroundColor = SeparatorLineColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.FFOC_CellSeparatorLine.backgroundColor = SeparatorLineColor;
}

- (void)setPaymentModel:(EDSPaymentTypeModel *)paymentModel{
    _paymentModel = paymentModel;
    self.FFOC_PaymentMarker.highlighted = _paymentModel.selected;
    self.FFOC_PaymentNameLbl.text = _paymentModel.paymentName;
    if (EDSPaymentTypeAlipay == _paymentModel.paymentType) {
        self.FFOC_PaymentTypeImg.image = [UIImage imageNamed:@"alipay_icon"];
    }else if (EDSPaymentTypeWechatPay == _paymentModel.paymentType){
        self.FFOC_PaymentTypeImg.image = [UIImage imageNamed:@"wechat_icon"];
    }
}

@end
