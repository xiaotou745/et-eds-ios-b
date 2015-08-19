//
//  RegisterViewController.m
//  ESend
//
//  Created by 永来 付 on 15/5/29.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoadingButtton.h"
#import "FHQNetWorkingAPI.h"
#import "PrefectInfoViewController.h"
#import "UserInfo.h"
#import "NSString+encrypto.h"
#import "ProtocolViewController.h"
#import "NSString+evaluatePhoneNumber.h"

@interface RegisterViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *_usernameTF;
    UITextField *_veriftyTF;
    UITextField *_passwordTF;
    LoadingButtton *_submitBtn;
    UIButton *_getVeriftyBtn;
    UILabel *_agreementLabel;
    UIView *_line;
    UILabel *_phoneVeriftyLabel;
    
    UIScrollView *_scrollView;
    
    dispatch_source_t _timer;
}


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)bulidView {
    
    self.titleLabel.text = @"商户注册";
    
    [self.rightBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64)];
    [self.view addSubview:_scrollView];
    
    _usernameTF = [[self class] createIconTextFieldWithIcon:@"phone_icon" placholder:@"手机号码"];
    _usernameTF.delegate = self;
    _usernameTF.keyboardType = UIKeyboardTypePhonePad;
    _usernameTF.text = @"";
    _usernameTF.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _usernameTF.rightViewMode = UITextFieldViewModeAlways;
    [_scrollView addSubview:_usernameTF];
    
    _phoneVeriftyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_usernameTF.frame), MainWidth, 40)];
    _phoneVeriftyLabel.textAlignment = NSTextAlignmentCenter;
    NSString *verifyStr = @"收不到短信？使用语音验证";
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:verifyStr];
    [mstr addAttributes:@{NSForegroundColorAttributeName : DeepGrey,
                                    NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize]}
                  range:NSMakeRange(0, verifyStr.length)];
    [mstr addAttributes:@{NSForegroundColorAttributeName : BlueColor,
                          NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize]}
                  range:NSMakeRange(6, 6)];
    _phoneVeriftyLabel.attributedText = mstr;
    _phoneVeriftyLabel.hidden = YES;
    _phoneVeriftyLabel.userInteractionEnabled = YES;
    [_scrollView addSubview:_phoneVeriftyLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAudioCode)];
    [_phoneVeriftyLabel addGestureRecognizer:tap];
    
    _getVeriftyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getVeriftyBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    [_getVeriftyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_getVeriftyBtn setTitleColor:BlueColor forState:UIControlStateDisabled];
    _getVeriftyBtn.frame = CGRectMake(MainWidth - 100, FRAME_Y(_usernameTF) + 5, 90, 45);
    _getVeriftyBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_getVeriftyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVeriftyBtn.titleLabel.textColor = BlueColor;
    [_getVeriftyBtn setBackgroundSmallImageNor:@"gray_border_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"gray_border_btn_nor"];
    _getVeriftyBtn.enabled  = YES;
    [_getVeriftyBtn addTarget:self action:@selector(getVerfityCode) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_getVeriftyBtn];
    
    _line = [Tools createLine];
    _line.frame = CGRectMake(0, CGRectGetMaxY(_usernameTF.frame), MainWidth, 0.5);
    [_scrollView addSubview:_line];
    
    _veriftyTF = [[self class] createIconTextFieldWithIcon:@"verifty_icon" placholder:@"验证码"];
    _veriftyTF.frame = CGRectMake(0, CGRectGetMaxY(_line.frame), MainWidth, 55);
    _veriftyTF.delegate = self;
    _veriftyTF.returnKeyType = UIReturnKeyDone;
    _veriftyTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _veriftyTF.text = @"";
    [_scrollView addSubview:_veriftyTF];
    
    _passwordTF = [[self class] createIconTextFieldWithIcon:@"password_icon" placholder:@"设置密码"];
    _passwordTF.frame = CGRectMake(0, CGRectGetMaxY(_veriftyTF.frame) + 20, MainWidth, 55);
    _passwordTF.delegate = self;
    _passwordTF.secureTextEntry = YES;
    [_scrollView addSubview:_passwordTF];
    
    _submitBtn = [LoadingButtton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [_submitBtn setTitle:@"确认注册" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.frame = CGRectMake(10, CGRectGetMaxY(_passwordTF.frame) + 30, MainWidth - 20, 44);
    [_scrollView addSubview:_submitBtn];
    
    _agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_submitBtn.frame) + 20, MainWidth, 20)];
    NSString *str = @"确认注册表示已同意E代送商家服务协议";
    NSMutableAttributedString *mustr = [[NSMutableAttributedString alloc] initWithString:str];
    [mustr addAttributes:@{NSForegroundColorAttributeName : DeepGrey,
                           NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize]
                           }
                   range:NSMakeRange(0, str.length)];
    [mustr addAttributes:@{NSForegroundColorAttributeName : BlueColor}
                   range:NSMakeRange(9, 9)];
    _agreementLabel.textAlignment = NSTextAlignmentCenter;
    _agreementLabel.attributedText = mustr;
    [_scrollView addSubview:_agreementLabel];
    
    UITapGestureRecognizer *tapProtocol = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProtocol)];
    _agreementLabel.userInteractionEnabled = YES;
    [_agreementLabel addGestureRecognizer:tapProtocol];
    
    _scrollView.contentSize = CGSizeMake(MainWidth, CGRectGetMaxY(_agreementLabel.frame) + 20);
}

