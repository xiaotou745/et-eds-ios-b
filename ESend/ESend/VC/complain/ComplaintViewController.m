//
//  ComplaintViewController.m
//  ESend
//
//  Created by Maxwell on 15/8/18.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ComplaintViewController.h"
#import "FHQNetWorkingAPI.h"

#define ComplaintAlertMsg @"投诉内容5~50字内"

@interface ComplaintViewController ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *complaintLbl;
@property (strong, nonatomic) IBOutlet UITextView *complaintTextView;

@end

@implementation ComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"投诉";
    
    self.complaintLbl.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.complaintTextView.layer.borderColor = [[UIColor colorWithHexString:@"e8e8e8"] CGColor];
    self.complaintTextView.layer.borderWidth = 1;
    
    [self.complaintTextView becomeFirstResponder];
    
    //_rightBtn.frame = CGRectMake(MainWidth - 60, OffsetBarHeight, 60, 44);

    [self.rightBtn setFrame:CGRectMake(MainWidth - 12 - 75, OffsetBarHeight + 6, 75, 32)];
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"blue_btn_noSelect"];
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 3;
    [self.rightBtn addTarget:self action:@selector(complaintAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    
    if (self.complaintTextView == textView) {
        // ErrorMsgMax50PhoneLength
        if ([toBeString length] > 50 ) {
            textView.text = [toBeString substringToIndex:50];
//            [self postAlertWithMsg:ErrorMsgMax11PhoneLength];
            [Tools showHUD:ComplaintAlertMsg];
            return NO;
        }
    }
    return YES;
}

- (void)complaintAction{
    
    NSString *validateLength=[[self.complaintTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    
    if ([@"" isEqualToString:validateLength]) {
        [Tools showHUD:@"请输入投诉内容"];
        self.complaintTextView.text=@"";
        return;
    }
    
    if (validateLength.length<5||validateLength.length>50) {
        [Tools showHUD:@"请输入5-50个汉字或字符"];
        // self.SCCTextView.text=@"";
        return;
    }
    
    [self.complaintTextView resignFirstResponder];
    long cid = self.orderModel.ClienterId;
    long bid = self.orderModel.businessId;
    NSString * orderId = self.orderModel.orderId;
    NSString * OrderNo = self.orderModel.orderNumber;
    NSString * Reason = self.complaintTextView.text;
    //NSLog(@"%ld,%ld,%@,%@,%@",cid,bid,orderId,OrderNo,Reason);
    
    if (Reason.length < 5 || Reason.length > 50) {
        [Tools showHUD:ComplaintAlertMsg];
        return;
    }
    
    NSDictionary * paraDict = @{
                                @"ComplainId":[NSNumber numberWithLong:bid],
                                @"ComplainedId":[NSNumber numberWithLong:cid],
                                @"OrderId":orderId,
                                @"OrderNo":OrderNo,
                                @"Reason":Reason,
                                };
    MBProgressHUD * hud = [Tools showProgressWithTitle:nil];
    
    [FHQNetWorkingAPI businessComplainClienter:paraDict successBlock:^(id result, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:hud];
        [self complaintSuccessAction];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:hud];
        [Tools showHUD:@"请求超时"];
    }];
}


- (void)complaintSuccessAction{
    [Tools showHUD:@"您的反馈已发送，我们会尽快核实处理"];
    self.callBackBlock();
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
}

@end
