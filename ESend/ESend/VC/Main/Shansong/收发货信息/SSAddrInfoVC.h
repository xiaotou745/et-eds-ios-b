//
//  SSAddrInfoVC.h
//  ESend
//
//  Created by 台源洪 on 16/1/15.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SSEditorTypeTransformer.h"

@interface SSAddrInfoVC : BaseViewController

// 必填项
@property (nonatomic,assign) SSAddressEditorType addrType;
// 非必填
@property (nonatomic,copy) NSString * currentCityName;

@end
