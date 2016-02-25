//
//  ETSGuideView.m
//  TSPizza
//
//  Created by Maxwell on 14/11/4.
//  Copyright (c) 2014年 ETS. All rights reserved.
//

#import "ETSGuideView.h"

@interface ETSGuideView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIButton * finishButton;
@property (strong, nonatomic) UIScrollView * scrollView;

- (void)_finishButtonEvent:(id)sender;

@end

@implementation ETSGuideView

- (id)initWithView:(UIView *)superView
{
    if (self = [super init]) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setUserInteractionEnabled:YES];
        [superView addSubview:self];
        // contraints
        NSDictionary * aViews = NSDictionaryOfVariableBindings(self);
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[self]-(==0)-|" options:0 metrics:nil views:aViews]];
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[self]-(==0)-|" options:0 metrics:nil views:aViews]];
    }
    return self;
}

- (void)guideViewWithArray:(NSArray *)dataArray
{
    if (nil == dataArray) {
        return;
    }
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setScrollEnabled:YES];
    [_scrollView setDelegate:self];
    [_scrollView setBounces:NO];
    [_scrollView setPagingEnabled:YES];
    [self addSubview:_scrollView];
    //
    NSDictionary * aViews = NSDictionaryOfVariableBindings(_scrollView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[_scrollView]-(==0)-|" options:0 metrics:nil views:aViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[_scrollView]-(==0)-|" options:0 metrics:nil views:aViews]];
    
    // test
    for (int i = 0; i < [dataArray count]; i ++) {
        UIImageView * aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataArray[i]]];
        [aImageView setUserInteractionEnabled:YES];
        [aImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:aImageView];
        //
        // 相对于contentSize
        NSDictionary * aViews = NSDictionaryOfVariableBindings(aImageView);
        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(==%f)-[aImageView(%f)]-(==%f)-|",i * ScreenWidth,ScreenWidth,([dataArray count] - i - 1) * ScreenWidth] options:0 metrics:nil views:aViews]];
        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(==0)-[aImageView(%f)]-(==0)-|",ScreenHeight] options:0 metrics:nil views:aViews]];
        
        if ([dataArray count] - 1 == i) {
            _finishButton = [[UIButton alloc] init];
            [_finishButton addTarget:self action:@selector(_finishButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_finishButton setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_finishButton setImage:[UIImage imageNamed:@"instruct_btn_normal"] forState:UIControlStateNormal];
            [_finishButton setImage:[UIImage imageNamed:@"instruct_btn_highlight"] forState:UIControlStateHighlighted];
            [aImageView addSubview:_finishButton];
            // constraints
            NSDictionary * bViews = NSDictionaryOfVariableBindings(_finishButton);
            [aImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_finishButton(90)]-(==40)-|" options:0 metrics:nil views:bViews]];
            [aImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(==%f)-[_finishButton(120)]-(==%f)-|",(ScreenWidth-120)/2,(ScreenWidth-120)/2] options:0 metrics:nil views:bViews]];
        }
    }
    [_scrollView setContentSize:CGSizeMake(ScreenWidth * [dataArray count], ScreenHeight)];
}

- (void)_finishButtonEvent:(id)sender{
    [self.delegate guideView:self didTouchFinishButton:sender];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)dealloc
{
    if (_scrollView) {
        [_scrollView removeFromSuperview]; _scrollView = nil;
    }
}

@end
