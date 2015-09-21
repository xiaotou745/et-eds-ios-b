//
//  SCFBCustomView.h
//  SupermanC
//
//  Created by riverman on 15/9/14.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCFBCancelBlock)();
typedef void(^SCFBSelectBlock)(NSInteger index);

@interface SCFBCustomView : UIView

{
    NSString *titleTxxt;
    NSArray *titlesss;
    NSInteger selectIndex;

    UIImageView *cancelImageV;
    
    
}
@property (nonatomic, strong) UIView *BGView;

//@property(strong,nonatomic)UILabel *indexText;

-(id)initWithWithTitle:(NSString *)title
                Titles:(NSArray *)Titles
           SelectIndex:(NSInteger)index
             onDismiss:(SCFBSelectBlock)selected
              onCancel:(SCFBCancelBlock)cancelled;

@end
