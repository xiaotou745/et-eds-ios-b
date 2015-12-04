//
//  DataArchive.h
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsigneeModel.h"
#import "SSAddressInfo.h"

@interface DataArchive : NSObject
// 发单手机号
+ (void)storeConsignees:(NSArray*)consignees shopId:(NSString *)shopid;
+ (NSArray *)storedConsigneesWithShopid:(NSString *)bid;

///delete
+ (void)deleteConsignee:(ConsigneeModel *)consignee shopId:(NSString *)shopid;


/*
 闪送 发货，收货地址
 */
+ (void)storeFaAddress:(SSAddressInfo *)addr businessId:(NSString *)bid;
+ (NSArray *)storedFaAddrsWithBusinessId:(NSString *)bid;
+ (void)deleteFaAddrWithId:(NSString *)uid bid:(NSString *)bid;

+ (void)storeShouAddress:(SSAddressInfo *)addr businessId:(NSString *)bid;
+ (NSArray *)storedShouAddrsWithBusinessId:(NSString *)bid;
+ (void)deleteShouAddrWithId:(NSString *)uid bid:(NSString *)bid;

@end
