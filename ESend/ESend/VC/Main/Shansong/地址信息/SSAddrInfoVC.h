//
//  SSAddrInfoVC.h
//  ESend
//
//  Created by 台源洪 on 16/1/15.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SSEditorTypeTransformer.h"
#import "SSAddressInfo.h"

@interface SSAddrInfoVC : BaseViewController

// 必填项
@property (nonatomic,assign) SSAddressEditorType addrType;
// 非必填
@property (nonatomic,copy) NSString * currentCityName;
// 可带入地址
@property (nonatomic,strong) SSAddressInfo * addrInfo;
@end
