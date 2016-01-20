//
//  NSString+stringSizes.h
//  etaoshi3.0
//
//  Created by Maxwell on 14/12/5.
//  Copyright (c) 2014年 etaostars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (stringSizes)
- (CGFloat)stringSizeWidthWithFontSize:(CGFloat)fontSize height:(CGFloat)aHeight;
- (CGFloat)stringSizeHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)aWidth;
@end
