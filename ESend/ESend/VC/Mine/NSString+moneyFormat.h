//
//  NSString+moneyFormat.h
//  ESend
//
//  Created by 台源洪 on 15/12/22.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (moneyFormat)
- (BOOL)rightMoneyFormat;

- (BOOL)includesAString:(NSString *)astring;

@end
