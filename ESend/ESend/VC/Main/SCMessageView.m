//
//  SCMessageView.m
//  SupermanC
//
//  Created by riverman on 15/9/15.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCMessageView.h"
#import "ManFactory.h"
#import "UIView+Common.h"

#define kSCMessageView_height 50

static SCMessageViewBlock _messageViewBlock;

@implementation SCMessageView


-(id)initWithWithTitle:(NSString *)title AddToView:(UIView *)view
                 onTap:(SCMessageViewBlock)messageViewBlock{

    _messageViewBlock=[messageViewBlock copy];
    
    self=[super  initWithFrame:CGRectMake(0, 64+10, ScreenWidth,kSCMessageView_height)];
    
    if (self) {
        _Text=title;
        [view addSubview:self];
        [view bringSubviewToFront:self];
       [self makeUI] ;
    }
    
    return self;
}
-(void)makeUI
{

    self.backgroundColor=[UIColor whiteColor];
    self.userInteractionEnabled=YES;
    
    UIImageView *icon=[ManFactory createImageViewWithFrame:CGRectMake(5, 15, 20, 20) ImageName:@"newMessage_sound"];
    [self addSubview:icon];
    
    UILabel *text=[ManFactory createLabelWithFrame:CGRectMake(icon.right+10, 10, ScreenWidth-80, kSCMessageView_height-20) Font:15 Text:_Text];
    text.lineBreakMode=NSLineBreakByTruncatingTail;
    text.numberOfLines=1;
    text.adjustsFontSizeToFitWidth=NO;

    [self addSubview:text];
    
    UIImageView *arrow=[ManFactory createImageViewWithFrame:CGRectMake(text.right+10, 15, 20, 20) ImageName:@"newMessage_arrow"];
    [self addSubview:arrow];
    
    
    //覆盖透明view  添加选择手势
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0 , self.width, kSCMessageView_height)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
    [view addGestureRecognizer:tap];
    [self addSubview:view];
}

-(void)tapHandle
{
    _messageViewBlock();
}
@end
