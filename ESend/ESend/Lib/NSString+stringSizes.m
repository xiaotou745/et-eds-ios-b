//
//  NSString+stringSizes.m
//  etaoshi3.0
//
//  Created by Maxwell on 14/12/5.
//  Copyright (c) 2014年 etaostars. All rights reserved.
//

#import "NSString+stringSizes.h"
#import <UIKit/UIKit.h>

@implementation NSString (stringSizes)
- (CGFloat)stringSizeWidthWithFontSize:(CGFloat)fontSize height:(CGFloat)aHeight{
    
//            return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, aHeight)].width;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // ios7及以后
        UIFont *anFont = [UIFont systemFontOfSize:fontSize];
        NSDictionary * anAttribute = [NSDictionary dictionaryWithObjectsAndKeys:anFont,NSFontAttributeName, nil];
        return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, aHeight) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:anAttribute context:nil].size.width;
        
    }else{// ios6及以前
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, aHeight)].width;
    }
}

- (CGFloat)stringSizeHeightWithFontSize:(CGFloat)fontSize width:(CGFloat)aWidth{
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // ios7及以后
        UIFont *anFont = [UIFont systemFontOfSize:fontSize];
        NSDictionary * anAttribute = [NSDictionary dictionaryWithObjectsAndKeys:anFont,NSFontAttributeName, nil];
        return [self boundingRectWithSize:CGSizeMake(aWidth, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:anAttribute context:nil].size.height;
        
    }else{// ios6及以前
        return [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(aWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    }

}





//
//- (void)_{
////    - (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(NSDictionary *)attributes context:(NSStringDrawingContext *)context NS_AVAILABLE_IOS(7_0);
//    CGSize size = [taskTypeEntity.name boundingRectWithSize:self.frame.size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size
//}

- (void)_tests{
    
    CGFloat fontSize = 16;
    CGFloat aHeight = 30;
    
    
    // one  iOS7以后
    UIFont *tmp1 = [UIFont systemFontOfSize:fontSize];
    
    
    CGSize aa = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:tmp1, NSFontAttributeName, nil]];
    
    NSLog(@"1:%f,%f",aa.width,aa.height);
    
    // two   iOS7以后
    
    UIFont *anFont = [UIFont systemFontOfSize:fontSize];
    NSDictionary * anAttribute = [NSDictionary dictionaryWithObjectsAndKeys:anFont,NSFontAttributeName, nil];
    
    
    CGSize bb = [self boundingRectWithSize:CGSizeMake(aHeight, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:anAttribute context:nil].size;
    NSLog(@"2:%f,%f",bb.width,bb.height);
    
    
    // three    ios7 - 不建议用
    
    CGSize cc = [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(aHeight, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"3:%f,%f",cc.width,cc.height);
}
@end
