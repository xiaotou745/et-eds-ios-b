//
//  ConsigneeModel.m
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ConsigneeModel.h"

@implementation ConsigneeModel

- (BOOL)equalConsignee:(ConsigneeModel *)otherConsignee{
    BOOL result = NO;
    if ([self.consigneePhone compare:otherConsignee.consigneePhone] == NSOrderedSame  &&  [self.consigneeAddress compare:otherConsignee.consigneeAddress] == NSOrderedSame && [self.consigneeUserName compare:otherConsignee.consigneeUserName] == NSOrderedSame) {
        result = YES;
    }
    return result;
}

- (BOOL)samePhoneWithConsignee:(ConsigneeModel *)anotherConsignee{
    BOOL result = NO;
    if ([self.consigneePhone compare:anotherConsignee.consigneePhone] == NSOrderedSame) {
        result = YES;
    }
    return result;
}

@end
