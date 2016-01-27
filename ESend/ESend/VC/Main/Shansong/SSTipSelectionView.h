//
//  SSTipSelectionView.h
//  ESend
//
//  Created by 台源洪 on 16/1/19.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSTipSelectionView;

@protocol SSTipSelectionViewDelegate <NSObject>
@optional
- (void)SSTipSelectionView:(SSTipSelectionView*)view selectedTip:(NSNumber*)tip;
@end

@interface SSTipSelectionView : UIView

@property (weak,nonatomic) id<SSTipSelectionViewDelegate>delegate;

- (id)initWithDelegate:(id <SSTipSelectionViewDelegate>)delegate tips:(NSArray *)tips;
- (void)showInView:(UIView *)view;

@end
