//
//  ConsigneeInfoCell.h
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConsigneeModel.h"

@class ConsigneeInfoCell;

@protocol ConsigneeInfoCellDelegate <NSObject>

- (void)ConsigneeInfoCell:(ConsigneeInfoCell *)cell deleteButtonAction:(ConsigneeModel*)consignee;

@end

@interface ConsigneeInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *consigneePhone;
@property (strong, nonatomic) IBOutlet UILabel *consigneeAddress;
@property (strong, nonatomic) IBOutlet UILabel *seperator;

@property (strong, nonatomic) ConsigneeModel * consigneeInfo;

@property (weak,nonatomic) id<ConsigneeInfoCellDelegate>delegate;

@end
