//
//  EDSTodaysOrdersVC.m
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTodaysOrdersVC.h"
#import "EDSTaskListInRegionVC.h"

@interface EDSTodaysOrdersVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

static  NSString  * todayOrderURL = @"http://bj.eds.com/orderregion/todayone?businessid=2125";

@implementation EDSTodaysOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"今日订单";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:todayOrderURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];

    [self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(tlirvc) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tlirvc{
    EDSTaskListInRegionVC * tlir = [[EDSTaskListInRegionVC alloc] initWithNibName:NSStringFromClass([EDSTaskListInRegionVC class]) bundle:nil];
    tlir.selectedStatus = OrderStatusAccepted;
    /*
     if (_selectedStatus == OrderStatusAccepted) {
     }else if (_selectedStatus == OrderStatusReceive) {
     }else if (_selectedStatus == OrderStatusComplete) {
     }
     */
    tlir.TLIR_Title = @"2222";
    [self.navigationController pushViewController:tlir animated:YES];
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