- (void)refreshOrigin {
    
    _phoneVeriftyLabel.hidden = NO;
    
    [_veriftyTF changeFrameOriginY:CGRectGetMaxY((_phoneVeriftyLabel.frame))];
    _passwordTF.frame = CGRectMake(0, CGRectGetMaxY(_veriftyTF.frame) + 20, MainWidth, 55);
     _submitBtn.frame = CGRectMake(10, CGRectGetMaxY(_passwordTF.frame) + 30, MainWidth - 20, 44);
    [_agreementLabel changeViewCenterY:CGRectGetMaxY(_submitBtn.frame) + 30];
    _scrollView.contentSize = CGSizeMake(MainWidth, CGRectGetMaxY(_agreementLabel.frame) + 20);
    
    
}
- (void)registerUser {
    

//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    if (![self checkPhone]) {
        return;
    }
    
    if (_veriftyTF.text.length == 0) {
        [Tools showHUD:@"请填写验证码!"];
        [_veriftyTF becomeFirstResponder];
        return;
    }
    
    if (![_veriftyTF.text isRightVerifyFormat]) {
        [Tools showHUD:@"请填写正确的验证码!"];
        [_veriftyTF becomeFirstResponder];
        return;
    }
    
    if (_passwordTF.text.length == 0) {
        [Tools showHUD:@"请输入密码！"];
        [_passwordTF becomeFirstResponder];
        return;
    }
    
    if (_passwordTF.text.length < 6) {
        [Tools showHUD:@"请输入6-16位数字或字母"];
        [_passwordTF becomeFirstResponder];
        return;
    }
    
    if (_passwordTF.text.length > 16) {
        [Tools showHUD:@"请输入6-16位数字或字母"];
        [_passwordTF becomeFirstResponder];
        return;
    }
    
    NSDictionary *request = @{@"phoneNo"    : _usernameTF.text,
                              @"verifyCode" : _veriftyTF.text,
                              @"passWord"   : [_passwordTF.text ETSMD5],
                              @"city"       : @"北京",
                              @"timespan"   : @([[NSDate date] timeIntervalSince1970]),
                              @"ssid"       : [UserInfo getUUID],
                              };
    NSString * jsonString2 = [request JSONString];
    
    NSString * aesString = [Security AesEncrypt:jsonString2];
    
    NSDictionary * requestData2 = @{
                                    @"data":aesString,
                                    @"Version":[Tools getApplicationVersion],
                                    };
    [_submitBtn starLoadding];
    [FHQNetWorkingAPI registerAccount:requestData2 successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        [_submitBtn stopLoadding];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [_submitBtn stopLoadding];
        
        if (error.code == 0) {
            NSLog(@"%@",error.userInfo);
            [UserInfo saveUserInfo:@{@"userId"  : [[error.userInfo objectForKey:@"Result"] getStringWithKey:@"userId"],
                                     @"phoneNo" : _usernameTF.text}];
            
            PrefectInfoViewController *vc = [[PrefectInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == _passwordTF) {
        if ([string isEqualToString:@" "]) {
            return NO;
        }
        return YES;
    }
    
    return YES;
}

- (void)getVerfityCode {
    
    if (![self checkPhone]) {
        return;
    }
    
    NSDictionary *requsetData = @{@"PhoneNumber" : _usernameTF.text};
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI phoneNumberCode:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
        [Tools hiddenProgress:HUD];
        
        if ([error.userInfo getIntegerWithKey:@"Status"] == 0) {
            [_veriftyTF becomeFirstResponder];
            
            [self performSelector:@selector(refreshOrigin) withObject:nil afterDelay:5];
            
            if (!_timer) {
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            }
            __block int i = 60;
            __weak typeof(_getVeriftyBtn) weakBtn = _getVeriftyBtn;
            dispatch_source_set_event_handler(_timer, ^{
                if (i == 0) {
                    dispatch_suspend(_timer);
                    [weakBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
                    weakBtn.enabled = YES;
                    i = 60;
                    return ;
                }
                [weakBtn setTitle:[NSString stringWithFormat:@"已发送(%d)",i] forState:UIControlStateNormal];
                weakBtn.enabled = NO;
                i--;
            });
            dispatch_resume(_timer);
            return ;
        }
        
        
        
        [_usernameTF becomeFirstResponder];
    }];
    
}

- (void)tapAudioCode {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"4000-999-177将拨打您的手机，为您播报语言验证码" delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        
        if (![self checkPhone]) {
            return;
        }
        
        NSDictionary *requsetData = @{@"PhoneNumber"    : _usernameTF.text,
                                      @"Stype"          : @(0),
                                      @"Version"        : @"1.0"};
        [FHQNetWorkingAPI getAudioVerifyCode:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
            NSLog(@"%@",result);
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            
        }];
    }
}

