//
//  EDSBillStatisticsDayCell.m
//  ESend
//
//  Created by 台源洪 on 15/10/10.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBillStatisticsDayCell.h"

@interface EDSBillStatisticsDayCell ()

@property (strong, nonatomic) IBOutlet UILabel *rmbMark;
@property (strong, nonatomic) IBOutlet UILabel *amountLbl;
@property (strong, nonatomic) IBOutlet UILabel *remarkLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *separator;

@end

@implementation EDSBillStatisticsDayCell

- (void)awakeFromNib {
    // Initialization code
    self.amountLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    self.amountLbl.textColor = RedDefault;
    self.rmbMark.textColor = RedDefault;
    
    self.timeLbl.font = 
    self.remarkLbl.font = [UIFont boldSystemFontOfSize:15.0f];
    self.remarkLbl.textColor = DeepGrey;
    
    self.timeLbl.textColor = TextColor6;
    
    self.separator.backgroundColor = SeparatorLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.separator.backgroundColor = SeparatorLineColor;

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.separator.backgroundColor = SeparatorLineColor;

}

- (void)setBillInfo:(DayBillDetailInfo *)billInfo{
    _billInfo = billInfo;
    self.amountLbl.text = [NSString stringWithFormat:@"%.2f",_billInfo.amount];
    self.remarkLbl.text = _billInfo.recordType;
    self.timeLbl.text = _billInfo.operateTime;
}

@end
