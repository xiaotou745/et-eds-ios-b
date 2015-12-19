//
//  SSPayMethodCell.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSPayMethodCell.h"

@implementation SSPayMethodModel

- (NSString *)payMethodString{
    NSString * payString = nil;
    switch (self.payType) {
        case SSPayMethodTypeAlipay:
            payString = @"支付宝支付";
            break;
        case SSPayMethodTypeWechatpay:
            payString = @"微信支付";
            break;
        default:
            break;
    }
    return payString;
}

- (NSString *)payMethodImgString{
    NSString * payImgStr = @"";
    switch (self.payType) {
        case SSPayMethodTypeAlipay:
            payImgStr = @"ss_pay_ali";
            break;
        case SSPayMethodTypeWechatpay:
            payImgStr = @"ss_pay_wechat";
            break;
        default:
            break;
    }
    return payImgStr;
}

@end

@implementation SSPayMethodCell

- (void)awakeFromNib {
    self.separator.backgroundColor = SeparatorLineColor;
    self.payTypeTitle.textColor = DeepGrey;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDatasource:(SSPayMethodModel *)datasource{
    _datasource = datasource;
    self.selectionMarker.image = _datasource.selected?[UIImage imageNamed:@"ss_release_selected"]:[UIImage imageNamed:@"ss_release_normal"];
    self.payTypeTitle.text = [_datasource payMethodString];
    self.payTypeImg.image = [UIImage imageNamed:[_datasource payMethodImgString]];
}


@end
