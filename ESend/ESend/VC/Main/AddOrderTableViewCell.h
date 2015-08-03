//
//  AddOrderTableViewCell.h
//  ESend
//
//  Created by 永来 付 on 15/6/17.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseTableViewCell.h"

@class AddOrderTableViewCell;
@protocol AddOrderTableViewCellDelegate <NSObject>

- (void)removeNewOrderCell:(AddOrderTableViewCell*)addOrderTableViewCell;

@end

@interface AddOrderTableViewCell : BaseTableViewCell

@property (nonatomic, weak) id<AddOrderTableViewCellDelegate> delegate;
@property (nonatomic, strong) UITextField *numberTF;
@property (nonatomic, strong) UILabel *titleNumberLabel;
@property (nonatomic, strong) UIButton *deleteBtn;

@end
