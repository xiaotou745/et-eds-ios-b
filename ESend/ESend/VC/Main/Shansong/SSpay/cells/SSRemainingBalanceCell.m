//
//  SSRemainingBalanceCell.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSRemainingBalanceCell.h"

@implementation SSRemainingBalanceModel

@end



@implementation SSRemainingBalanceCell

- (void)awakeFromNib {
    self.separator.backgroundColor = SeparatorLineColor;
    self.remainingBalance.textColor = DeepGrey;
    self.remainingBalance.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataSource:(SSRemainingBalanceModel *)dataSource{
    _dataSource = dataSource;
    self.remainingBalance.text = [NSString stringWithFormat:@"账户余额: ¥%.2f",_dataSource.remainingBalance];
    self.selectionMarker.image = _dataSource.selected?[UIImage imageNamed:@"ss_release_selected"]:[UIImage imageNamed:@"ss_release_normal"];
}
@end
