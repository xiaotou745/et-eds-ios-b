//
//  EDSBusinessShouldKnow.m
//  ESend
//
//  Created by 台源洪 on 15/9/22.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBusinessShouldKnow.h"

#define BusinessShouldKnowURL @"http://m.edaisong.com/htmls/rule.html"

@interface EDSBusinessShouldKnow ()<UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
}

@property (strong, nonatomic) IBOutlet UIWebView *BS_businessShouldKnow;

@end

@implementation EDSBusinessShouldKnow

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"价格表";
    
    [self.BS_businessShouldKnow loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:BusinessShouldKnowURL]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (_HUD) {
        [Tools hiddenProgress:_HUD];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    _HUD = [Tools showProgressWithTitle:@""];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_HUD) {
        [Tools hiddenProgress:_HUD];
    }
}

@end
