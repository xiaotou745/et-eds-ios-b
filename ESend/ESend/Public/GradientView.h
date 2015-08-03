//
//  GradientView.h
//  JiaLiMei
//
//  Created by 永来 付 on 15/4/3.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

/*
 渐变半透明遮罩
 */

#import <UIKit/UIKit.h>

@interface GradientView : UIView
{
    NSString *_orientation;
}

- (id)initWithFrame:(CGRect)frame orientation:(NSString*)orientation;

@end
