//
//  ETSGuideView.h
//  TSPizza
//
//  Created by Maxwell on 14/11/4.
//  Copyright (c) 2014年 ETS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ETSGuideView;

@protocol ETSGuideViewDelegate

- (void)guideView:(ETSGuideView *)guideView didTouchFinishButton:(id)button;

@end

@interface ETSGuideView : UIView

@property (nonatomic, weak) id<ETSGuideViewDelegate>delegate;

/// 添加到父视图上
- (id)initWithView:(UIView *)superView;
/// dataSource
- (void)guideViewWithArray:(NSArray *)dataArray;
@end
