//
//  SSOrderOndeliveringV2Cell.m
//  ESend
//
//  Created by 台源洪 on 16/1/20.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import "SSOrderOndeliveringV2Cell.h"
@interface SSOrderOndeliveringV2Cell ()
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
@implementation SSOrderOndeliveringV2Cell

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
- (IBAction)getReceiveCodeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(SSOrderOndeliveringV2Cell:getReceiveCodeWithOrder:)]) {
        [self.delegate SSOrderOndeliveringV2Cell:self getReceiveCodeWithOrder:_datasource];
    }
}

- (void)setDatasource:(SSMyOrderModel *)datasource{
    _datasource = datasource;
    self.cellTime.text = _datasource.pubDate;
    self.cellFaAddr.text = _datasource.pickUpAddress;
    self.cellShouAddr.text = _datasource.receviceAddress;
    self.cellCommission.text = [NSString stringWithFormat:@"¥%.2f",_datasource.amountAndTip];
    self.cellKmKilo.text = [NSString stringWithFormat:@"%.0f公斤/%.1fkm",_datasource.weight,_datasource.km];
    self.cellTakeCode.text = [NSString stringWithFormat:@"收货码: %@",_datasource.receivecode];
    self.cellXiaoFee.hidden = (_datasource.isReceiveCode == 1);
    self.cellTakeCode.hidden = (_datasource.isReceiveCode == 0);
}

@end
