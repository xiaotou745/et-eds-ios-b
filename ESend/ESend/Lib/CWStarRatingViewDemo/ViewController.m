//
//  ViewController.m
//  CWStarRatingViewDemo
//
//  Created by WANGCHAO on 14/11/8.
//  Copyright (c) 2014年 wangchao. All rights reserved.
//

#import "ViewController.h"

#import "ViewController.h"
#import "CWStarRateView.h"

@interface ViewController ()<CWStarRateViewDelegate>

@property (strong, nonatomic) CWStarRateView *starRateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(10, 100, 150, 40) numberOfStars:5];
    self.starRateView.scorePercent = 0.6;
    self.starRateView.allowIncompleteStar = NO;
    self.starRateView.hasAnimation = YES;
    self.starRateView.delegate = self;
    [self.view addSubview:self.starRateView];
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent {
    NSLog(@"%f",newScorePercent);
}

@end
