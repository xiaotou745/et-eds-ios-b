//
//  CustomTextView.h
//  SuperMark2.0
//
//  Created by 永来 付 on 14/10/29.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView
{
    UIImageView *_imageView;
}
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *highlightImage;

@end
