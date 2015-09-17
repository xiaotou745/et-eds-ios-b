//
//  LoginViewController.m
//  ESend
//
//  Created by 永来 付 on 15/5/28.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "LoginViewController.h"
#import "LoadingButtton.h"
#import "FHQNetWorkingAPI.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "NSString+encrypto.h"
#import "UserInfo.h"

@interface LoginViewController ()<UITextFieldDelegate, UINavigationControllerDelegate>
{
    UITextField *_usernameTF;
    UITextField *_passwordTF;
    
    LoadingButtton *_submitBtn;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)bulidView {
    
    self.titleLabel.text = @"E代送商户登录";
    self.leftBtn.hidden = YES;
 
    _usernameTF = [[self class] createIconTextFieldWithIcon:@"phone_icon" placholder:@"手机号码"];
    _usernameTF.delegate = self;
    _usernameTF.keyboardType = UIKeyboardTypePhonePad;
    _usernameTF.text = @"";
    [self.view addSubview:_usernameTF];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(0, CGRectGetMaxY(_usernameTF.frame), MainWidth, 0.5);
    [self.view addSubview:line];
    
    _passwordTF = [[self class] createIconTextFieldWithIcon:@"password_icon" placholder:@"登录密码"];
    _passwordTF.frame = CGRectMake(0, CGRectGetMaxY(line.frame), MainWidth, 55);
    _passwordTF.delegate = self;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.text = @"";
    [self.view addSubview:_passwordTF];
 
    _submitBtn = [LoadingButtton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [_submitBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    _submitBtn.frame = CGRectMake(10, CGRectGetMaxY(_passwordTF.frame) + 30, MainWidth - 20, 44);
    [self.view addSubview:_submitBtn];
    
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_submitBtn.frame) + 15, 80, 20)];
    registerLabel.text = @"快速注册";
    registerLabel.textColor = BlueColor;
    registerLabel.userInteractionEnabled = YES;
    registerLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [self.view addSubview:registerLabel];
    
    UITapGestureRecognizer *tapReister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerUser)];
    [registerLabel addGestureRecognizer:tapReister];
    
    
    UILabel *forgetPassword = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 70 - 10, CGRectGetMaxY(_submitBtn.frame) + 15, 70, 20)];
    forgetPassword.textAlignment = NSTextAlignmentRight;
    forgetPassword.text = @"忘记密码";
    forgetPassword.textColor = DeepGrey;
    forgetPassword.userInteractionEnabled = YES;
    forgetPassword.font = [UIFont systemFontOfSize:NormalFontSize];
    [self.view addSubview:forgetPassword];
    
    UITapGestureRecognizer *tapForget = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPassword)];
    [forgetPassword addGestureRecognizer:tapForget];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}

- (void)login {
    
    if (_passwordTF.text.length == 0) {
        [Tools showHUD:@"请填写手机号码！"];
        return;
    }
    
    if (_usernameTF.text.length != 11) {
        [Tools showHUD:@"请填写正确的手机号码！"];
        return;
    }
    
    if (_passwordTF.text.length == 0) {
        [Tools showHUD:@"请填写密码！"];
        return;
    }
    
    
    NSDictionary *requestData = @{@"phoneNo"    : _usernameTF.text,
                                  @"passWord"   :[_passwordTF.text ETSMD5],//@"36B8653D62598A052A7B0CDCA1C3DCDD"//
                                  @"ssid"       : [UserInfo getUUID],
//                                  @"OperSystem": @"iOS",
//                                  @"OperSystemModel":@"8.4",
//                                  @"PhoneType":@"Apple",
//                                  @"AppVersion":@"1.0.4",
                                  };

    NSString * jsonString2 = [Security JsonStringWithDictionary:requestData];
    
    NSString * aesString = [Security AesEncrypt:jsonString2];
    
    NSDictionary * requestData2 = @{
                    @"data":aesString,
                    @"Version":[Tools getApplicationVersion],
                    };
    
    [_submitBtn starLoadding];
    [FHQNetWorkingAPI login:requestData2 successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        [Tools hiddenKeyboard];
        [UserInfo saveUserInfo:result];
        if (isCanUseObj(result[@"Appkey"])) {
            [UserInfo saveAppkey:result[@"Appkey"]];
        }
        if (isCanUseObj(result[@"Token"])) {
            [UserInfo saveToken:result[@"Token"]];
        }
        [_submitBtn stopLoadding];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [_submitBtn stopLoadding];
    }];
}

- (void)registerUser {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)forgetPassword {
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
    vc.isChangePassword = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

+ (UITextField*)createIconTextFieldWithIcon:(NSString*)imageName placholder:(NSString*)placeholder {
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + 10, MainWidth, 55)];
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

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
