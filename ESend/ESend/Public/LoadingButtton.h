//
//  LoadingButtton.h
//  USA-B
//
//  Created by 永来 付 on 15/1/21.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingButtton : UIButton

- (void)starLoadding;
- (void)stopLoadding;

@property (nonatomic ,readonly) UIActivityIndicatorView *activityIndeicatorView;

@end
