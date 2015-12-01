//
//  SSMapAddrViewController.h
//  ESend
//
//  Created by 台源洪 on 15/11/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "SSEditorTypeTransformer.h"

@interface SSMapAddrViewController : BaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type;

@end
