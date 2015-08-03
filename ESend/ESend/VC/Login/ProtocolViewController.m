//
//  ProtocolViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/29.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()
{

}
@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidView {
    
    self.titleLabel.text = @"E代送商户注册协议";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64)];
    [self.view addSubview:scrollView];
    
    NSString *protoclPath = [[NSBundle mainBundle] pathForResource:@"Protocol" ofType:@"txt"];
    NSError *error;
    
    NSString *textFileContents = [NSString stringWithContentsOfFile:protoclPath encoding:NSUTF8StringEncoding error: & error];
    NSLog(@"%@",textFileContents);
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, MainWidth - 20, 100)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = textFileContents;
    contentLabel.textColor = DeepGrey;
    [scrollView addSubview:contentLabel];
    
    contentLabel.frame = [Tools labelForString:contentLabel];
    scrollView.contentSize = CGSizeMake(MainWidth, FRAME_HEIGHT(contentLabel) + 50);

}

@end
