//
//  DataArchive.h
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsigneeModel.h"

@interface DataArchive : NSObject
+ (void)storeConsignees:(NSArray*)consignees shopId:(NSString *)shopid;
+ (NSArray *)storedConsigneesWithShopid:(NSString *)bid;

///delete
+ (void)deleteConsignee:(ConsigneeModel *)consignee shopId:(NSString *)shopid;
@end
