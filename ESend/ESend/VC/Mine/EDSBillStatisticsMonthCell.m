//
//  EDSBillStatisticsMonthCell.m
//  ESend
//
//  Created by 台源洪 on 15/10/10.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBillStatisticsMonthCell.h"

@interface EDSBillStatisticsMonthCell ()


@property (strong, nonatomic) IBOutlet UIImageView *separatorImg;
@property (strong, nonatomic) IBOutlet UIImageView *rightImg;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLbl;

@end

@implementation EDSBillStatisticsMonthCell

- (void)awakeFromNib {
    // Initialization code
    self.separatorImg.backgroundColor = SeparatorLineColor;
    
    self.timeLabel.textColor = MiddleGrey;
    self.contentLbl.textColor = TextColor6;
    self.contentLbl.font = [UIFont systemFontOfSize:15];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.separatorImg.backgroundColor = SeparatorLineColor;

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.separatorImg.backgroundColor = SeparatorLineColor;

}

- (void)setDaybillInfo:(DayBillInfo *)daybillInfo{
    _daybillInfo = daybillInfo;
    if (1 == _daybillInfo.hasDatas) {
        self.rightImg.hidden = NO;
    }else{
        self.rightImg.hidden = YES;
    }
    self.contentLbl.text = [NSString stringWithFormat:@"出账 %.2f元 入账 %.2f元",_daybillInfo.outMoney,_daybillInfo.inMoney];
    self.timeLabel.text = _daybillInfo.dayInfo;
}



@end
