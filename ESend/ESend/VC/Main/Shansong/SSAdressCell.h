//
//  SSAdressCell.h
//  ESend
//
//  Created by 台源洪 on 15/11/27.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAddressInfo.h"

@class SSAdressCell;

@protocol SSAdressCellDelegate <NSObject>

@required
- (void)deleteAddressWithId:(NSString *)uid;
@end

@interface SSAdressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *AddressName;
@property (strong, nonatomic) IBOutlet UIImageView *separator;
@property (strong, nonatomic) IBOutlet UILabel *AddressDetail;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *deleteBtnWidth;

@property (strong, nonatomic) SSAddressInfo * addressInfo;

@property (weak,nonatomic) id<SSAdressCellDelegate>delegate;

- (void)hideSeparator;
- (void)hideDeleteBtn;

@end
