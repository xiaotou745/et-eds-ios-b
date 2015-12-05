//
//  DataArchive.m
//  ESend
//
//  Created by Maxwell on 15/8/19.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "DataArchive.h"

@implementation DataArchive

+ (void)storeConsignees:(NSArray*)consignees shopId:(NSString *)shopid{
    
    NSMutableDictionary * rootDict = [self rootMenuDictionary];
    
    if (rootDict == nil) {
        rootDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    if (consignees) {
        [rootDict setObject:consignees forKey:shopid];
    }
    [NSKeyedArchiver archiveRootObject:rootDict toFile:[self rootFilePath]];
}

+ (NSString *)rootFilePath{
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    return [docp stringByAppendingString:[NSString stringWithFormat:@"/menus.dat"]];
}

+ (NSMutableDictionary *)rootMenuDictionary{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self rootFilePath]];
}

+ (NSArray *)storedConsigneesWithShopid:(NSString *)bid{
    return [[self rootMenuDictionary] objectForKey:bid];
}



//delete
+ (void)deleteConsignee:(ConsigneeModel *)consignee shopId:(NSString *)shopid{
    NSMutableDictionary * rootDict = [self rootMenuDictionary];
    
    if (rootDict == nil) {
        return;
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:[self storedConsigneesWithShopid:shopid]];
    
    if ([consignee.consigneeId compare:@"-1"] == NSOrderedSame) {
        //
        for (int i = 0; i < array.count; i ++) {
            ConsigneeModel * anotherConsignee = [array objectAtIndex:i];
            if ([anotherConsignee equalConsignee:consignee]) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
        
    }else{
        
        for (int i = 0; i < array.count; i ++) {
            ConsigneeModel * anotherConsignee = [array objectAtIndex:i];
            if ([anotherConsignee.consigneeId compare:consignee.consigneeId ]  == NSOrderedSame) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
    }
    [self storeConsignees:array shopId:shopid];
}


/*  发货收货地址  */
/*
 闪送 发货，收货地址
 */

+ (NSString *)rootFaAddrFilePath{
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    return [docp stringByAppendingString:[NSString stringWithFormat:@"/ssFaAddrs.dat"]];
}

+ (NSMutableDictionary *)rootFaAddrDictionary{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self rootFaAddrFilePath]];
}

+ (void)storeFaAddress:(SSAddressInfo *)addr businessId:(NSString *)bid{
    NSMutableDictionary * rootDict = [self rootFaAddrDictionary];
    if (rootDict == nil) {
        rootDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    NSMutableArray * addrs = [rootDict objectForKey:bid];
    if (nil == addrs) {
        addrs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (addr) {
        BOOL isContained = NO;
        for (SSAddressInfo * addrInfo in addrs) {
            if ([addr sameTo:addrInfo]) {
                isContained = YES;
                break;
            }
        }
        if (!isContained) {
            [addrs addObject:addr];
        }
    }
    [rootDict setObject:addrs forKey:bid];
    [NSKeyedArchiver archiveRootObject:rootDict toFile:[self rootFaAddrFilePath]];
}
+ (NSArray *)storedFaAddrsWithBusinessId:(NSString *)bid{
    return [[self rootFaAddrDictionary] objectForKey:bid];
}

+ (void)deleteFaAddrWithId:(NSString *)uid bid:(NSString *)bid{
    NSMutableDictionary * rootDict = [self rootFaAddrDictionary];
    if (rootDict == nil) {
        return;
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:[self storedFaAddrsWithBusinessId:bid]];
    for (int i = 0; i < array.count; i++) {
        SSAddressInfo * addrInfo = [array objectAtIndex:i];
        if ([addrInfo.uid compare:uid] == NSOrderedSame) {
            [array removeObjectAtIndex:i];
            break;
        }
    }
    [rootDict setObject:array forKey:bid];
    [NSKeyedArchiver archiveRootObject:rootDict toFile:[self rootFaAddrFilePath]];
}

///////// = = = == = = = = = == =  收
+ (NSString *)rootShouAddrFilePath{
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    return [docp stringByAppendingString:[NSString stringWithFormat:@"/ssShouAddrs.dat"]];
}

+ (NSMutableDictionary *)rootShouAddrDictionary{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self rootShouAddrFilePath]];
}

+ (void)storeShouAddress:(SSAddressInfo *)addr businessId:(NSString *)bid{
    NSMutableDictionary * rootDict = [self rootShouAddrDictionary];
    if (rootDict == nil) {
        rootDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    NSMutableArray * addrs = [rootDict objectForKey:bid];
    if (nil == addrs) {
        addrs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (addr) {
        BOOL isContained = NO;
        for (SSAddressInfo * addrInfo in addrs) {
            if ([addr sameTo:addrInfo]) {
                isContained = YES;
                break;
            }
        }
        if (!isContained) {
            [addrs addObject:addr];
        }
    }
    [rootDict setObject:addrs forKey:bid];
    [NSKeyedArchiver archiveRootObject:rootDict toFile:[self rootShouAddrFilePath]];
}

+ (NSArray *)storedShouAddrsWithBusinessId:(NSString *)bid{
    return [[self rootShouAddrDictionary] objectForKey:bid];
}

+ (void)deleteShouAddrWithId:(NSString *)uid bid:(NSString *)bid{
    NSMutableDictionary * rootDict = [self rootShouAddrDictionary];
    if (rootDict == nil) {
        return;
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:[self storedShouAddrsWithBusinessId:bid]];
    for (int i = 0; i < array.count; i++) {
        SSAddressInfo * addrInfo = [array objectAtIndex:i];
        if ([addrInfo.uid compare:uid] == NSOrderedSame) {
            [array removeObjectAtIndex:i];
            break;
        }
    }
    [rootDict setObject:array forKey:bid];
    [NSKeyedArchiver archiveRootObject:rootDict toFile:[self rootShouAddrFilePath]];
}
@end
