//
//  Encryption.h
//  USA-B
//
//  Created by 永来 付 on 15/2/3.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

/*
 
 http请求加密，需要将其加入到header中
 
 */

#import <Foundation/Foundation.h>

@interface Encryption : NSObject

+ (NSString*)createEncryption;

@end
