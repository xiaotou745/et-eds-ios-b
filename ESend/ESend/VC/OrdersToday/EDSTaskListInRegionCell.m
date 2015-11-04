//
//  EDSTaskListInRegionCell.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTaskListInRegionCell.h"

@interface EDSTaskListInRegionCell ()
@property (strong, nonatomic) IBOutlet UIView *cellBgView;

@property (strong, nonatomic) IBOutlet UILabel *grabTime;
@property (strong, nonatomic) IBOutlet UIImageView *cellIndicatorLine;

@property (strong, nonatomic) IBOutlet UIImageView *clienterImg;
@property (strong, nonatomic) IBOutlet UILabel *clienterNameFix;
@property (strong, nonatomic) IBOutlet UILabel *clienterPhoneFix;
@property (strong, nonatomic) IBOutlet UILabel *clienterDestinationFix;

@property (strong, nonatomic) IBOutlet UILabel *clienterName;
@property (strong, nonatomic) IBOutlet UILabel *clienterPhone;
@property (strong, nonatomic) IBOutlet UILabel *clienterDestination;

@property (strong, nonatomic) IBOutlet UILabel *clienterOrderCount;


@end

@implementation EDSTaskListInRegionCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = BackgroundColor;
    
    self.cellBgView.backgroundColor = [UIColor whiteColor];
    self.cellBgView.layer.borderColor = [SeparatorLineColor CGColor];
    self.cellBgView.layer.borderWidth = 0.5f;
    
    self.grabTime.font = [UIFont systemFontOfSize:12];
    self.grabTime.textColor = TextColor9;
    
    self.cellIndicatorLine.backgroundColor = SeparatorLineColor;
    
    self.clienterImg.layer.cornerRadius = CGRectGetWidth(self.clienterImg.frame)/2;
    self.clienterImg.layer.borderWidth = 2.0f;
    self.clienterImg.layer.borderColor = [SeparatorLineColor CGColor];
    
    self.clienterNameFix.font =
    self.clienterPhoneFix.font =
    self.clienterDestinationFix.font = [UIFont systemFontOfSize:14];
    self.clienterNameFix.textColor =
    self.clienterPhoneFix.textColor =
    self.clienterDestinationFix.textColor = TextColor9;
    
    self.clienterName.font =
    self.clienterPhone.font =
    self.clienterDestination.font = [UIFont systemFontOfSize:14];
    self.clienterName.textColor =
    self.clienterPhone.textColor =
    self.clienterDestination.textColor = TextColor6;
    
    self.clienterOrderCount.font = [UIFont systemFontOfSize:14];
    self.clienterOrderCount.textColor = BlueColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.cellIndicatorLine.backgroundColor = SeparatorLineColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.cellIndicatorLine.backgroundColor = SeparatorLineColor;
}

- (void)setDataSrouce:(TaskInRegionModel *)dataSrouce{
    _dataSrouce = dataSrouce;
}

@end
