//
//  AboutViewController.m
//  ESend
//
//  Created by 永来 付 on 15/7/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *_activity;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidView {
    
    self.titleLabel.text = @"关于E代送";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64)];
    NSURLRequest *requset = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://m.edaisong.com.cn/htmls/ios/about.html"]];
    [webView loadRequest:requset];
    [self.view addSubview:webView];
    
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(MainWidth/2, 100, 0, 0)];
    _activity.hidesWhenStopped = YES;
    [_activity startAnimating];
    [webView addSubview:_activity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activity stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_activity stopAnimating];
}

@end
