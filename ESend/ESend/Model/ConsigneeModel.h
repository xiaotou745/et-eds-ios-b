//
//  ConsigneeModel.h
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"


/*
 收货人，记录发单历史收货人信息
 */
@interface ConsigneeModel : BaseModel

/// id
@property (nonatomic, copy) NSString * consigneeId;
/// 收货人手机号码
@property (nonatomic, copy) NSString * consigneePhone;
/// 收货地址
@property (nonatomic, copy) NSString * consigneeAddress;
/// 发布时间
@property (nonatomic, copy) NSString * consigneePubDate;
/// 收货人姓名
@property (nonatomic, copy) NSString * consigneeUserName;

- (BOOL)equalConsignee:(ConsigneeModel *)otherConsignee;

- (BOOL)samePhoneWithConsignee:(ConsigneeModel *)anotherConsignee;

@end
