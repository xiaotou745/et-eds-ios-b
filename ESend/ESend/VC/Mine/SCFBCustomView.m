//
//  SCFBCustomView.m
//  SupermanC
//
//  Created by riverman on 15/9/14.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCFBCustomView.h"
#import "AppDelegate.h"
#import "ManFactory.h"
#import "UIView+Common.h"

#define  DEF_APP (AppDelegate *)[UIApplication sharedApplication].delegate

#define SCFBCustomView_rowHeight  50


static SCFBCancelBlock _cancelBlock;
static SCFBSelectBlock _selectBlock;
@implementation SCFBCustomView


-(id)initWithWithTitle:(NSString *)titleText
                Titles:(NSArray *)Titles
           SelectIndex:(NSInteger)index
             onDismiss:(SCFBSelectBlock)selected
              onCancel:(SCFBCancelBlock)cancelled{
    
    self=[super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    if (self) {
        _selectBlock=[selected copy];
        _cancelBlock=[cancelled copy];
    
        titleTxxt=titleText;
        titlesss=[Titles copy];
        selectIndex=index;
        [self makeUI];
//        AppDelegate *appdelegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
        [[DEF_APP window] addSubview:self];
    }
    return self;
}

-(void)makeUI
{
    self.userInteractionEnabled=YES;
    self.backgroundColor=[UIColor blackColor];
    self.alpha=0.7;
    
    UITapGestureRecognizer *ges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
    [self addGestureRecognizer:ges];
    
    BGView=[ManFactory createImageViewWithFrame:CGRectMake(0, 0, 260, (titlesss.count+2)*SCFBCustomView_rowHeight) ImageName:@""];
    BGView.layer.cornerRadius=5;
    BGView.layer.masksToBounds=YES;

    BGView.alpha=1;
    BGView.center=CGPointMake(ScreenWidth/2, ScreenHeight/2);
    BGView.backgroundColor=[UIColor whiteColor];
    [self addSubview:BGView];
    
    
    UILabel *titleTxet=[ManFactory createLabelWithFrame:CGRectMake(0, 0, BGView.width, SCFBCustomView_rowHeight) Font:18 Text:titleTxxt];
    titleTxet.textAlignment=NSTextAlignmentCenter;
    titleTxet.backgroundColor=[UIColor whiteColor];
    [BGView addSubview:titleTxet];
    
    UIImageView *cancelIcon=[ManFactory createImageViewWithFrame:CGRectMake(BGView.width-25, 10, 15, 15) ImageName:@"feedBack_cancel"];
//    cancelIcon.layer.cornerRadius=0;
//    cancelIcon.layer.masksToBounds=YES;
    cancelIcon.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *gessss=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle)];
    [cancelIcon addGestureRecognizer:gessss];
    [BGView addSubview:cancelIcon];
    
    for (int i=0; i<titlesss.count; i++) {
        
        UIImageView *Icon=[ManFactory createImageViewWithFrame:CGRectMake(30,SCFBCustomView_rowHeight*(i+1)+15, 20, 20) ImageName:@""];
        
        Icon.backgroundColor=[UIColor lightGrayColor];
        if (i == selectIndex) {
//            Icon.backgroundColor=[UIColor greenColor];
            Icon.image=[UIImage imageNamed:@"feedBack_selected"];
        }
        Icon.layer.cornerRadius=10;
        Icon.layer.masksToBounds=YES;
        Icon.tag=1000+i;
        
        
        UILabel  *contentText=[ManFactory createLabelWithFrame:CGRectMake(Icon.right+10, SCFBCustomView_rowHeight*(i+1), 100, SCFBCustomView_rowHeight) Font:17 Text:titlesss[i]];
        
        [BGView addSubview:Icon];
        [BGView addSubview:contentText];

        //灰色线条
        UILabel *topline=[ManFactory createLabelWithFrame:CGRectMake(30, SCFBCustomView_rowHeight*(i+1), BGView.width-60, 1) Font:15 Text:@""];
        topline.backgroundColor=[UIColor lightGrayColor];
        [BGView addSubview:topline];
        
       
        //bottomline
        UILabel *bottomline=[ManFactory createLabelWithFrame:CGRectMake(0, SCFBCustomView_rowHeight*(titlesss.count+1), BGView.width, 1) Font:15 Text:@""];
        bottomline.backgroundColor=[UIColor lightGrayColor];
        [BGView addSubview:bottomline];
        
        UIButton *confirmBTN=[ManFactory createButtonWithFrame:CGRectMake(0, bottomline.bottom, BGView.width, SCFBCustomView_rowHeight) ImageName:@"" Target:self Action:@selector(confirmClick) Title:@"确定"];
        [confirmBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmBTN setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

        [BGView addSubview:confirmBTN];
        
        
        //覆盖透明view  添加选择手势
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, SCFBCustomView_rowHeight*(i+1), BGView.width, SCFBCustomView_rowHeight)];
        view.tag=2000+i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectIndex:)];
        [view addGestureRecognizer:tap];
        [BGView addSubview:view];
        
        
    }
}

-(void)selectIndex:(UITapGestureRecognizer *)tapHandle
{
    selectIndex=tapHandle.view.tag-2000;
    
    UIImageView *icon=(UIImageView *)[self viewWithTag:(tapHandle.view.tag-1000)];
    
    for (int i=0; i<titlesss.count; i++) {
        UIImageView *vvvvv=(UIImageView *)[self viewWithTag:1000+i];
        vvvvv.image=[UIImage imageNamed:@""];
        vvvvv.backgroundColor=[UIColor lightGrayColor];
    }
    
    icon.image=[UIImage imageNamed:@"feedBack_selected"];
    //icon.backgroundColor=[UIColor greenColor];
    
}
-(void)confirmClick
{
    _selectBlock(selectIndex);
    [self cancelClick];
}

-(void)tapHandle
{
    [self cancelClick];
}
-(void)cancelClick
{
    [self removeFromSuperview];
    //self.grCancelBock();
}

@end
