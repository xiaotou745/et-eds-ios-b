//
//  KMNavigationTitleView.h
//  ESend
//
//  Created by 台源洪 on 15/10/10.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KMNavigationTitleViewStyle) {
    KMNavigationTitleViewStyleDay,     // Date view
    KMNavigationTitleViewStyleMonth     // Month view
};

// 分类type
typedef NS_ENUM(NSInteger, KMNavigationTitleViewOptionType) {
    KMNavigationTitleViewOptionTypeAll,     // all
    KMNavigationTitleViewOptionTypePay,     // pay
    KMNavigationTitleViewOptionTypeIncome   // income
};

@class KMNavigationTitleView;

@protocol KMNavigationTitleViewDelegate <NSObject>

- (void)KMNavigationTitleView:(KMNavigationTitleView*)view shouldHideContentView:(KMNavigationTitleViewOptionType)optionType typeId:(NSInteger)typeId;
- (void)KMNavigationTitleView:(KMNavigationTitleView*)view shouldShowContentView:(KMNavigationTitleViewOptionType)ot typeId:(NSInteger)tid;

@end

// 100,44  self.size

@interface KMNavigationTitleView : UIView

@property (nonatomic, assign) KMNavigationTitleViewStyle style;
@property (nonatomic, assign) KMNavigationTitleViewOptionType optionType; // 0,1,2
@property (nonatomic, assign) NSInteger typeId; // 

@property (nonatomic, weak) id<KMNavigationTitleViewDelegate>delegate;

@end
