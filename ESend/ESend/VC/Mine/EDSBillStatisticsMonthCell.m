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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
