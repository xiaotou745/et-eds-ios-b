//
//  EDSRiderDelieveListVC.h
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"

@interface EDSRiderDelieveListVC : BaseViewController

/// 上级页面入参
@property (nonatomic, copy) NSString * dateInfo;
@property (nonatomic, copy) NSString * clienterId;

@property (nonatomic, copy) NSString * clienterName;
@property (nonatomic, copy) NSString * orderCount;      // 骑士订单量


/*
 @property (nonatomic, assign) long clienterId;
 @property (nonatomic, copy) NSString * clienterName;
 @property (nonatomic, copy) NSString * clienterPhone;
 @property (nonatomic, copy) NSString * clienterPhoto;
 @property (nonatomic, assign) long orderCount;
 @property (nonatomic, copy) NSString * pubDate;
 */
@end
