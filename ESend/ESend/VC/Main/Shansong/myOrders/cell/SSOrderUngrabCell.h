//
//  SSOrderUngrabCell.h
//  ESend
//
//  Created by 台源洪 on 15/12/17.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMyOrderModel.h"
#import "SSMyOrderStatus.h"

@class SSOrderUngrabCell;

@protocol SSOrderUngrabCellDelegate <NSObject>

@optional
- (void)orderUngrabCell:(SSOrderUngrabCell *)cell payXiaoFeeWithId:(NSString *)orderId balancePrice:(double)balancePrice;

@end

@interface SSOrderUngrabCell : UITableViewCell
@property (nonatomic,weak) id<SSOrderUngrabCellDelegate>delegate;
@property (nonatomic,strong) SSMyOrderModel * datasource;

@end
