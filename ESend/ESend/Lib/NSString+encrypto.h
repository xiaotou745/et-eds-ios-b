//
//  NSString+encrypto.h
//  USA-B
//
//  Created by 永来 付 on 15/1/30.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encrypto)

- (NSString *) md5;
- (NSString *) sha1;
- (NSString *)ETSMD5;
//- (NSString *) sha1_base64;
//- (NSString *) md5_base64;
//- (NSString *) base64;

@end
