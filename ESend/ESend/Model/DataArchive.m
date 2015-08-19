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



@end
