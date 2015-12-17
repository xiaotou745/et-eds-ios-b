//
//  SSOrderUnpayCell.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSOrderUnpayCell.h"

@interface SSOrderUnpayCell ()
@property (weak, nonatomic) IBOutlet UIView *cellBg;
@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeparator;
@property (weak, nonatomic) IBOutlet UIButton *cellGoPay;
@property (weak, nonatomic) IBOutlet UILabel *cellFaAddr;
@property (weak, nonatomic) IBOutlet UILabel *cellCommission;
@property (weak, nonatomic) IBOutlet UILabel *cellShouAddr;
@property (weak, nonatomic) IBOutlet UILabel *cellKmKilo;

@end

@implementation SSOrderUnpayCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = BackgroundColor;
    self.cellCommission.textColor = RedDefault;
    [self.cellGoPay setTitleColor:RedDefault forState:UIControlStateNormal];
    self.cellGoPay.titleLabel.font = [UIFont systemFontOfSize:15];
    self.cellSeparator.backgroundColor = SeparatorLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cellPay:(UIButton *)sender {
    NSLog(@"%s",__func__);
}

- (void)setDatasource:(SSMyOrderModel *)datasource{
    _datasource = datasource;
    self.cellTime.text = _datasource.pubDate;
    self.cellCommission.text = [NSString stringWithFormat:@"¥%.2f",_datasource.orderCommission];
    self.cellFaAddr.text = _datasource.pickUpAddress;
    self.cellShouAddr.text = _datasource.receviceAddress;
    self.cellKmKilo.text = [NSString stringWithFormat:@"%.0f公斤/%.0fkm",_datasource.weight,_datasource.km];
}
@end
