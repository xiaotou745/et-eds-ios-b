//
//  KMNavigationTitleView.h
//  ESend
//
//  Created by 台源洪 on 15/10/10.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BS_Header.h"

typedef NS_ENUM(NSInteger, KMNavigationTitleViewStyle) {
    KMNavigationTitleViewStyleDay,     // Date view
    KMNavigationTitleViewStyleMonth     // Month view
};


@class KMNavigationTitleView;

@protocol KMNavigationTitleViewDelegate <NSObject>

- (void)KMNavigationTitleView:(KMNavigationTitleView*)view shouldHideContentView:(BS_RecordType)optionType typeId:(NSInteger)typeId;
- (void)KMNavigationTitleView:(KMNavigationTitleView*)view shouldShowContentView:(BS_RecordType)ot typeId:(NSInteger)tid;

@end

// 100,44  self.size

@interface KMNavigationTitleView : UIView

@property (nonatomic, assign) KMNavigationTitleViewStyle style;
@property (nonatomic, assign) BS_RecordType optionType; // 0,1,2
@property (nonatomic, assign) NSInteger typeId; //
@property (nonatomic,copy) NSString * titleString;  

@property (nonatomic, assign) BOOL imgIsUp;                 // showing

@property (nonatomic, weak) id<KMNavigationTitleViewDelegate>delegate;

- (void)titleButtonAction:(UIButton *)sender;



@end
