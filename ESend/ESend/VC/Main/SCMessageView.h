//
//  SCMessageView.h
//  SupermanC
//
//  Created by riverman on 15/9/15.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSCMessageView_Vheight 60

typedef void(^SCMessageViewBlock)(void);

@interface SCMessageView : UIView

@property(strong,nonatomic)NSString *Text;

//@property(copy)SCMessageViewBlock  messageViewBlock;

-(id)initWithWithTitle:(NSString *)title AddToView:(UIView *)view
                 onTap:(SCMessageViewBlock)messageViewBlock;
@end
