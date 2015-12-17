//
//  SSOrderUnpayCell.h
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMyOrderModel.h"

@class SSOrderUnpayCell;
@protocol SSOrderUnpayCellDelegate <NSObject>

@optional
- (void)orderUnpayCell:(SSOrderUnpayCell *)cell payWithId:(NSString *)orderId;

@end

@interface SSOrderUnpayCell : UITableViewCell
@property (nonatomic,strong) SSMyOrderModel * datasource;
@property (nonatomic,weak) id<SSOrderUnpayCellDelegate>delegate;

@end
