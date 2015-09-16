//
//  SCFeedbackVC.m
//  SupermanC
//
//  Created by riverman on 15/9/14.
//  Copyright (c) 2015年 etaostars. All rights reserved.
//

#import "SCFeedbackVC.h"
#import "SCFBCustomView.h"
#import "ManFactory.h"
#import "UIView+Common.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "UIImage+tools.h"

#define row_0_width  50
#define row_1_width  150

NSString *scTextViewPlaceHolder_text=@"请输入产品意见，我们将不断优化体验";

@interface SCFeedbackVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *fbTableView;

@property (strong,nonatomic)UILabel *selectTypeText;
@property (strong,nonatomic)NSArray *selectTypes;
@property (assign)NSInteger selectIndex;

@property (strong,nonatomic)UITextView *scTextView;
@property (strong,nonatomic)UILabel *scTextViewPlaceHolder;

@end

@implementation SCFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    
    
}

-(void)configNavBar
{
//    [self addNavLeftButtonWithImagePath:@"leftNavBack" target:self  action:@selector(popToBack)];
//    [self addNavMiddleLabelWithText:@"意见反馈"];
//    [self addNavRightButtonWithText:@"提交" target:self action:@selector(feedBack)];
    self.titleLabel.text = @"意见反馈";
    [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setFrame:CGRectMake(ScreenWidth -10 -60, 5+20, 60, 30)];
    [self.rightBtn setBackgroundImage:[UIImage createImageWithColor:BlueColor] forState:UIControlStateNormal];
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.cornerRadius = 2;
    
    self.fbTableView.delegate=self;
    self.fbTableView.dataSource=self;
    _selectTypes=@[@"功能意见",@"页面意见",@"您的新需求",@"操作意见",@"其他"];
    _selectIndex=0;
    
}

-(void)feedBack
{

    [Tools hiddenKeyboard];
    
    NSString *validateLength=[[_scTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    
    if ([@"" isEqualToString:validateLength]) {
        [Tools showHUD:@"请输入反馈内容"];
        _scTextView.text=@"";
        return;
    }
    
    if (validateLength.length<5||validateLength.length>100) {
        [Tools showHUD:@"请输入5-100个汉字或字符"];
        // self.SCCTextView.text=@"";
        return;
    }
    
//    if (![SHInvoker networkAvailable]) {
//        [self postAlertWithMsg:kNoNetworkCanUsed];
//        
//        return;
//    }
    
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    
    NSDictionary * paraData = @{
                                @"feedbackid":[UserInfo getUserId],
                                @"feedbacktype":@(_selectIndex+1),
                                @"content":_scTextView.text,
                                };
    
    if (AES_Security) {
        NSString * jsonString2 = [paraData JSONString];
        
        NSString * aesString = [Security AesEncrypt:jsonString2];
        
        paraData = @{
                    @"data":aesString,
                    //@"Version":[Tools getApplicationVersion],
                    };
    }
    
    [FHQNetWorkingAPI feedbackB:paraData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:waitingProcess];
        
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:waitingProcess];
        if (error.code == 0) {
            NSDictionary * dict = error.userInfo;
            if (1 == [[dict objectForKey:@"status"] intValue]) {
                [Tools showHUD:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
//    [SLAppAPIClient feedBackWithFeedbacktype:_selectTypeText.text  Content:_scTextView.text  success:^(AFHTTPRequestOperation *operation,id responseObject){
//        //[Tools hiddenProgress];
//        if ([responseObject[@"status"]intValue] ==1) {
//            
//            [self postAlertWithMsg:@"您的反馈已发送，我们会尽快核实处理！"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        else
//        {
//            [self postAlertWithMsg:responseObject[@"Message"]];
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        [self hiddenProgress];
//    }];

}

#pragma mark tableView  delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)  return row_0_width;
    else                    return row_1_width;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (0  == indexPath.section) {
        
        UILabel *leftText=[ManFactory createLabelWithFrame:CGRectMake(20, 0, 100, row_0_width) Font:16 Text:@"反馈类型"];
        _selectTypeText=[ManFactory createLabelWithFrame:CGRectMake(ScreenWidth-125, 0, 90, row_0_width) Font:15 Text:_selectTypes[0]];
        _selectTypeText.textAlignment=NSTextAlignmentRight;
        _selectTypeText.textColor=[UIColor lightGrayColor];
        
        UIImageView *rightIcon=[ManFactory createImageViewWithFrame:CGRectMake(_selectTypeText.right+10, 15, 12, row_0_width-30) ImageName:@"right_indicate"];
        
        [cell addSubview:leftText];
        [cell addSubview:_selectTypeText];
        [cell addSubview:rightIcon];
    }else if (1 ==indexPath.section){
    
        _scTextView=[ManFactory createTextViewWithFrame:CGRectMake(10, 0, ScreenWidth-20, row_1_width) font:15 text:@"" editable:YES];
        _scTextView.delegate=self;
        //_scTextView.returnKeyType = UIReturnKeyGo;
        
        _scTextViewPlaceHolder=[ManFactory createLabelWithFrame:CGRectMake(5, 0, ScreenWidth, 30) Font:15 Text:scTextViewPlaceHolder_text];
        _scTextViewPlaceHolder.textColor=[UIColor lightGrayColor];
        
        [_scTextView addSubview:_scTextViewPlaceHolder];
        [cell addSubview:_scTextView];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0  == indexPath.section) {
        
        [Tools hiddenKeyboard];

//        [UIActionSheet showAcitonSheetWithTitle:@"请选择反馈类型" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:_selectTypes showInView:self.view onDismiss:^(NSInteger buttonIndex){
//            _selectTypeText.text=_selectTypes[buttonIndex];
//            
//        } onCancel:^(){}];
        
        SCFBCustomView *sccv=[[SCFBCustomView alloc]initWithWithTitle:@"请选择反馈类型" Titles:_selectTypes SelectIndex:_selectIndex onDismiss:^(NSInteger buttonIndex){
            NSLog(@"-----------%ld",buttonIndex);
            _selectTypeText.text=_selectTypes[buttonIndex];
            _selectIndex=buttonIndex;

        } onCancel:^(){}];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >0)  _scTextViewPlaceHolder.text=@"";
    else _scTextViewPlaceHolder.text=scTextViewPlaceHolder_text;
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

@end
