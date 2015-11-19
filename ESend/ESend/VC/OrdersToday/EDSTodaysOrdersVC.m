//
//  EDSTodaysOrdersVC.m
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTodaysOrdersVC.h"
#import "EDSTaskListInRegionVC.h"

#import "TestJSObject.h"
#import "WebViewJavascriptBridge.h"

#import "UserInfo.h"


@interface EDSTodaysOrdersVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property WebViewJavascriptBridge* bridge;


@end

@implementation EDSTodaysOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"今日订单";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TodayOrder_H5_SERVER,[UserInfo getUserId]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"orderList"] = ^() {
        NSArray *args = [JSContext currentArguments];
        EDSTaskListInRegionVC * tlir = [[EDSTaskListInRegionVC alloc] initWithNibName:NSStringFromClass([EDSTaskListInRegionVC class]) bundle:nil];
        tlir.businessid = [[NSString stringWithFormat:@"%@",[args objectAtIndex:0]] integerValue];
        tlir.regionid = [[NSString stringWithFormat:@"%@",[args objectAtIndex:1]] integerValue];
        tlir.selectedStatus = [[NSString stringWithFormat:@"%@",[args objectAtIndex:2]] integerValue];
        tlir.TLIR_Title = [NSString stringWithFormat:@"%@",[args objectAtIndex:3]];
        [self.navigationController pushViewController:tlir animated:YES];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
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
