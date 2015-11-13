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


@interface EDSTodaysOrdersVC ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@property WebViewJavascriptBridge* bridge;


@end

static  NSString  * todayOrderURL = @"http://10.8.7.253:8091/business/orderregion/todayone?businessid=2125#";

@implementation EDSTodaysOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"今日订单";
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:todayOrderURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];

    [self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(tlirvc) forControlEvents:UIControlEventTouchUpInside];
    
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //    TestJSObject *todayOrder=[TestJSObject new];
    //    context[@"orderList"]=todayOrder;
    
    context[@"orderList"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
        }
    };
    
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

    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //iOS调用js
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）

    
    
//    [WebViewJavascriptBridge enableLogging];
//
//    
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC received message from JS: %@", data);
//        responseCallback(@"Response for message from ObjC");
//    }];
//    
    
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
