//
//  EDSMyClienterCell.h
//  ESend
//
//  Created by 台源洪 on 15/11/6.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDSMyClienter.h"

UIKIT_EXTERN NSString *const EDSMyClienterInService;
UIKIT_EXTERN NSString *const EDSMyClienterApplyingAdd;
UIKIT_EXTERN NSString *const EDSMyClienterApplyingReject;

@class EDSMyClienterCell;

@protocol EDSMyClienterCellDelegate <NSObject>
@optional
- (void)clienterCell:(EDSMyClienterCell *)cell didClickTitle:(NSString *)title cellInfo:(EDSMyClienter *)userInfo;

@end

@interface EDSMyClienterCell : UITableViewCell
@property (nonatomic,strong) EDSMyClienter * datasource;
@property (nonatomic,weak) id<EDSMyClienterCellDelegate>delegate;
@property (nonatomic,copy) NSString * buttonTitle;
@property (nonatomic,copy) NSString * buttonTitle2;
@end
