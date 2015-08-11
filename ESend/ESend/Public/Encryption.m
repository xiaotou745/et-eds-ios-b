//
//  Encryption.m
//  USA-B
//
//  Created by 永来 付 on 15/2/3.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import "Encryption.h"
#import "NSString+encrypto.h"
#import "UserInfo.h"

#define EncryptionToken @"YG.USFood.IPHONE.p6UWqqczyqf4ELmbJLwomcHWSjwDe6ZJ5Dg4lGokRrQtG"

@implementation Encryption

+ (NSString*)createEncryption {
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];

    NSInteger randomNum = arc4random()%10000;
    NSString *nonce = [[timeStr stringByAppendingFormat:@"%@%ld",EncryptionToken,(long)randomNum] md5];

    NSArray *datas = @[EncryptionToken, timeStr, nonce];
    
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray = [datas sortedArrayUsingComparator:sort];
    
    NSString *resultStr = @"" ;
    for (NSString *str in resultArray) {
        resultStr = [resultStr stringByAppendingString:str];
    }
    
    NSString *signature = [resultStr sha1];
    
    NSDictionary *dic = @{@"timestamp" : timeStr,
                          @"nonce" : nonce,
                          @"signature": signature};
    
    NSString *str = [[self class] stringFromDic:dic];
    
    return str;
}

+ (NSString*)stringFromDic:(NSDictionary*)dic {
    
    NSMutableString *str = [NSMutableString new];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendString:key];
        [str appendString:@"="];
        [str appendString:obj];
        [str appendString:@"&"];
    }];
    return [str substringToIndex:str.length-1];
}


+ (NSDictionary *)ESendB_Encryptioin{
    NSString * ssid = [UserInfo getUUID];
    NSString * token = [UserInfo getToken];
    NSString * appkey = [UserInfo getAppkey];
    NSMutableDictionary * headerDict = [NSMutableDictionary dictionary];
    if (token) {
        [headerDict setObject:token forKey:@"token"];
    }
    if (appkey) {
        [headerDict setObject:appkey forKey:@"appkey"];
    }
    if (ssid) {
        [headerDict setObject:ssid forKey:@"ssid"];
    }
    return headerDict;
}

@end
