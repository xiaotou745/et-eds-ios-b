//
//  SSAddrAdditionViewController.h
//  ESend
//
//  Created by 台源洪 on 15/12/1.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SSEditorTypeTransformer.h"
#import "SSAddressInfo.h"

@interface SSAddrAdditionViewController : BaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type Addr:(SSAddressInfo *)info;
@end
