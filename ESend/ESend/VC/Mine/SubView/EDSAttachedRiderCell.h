//
//  EDSAttachedRiderCell.h
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDSStatisticsInfoClienterInfoModel.h"

@interface EDSAttachedRiderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *AR_SeparatorLine;
@property (strong, nonatomic) IBOutlet UIImageView *AR_RiderPortrait;
@property (strong, nonatomic) IBOutlet UILabel *AR_RiderName;
@property (strong, nonatomic) IBOutlet UILabel *AR_RiderPhone;
@property (strong, nonatomic) IBOutlet UILabel *AR_RiderOrderCount;

@property (strong, nonatomic) EDSStatisticsInfoClienterInfoModel * riderInfo;

@end
