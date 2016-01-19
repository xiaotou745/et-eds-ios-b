//
//  SSEditAdderssViewController.h
//  ESend
//
//  Created by 台源洪 on 15/11/26.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SSEditorTypeTransformer.h"
#import "SSMapAddrViewController.h"

@class SSEditAdderssViewController;
@protocol SSEditAdderssViewControllerDelegate <NSObject>
@optional
- (void)editAddressVC:(SSEditAdderssViewController *)vc disSelectPOIAddr:(SSAddressInfo *)poiInfo;
- (void)editAddressVC:(SSEditAdderssViewController *)vc didSelectHistroyAddr:(SSAddressInfo *)address type:(SSAddressEditorType)type;
@end

@interface SSEditAdderssViewController : BaseViewController

@property (nonatomic,copy) NSString * currentCityName;

@property (nonatomic,weak) id<SSEditAdderssViewControllerDelegate>delegate;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type;

@end
