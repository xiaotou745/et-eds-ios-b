//
//  SSRemainingBalanceCell.h
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "SSPayMethodTypes.h"

@interface SSRemainingBalanceModel : BaseModel

@property (nonatomic,assign) SSPayMethodType payType;
@property (nonatomic,assign) double remainingBalance;
@property (nonatomic,assign) BOOL selected;

@end


@interface SSRemainingBalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *remainingBalance;
@property (weak, nonatomic) IBOutlet UIImageView *separator;
@property (weak, nonatomic) IBOutlet UIImageView *selectionMarker;

@property (strong,nonatomic) SSRemainingBalanceModel * dataSource;

@end
