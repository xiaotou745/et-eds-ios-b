//
//  SSOrderUngrabCell.m
//  ESend
//
//  Created by 台源洪 on 15/12/17.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSOrderUngrabCell.h"

@interface SSOrderUngrabCell ()
@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeparator1;
@property (weak, nonatomic) IBOutlet UILabel *cellFaAddr;
@property (weak, nonatomic) IBOutlet UILabel *cellShouAddr;
@property (weak, nonatomic) IBOutlet UILabel *cellCommission;
@property (weak, nonatomic) IBOutlet UILabel *cellKmKilo;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeparator2;
@property (weak, nonatomic) IBOutlet UILabel *cellTakeCode;
@property (weak, nonatomic) IBOutlet UIButton *cellXiaoFee;

@end

@implementation SSOrderUngrabCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = BackgroundColor;
    self.cellSeparator1.backgroundColor =
    self.cellSeparator2.backgroundColor = SeparatorLineColor;
    self.cellCommission.textColor = RedDefault;
    self.cellTakeCode.textColor = BlueColor;
    
    [self.cellXiaoFee setTitleColor:BlueColor forState:UIControlStateNormal];
    [self.cellXiaoFee setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]];
    self.cellXiaoFee.layer.borderColor = [SeparatorLineColor CGColor];
    self.cellXiaoFee.layer.borderWidth = 0.5f;
    self.cellXiaoFee.layer.cornerRadius = 1;
    self.cellXiaoFee.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)payXiaoFee:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderUngrabCell:payXiaoFeeWithId:)]) {
        [self.delegate orderUngrabCell:self payXiaoFeeWithId:[NSString stringWithFormat:@"%ld",_datasource.orderId]];
    }
}

- (void)setDatasource:(SSMyOrderModel *)datasource{
    _datasource = datasource;
    self.cellTime.text = _datasource.pubDate;
    self.cellFaAddr.text = _datasource.pickUpAddress;
    self.cellShouAddr.text = _datasource.receviceAddress;
    self.cellCommission.text = [NSString stringWithFormat:@"¥%.2f",_datasource.orderCommission];
    self.cellKmKilo.text = [NSString stringWithFormat:@"%.0f公斤/%.0fkm",_datasource.weight,_datasource.km];
    self.cellTakeCode.text = [NSString stringWithFormat:@"取货码: %@",_datasource.pickupCode];
    self.cellXiaoFee.hidden = (_datasource.status != SSMyOrderStatusUngrab);
}
@end
