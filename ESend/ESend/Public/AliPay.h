//
//  AliPay.h
//  ESend
//
//  Created by 永来 付 on 15/6/26.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPay : NSObject

+ (void)payWithPrice:(float)price orderNumber:(NSString*)orderNumber notifyURL:(NSString*)url productName:(NSString *)productName;

@end
