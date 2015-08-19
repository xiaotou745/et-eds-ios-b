//
//  DataArchive.h
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataArchive : NSObject
+ (void)storeConsignees:(NSArray*)consignees shopId:(NSString *)shopid;
+ (NSArray *)storedConsigneesWithShopid:(NSString *)bid;
@end