- (BOOL)checkPhone {
    
    if (_usernameTF.text.length == 0) {
        [Tools showHUD:@"请填写手机号码"];
        [_usernameTF becomeFirstResponder];
        return NO;
    }
    
    if (_usernameTF.text.length != 11 || ![_usernameTF.text isRightPhoneNumberFormat]) {
        [Tools showHUD:@"请填写正确的手机号码"];
        [_usernameTF becomeFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark 键盘相关处理
- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_scrollView changeFrameHeight:ScreenHeight - keyboardRect.size.height - 64];
                         UIView *firstResponder = [Tools findFirstResponderFromView:_scrollView];
                         [_scrollView scrollRectToVisible:CGRectInset(firstResponder.frame, 0, -20) animated:YES];
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_scrollView changeFrameHeight:ScreenHeight - 64 ];
                     }];
}

+ (UITextField*)createIconTextFieldWithIcon:(NSString*)imageName placholder:(NSString*)placeholder {
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, MainWidth, 55)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.backgroundColor = [UIColor whiteColor];
    UIView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    leftView.frame = CGRectMake(0, 0, 35, 35);
    leftView.contentMode = UIViewContentModeCenter;
    textfield.leftView = leftView;
    textfield.placeholder = placeholder;
    textfield.font = [UIFont systemFontOfSize:BigFontSize];
    textfield.textColor = DeepGrey;
    
    return textfield;
}

- (void)showProtocol {
    ProtocolViewController *vc = [[ProtocolViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    CLog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
