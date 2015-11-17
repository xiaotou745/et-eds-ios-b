//
//  EDSTaskListInRegionCell.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTaskListInRegionCell.h"
#import "UIImageView+WebCache.h"

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
//    self.clienterImg.layer.borderWidth = 2.0f;
//    self.clienterImg.layer.borderColor = [SeparatorLineColor CGColor];
    self.clienterImg.layer.masksToBounds = YES;
    
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
    self.grabTime.text = [self grabTimeWithStr:_dataSrouce.grabTime];
    self.clienterName.text = _dataSrouce.clienterName;
    self.clienterPhone.text = _dataSrouce.clienterPhoneNo;
    self.clienterDestination.text = [NSString stringWithFormat:@"%@ %@",_dataSrouce.orderRegionOneName,_dataSrouce.orderRegionTwoName];
    self.clienterOrderCount.text = [NSString stringWithFormat:@"%ld单",_dataSrouce.orderCount];
    [self.clienterImg sd_setImageWithURL:[NSURL URLWithString:_dataSrouce.clienterHeadPhoto] placeholderImage:[UIImage imageNamed:@"clienter_default_portrait"]];
}

- (NSString *)grabTimeWithStr:(NSString *)str{
    NSAssert(nil != str, @"str is nil");
    NSArray * components = [str componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"抢单 %@:%@",[components firstObject],[components objectAtIndex:1]];
}

- (NSString *)getTimeWithData:(TaskInRegionModel *)dataSrouce{
    NSString * timeStr = nil;
    NSString * headStr = nil;
    switch (dataSrouce.status) {
        case 2:
            timeStr = dataSrouce.grabTime;
            headStr = @"抢单";
            break;
        case 4:
            timeStr = dataSrouce.pickUpTime;
            headStr = @"取货";
            break;
        case 1:
            timeStr = dataSrouce.actualDoneDate;
            headStr = @"完成";
            break;
        default:
            break;
    }
    if (timeStr == nil || headStr == nil) {
        return nil;
    }
    if (timeStr.length < 16) {
        return [NSString stringWithFormat:@"%@ %@",headStr,timeStr];
    }
    NSArray * components = [timeStr componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@ %@:%@",headStr,[components firstObject],[components objectAtIndex:1]];
}

@end
