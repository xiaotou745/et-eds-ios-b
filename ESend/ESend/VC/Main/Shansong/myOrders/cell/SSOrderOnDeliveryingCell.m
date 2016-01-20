//
//  SSOrderOnDeliveryingCell.m
//  ESend
//
//  Created by 台源洪 on 15/12/18.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSOrderOnDeliveryingCell.h"

@interface SSOrderOnDeliveryingCell ()

@property (weak, nonatomic) IBOutlet UILabel *cellTime;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeparator1;
@property (weak, nonatomic) IBOutlet UILabel *cellFaAddr;
@property (weak, nonatomic) IBOutlet UILabel *cellShouAddr;
@property (weak, nonatomic) IBOutlet UILabel *cellCommission;
@property (weak, nonatomic) IBOutlet UILabel *cellKmKilo;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeparator2;

@end

@implementation SSOrderOnDeliveryingCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = BackgroundColor;
    self.cellSeparator1.backgroundColor = SeparatorLineColor;
    // self.cellSeparator2.backgroundColor = SeparatorLineColor;
    self.cellCommission.textColor = RedDefault;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDatasource:(SSMyOrderModel *)datasource{
    _datasource = datasource;
    self.cellTime.text = _datasource.pubDate;
    self.cellFaAddr.text = _datasource.pickUpAddress;
    self.cellShouAddr.text = _datasource.receviceAddress;
    self.cellCommission.text = [NSString stringWithFormat:@"¥%.2f",_datasource.amountAndTip];
    self.cellKmKilo.text = [NSString stringWithFormat:@"%.0f公斤/%.1fkm",_datasource.weight,_datasource.km];
}

@end