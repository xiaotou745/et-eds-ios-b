//
//  EDSTodaysOrdersVC.m
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTodaysOrdersVC.h"

@interface EDSTodaysOrdersVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EDSTodaysOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"今日订单";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    /*
     UIWebViewNavigationTypeLinkClicked,
     UIWebViewNavigationTypeFormSubmitted,
     UIWebViewNavigationTypeBackForward,
     UIWebViewNavigationTypeReload,
     UIWebViewNavigationTypeFormResubmitted,
     UIWebViewNavigationTypeOther
     */
    NSLog(@"UIWebViewNavigationType:%ld",navigationType);
    NSString * URLString = request.URL.absoluteString;
    NSLog(@"%@",URLString);

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
    }
    
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSLog(@"%@\n%@",currentURL,title);
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)back{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
