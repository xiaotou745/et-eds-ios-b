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
            if ([anotherConsignee samePhoneWithConsignee:consignee]) {
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

@end
