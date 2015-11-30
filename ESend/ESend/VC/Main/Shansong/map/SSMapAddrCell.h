//
//  SSMapAddrCell.h
//  ESend
//
//  Created by 台源洪 on 15/11/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMapAddrInfo.h"

@interface SSMapAddrCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *statusImg;
@property (strong, nonatomic) IBOutlet UIImageView *upperSeparator;
@property (strong, nonatomic) IBOutlet UIImageView *bottomSeparator;
@property (strong, nonatomic) IBOutlet UILabel *addressName;
@property (strong, nonatomic) IBOutlet UILabel *addressDetail;

@property (nonatomic,strong) SSMapAddrInfo * addrInfo;

@end
