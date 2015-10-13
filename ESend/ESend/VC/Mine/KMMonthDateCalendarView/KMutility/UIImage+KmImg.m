//
//  UIImage+KmImg.m
//  ESend
//
//  Created by 台源洪 on 15/10/12.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "UIImage+KmImg.h"

@implementation UIImage (KmImg)

+ (UIImage *)KM_createImageWithColor:(UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
