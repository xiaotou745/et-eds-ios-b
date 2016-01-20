//
//  SSOrderOndeliveringV2Cell.h
//  ESend
//
//  Created by 台源洪 on 16/1/20.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMyOrderModel.h"
#import "SSMyOrderStatus.h"
@class SSOrderOndeliveringV2Cell;

@protocol SSOrderOndeliveringV2CellDelegate <NSObject>

- (void)SSOrderOndeliveringV2Cell:(SSOrderOndeliveringV2Cell*)cell getReceiveCodeWithOrder:(SSMyOrderModel *)order;

@end

@interface SSOrderOndeliveringV2Cell : UITableViewCell
@property (nonatomic,strong) SSMyOrderModel * datasource;
@property (nonatomic,weak) id<SSOrderOndeliveringV2CellDelegate>delegate;
@end
