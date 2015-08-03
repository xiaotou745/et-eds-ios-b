//
//  BankViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/9.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BankViewController.h"
#import "BankTableViewCell.h"
#import "GYBankCardFormatTextField.h"
#import "QRadioButton.h"
#import "FHQNetWorkingAPI.h"
#import "SelectBankPicker.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "AddressPickerView.h"

@interface BankViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, QRadioButtonDelegate, SelectBankPickerDelegate, AddressPickerViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_titles;
    NSMutableArray *_textFields;
    
    UITextField *_subBankTF;
    UITextField *_cardTF;
    UITextField *_cardReatTF;
    UITextField *_userNameTF;
    
    UITextField *_cardIdTF;     /**< 身份证号 */
    UITextField *_companyIdTF;  /**< 营业执照号 */
    
    QRadioButton *_personRadio;
    QRadioButton *_companyRadio;
    
    UILabel *_addressLabel;
    
    UIView *_bankAlertView;
    UIView *_subBankAlertView;
    
    NSMutableArray *_bankList;
    UILabel *_backNameLabel;
    
    SelectBankPicker *_selectPicker;
    AddressPickerView *_addressPicker;
}
@end

@implementation BankViewController

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
    
    NSDictionary *requsetData = @{@"Version" : @"1.0"};
    
    MBProgressHUD *HUD ;
    if (_bankList.count == 0) {
        HUD = [Tools showProgressWithTitle:@""];
    }
    [FHQNetWorkingAPI getBankList:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        _bankList = result;
        [_selectPicker loadData:result];
        [_selectPicker setSelectBank:_bank.openBank];
        [self saveBankList];
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
        if (_bankList.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } isShowError:NO];
    
}

- (void)initializeData {
    _titles = [NSMutableArray arrayWithObjects:@"", @"开户行", @"开户行支行", @"身份证号", @"卡号", @"确认卡号", @"账户名", nil];
    _textFields = [NSMutableArray array];
    [self getBankListFromCache];

}

- (void)bulidView {
    
    self.titleLabel.text = @"提款账户";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];

    _backNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 95 - 10, 55)];
    _backNameLabel.textColor = DeepGrey;
    _backNameLabel.text = @"交通银行";
    _backNameLabel.userInteractionEnabled = YES;
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 95 - 10, 55)];
    _addressLabel.textColor = DeepGrey;
    _addressLabel.text = @"请选择开户省市";
    _addressLabel.userInteractionEnabled = YES;
    
    _subBankTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 105 - 10, 55)];
    _subBankTF.textColor = DeepGrey;
    _subBankTF.delegate = self;
    _subBankTF.clearButtonMode = UITextFieldViewModeAlways;
    _subBankTF.placeholder = @"请输入开户行支行";
    _subBankTF.font = [UIFont systemFontOfSize:NormalFontSize];
    
    _cardIdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 105 - 10, 55)];
    _cardIdTF.textColor = DeepGrey;
    _cardIdTF.delegate = self;
    _cardIdTF.clearButtonMode = UITextFieldViewModeAlways;
    _cardIdTF.placeholder = @"请输入身份证号";
    _cardIdTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _cardIdTF.font = [UIFont systemFontOfSize:NormalFontSize];
    
    _companyIdTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 105 - 10, 55)];
    _companyIdTF.textColor = DeepGrey;
    _companyIdTF.delegate = self;
    _companyIdTF.clearButtonMode = UITextFieldViewModeAlways;
    _companyIdTF.placeholder = @"请输入营业执照号";
    _companyIdTF.keyboardType = UIKeyboardTypeNumberPad;
    _companyIdTF.font = [UIFont systemFontOfSize:NormalFontSize];
    
    _cardTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 105 - 10, 55)];
    _cardTF.textColor = DeepGrey;
    _cardTF.keyboardType = UIKeyboardTypeNumberPad;
    _cardTF.clearButtonMode = UITextFieldViewModeAlways;
    _cardTF.placeholder = @"请输入银行卡号";
    _cardTF.font = [UIFont systemFontOfSize:NormalFontSize];
    
    _cardReatTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 105 - 10, 55)];
    _cardReatTF.textColor = DeepGrey;
    _cardReatTF.keyboardType = UIKeyboardTypeNumberPad;
    _cardReatTF.clearButtonMode = UITextFieldViewModeAlways;
    _cardReatTF.placeholder = @"请重新输入银行卡号";
    _cardReatTF.font = [UIFont systemFontOfSize:NormalFontSize];
    
    _userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 105 - 10, 55)];
    _userNameTF.textColor = DeepGrey;
    _userNameTF.delegate = self;
    _userNameTF.placeholder = @"请输入账户名";
    _userNameTF.clearButtonMode = UITextFieldViewModeAlways;
    _userNameTF.font = [UIFont systemFontOfSize:NormalFontSize];
    
    [_textFields setArray:@[@"", @"", _subBankTF, _cardIdTF, _cardTF, _cardReatTF, _userNameTF]];
    
    _personRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"bankType"];
    _personRadio.frame = CGRectMake(10, 0, 150, 55);
    [_personRadio setTitle:@"个人账户" forState:UIControlStateNormal];
    [_personRadio setTitleColor:DeepGrey forState:UIControlStateNormal];
    _personRadio.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _personRadio.checked = YES;
    
    _companyRadio = [[QRadioButton alloc] initWithDelegate:self groupId:@"bankType"];
    _companyRadio.frame = CGRectMake(CGRectGetMaxX(_personRadio.frame), 0, 150, 55);
    [_companyRadio setTitle:@"公司账户" forState:UIControlStateNormal];
    [_companyRadio setTitleColor:DeepGrey forState:UIControlStateNormal];
    _companyRadio.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 100)];
    _tableView.tableFooterView = bottomView;
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submit setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [submit setTitle:@"保存" forState:UIControlStateNormal];
    submit.frame = CGRectMake(10, 30, MainWidth - 20, 44);
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submit];
    
    _selectPicker = [[SelectBankPicker alloc] initWithFrame:CGRectMake(0, ScreenHeight - 162 - 45, MainWidth, 0)];
    [_selectPicker loadData:_bankList];
    _selectPicker.delegate = self;
    
    _addressPicker = [[AddressPickerView alloc] initWithFrame:CGRectZero withAddressType:AddressTypeBank];
    _addressPicker.delegate = self;
    
    if (_bank) {
        if (_bank.BelongType == AccountTypeCompany) {
            _companyRadio.checked = YES;
        }
        
        _userNameTF.text = _bank.bankUserName;
        _cardTF.text = _bank.bankCardNumber;
        _cardReatTF.text = _bank.bankCardNumber;
        _subBankTF.text = _bank.openSubBank;
        _backNameLabel.text = _bank.openBank;
        if (_bank.BelongType == AccountTypePerson) {
            _cardIdTF.text = _bank.cardId;
        } else {
            _companyIdTF.text = _bank.cardId;
        }
        if (isCanUseString(_bank.province) && isCanUseString(_bank.city)) {
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@",_bank.province, _bank.city];
        }
        
        [_selectPicker setSelectBank:_bank.openBank];
        
        if (isCanUseString(_bank.province) && isCanUseString(_bank.city)) {
            [_addressPicker setSelectProvince:_bank.province];
            [_addressPicker setSelectCity:_bank.city];
        }

    } else {
        _bank = [[BankModel alloc] init];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    
    if (section == 2) {
        return 40;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        
        if (!_bankAlertView) {
            _bankAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 40)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, MainWidth - 105 - 10, 40)];
            label.text = @"推荐使用交通银行卡，到账更快";
            label.textColor = RedDefault;
            label.font = [UIFont systemFontOfSize:SmallFontSize];
            [_bankAlertView addSubview:label];
        }
    
        return _bankAlertView;
    }
    
    if (section == 2) {
        if (!_subBankAlertView) {
            _subBankAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 40)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(115, 0, MainWidth - 105 - 10, 40)];
            label.text = @"如：交通银行北京市分行建国路支行";
            label.textColor = RedDefault;
            label.font = [UIFont systemFontOfSize:SmallFontSize];
            [_subBankAlertView addSubview:label];
        }
        
        return _subBankAlertView;
    }
    
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = (NSString*)_titles[indexPath.section];
    BankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[BankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.titleLabel.text = _titles[indexPath.section];
        
        UITextField *textField = [_textFields objectAtIndex:indexPath.section];
        if ([textField isKindOfClass:[UITextField class]]) {
            [cell.rightView addSubview:textField];
        }
        
        if (indexPath.section == 0) {
            
            [cell.contentView addSubview:_personRadio];
            
            [cell.contentView addSubview:_companyRadio];
            
            if (_bank) {
                if (_bank.BelongType == AccountTypeCompany) {
                    _companyRadio.checked = YES;
                }
            }
            
        }
        
        //选择银行
        if (indexPath.section == 1) {

            [cell.rightView addSubview:_backNameLabel];
            
            UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth - 40, 0, 20, 55)];
            indicator.image = [UIImage imageNamed:@"down_icon"];
            indicator.contentMode = UIViewContentModeCenter;
            [cell addSubview:indicator];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBank)];
            [_backNameLabel addGestureRecognizer:tap];
            
        }
        
        if ( indexPath.section == 3) {
            [cell addSubview:_addressLabel];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAddress)];
            [_addressLabel addGestureRecognizer:tap];
        }
        
    }
    return cell;
}

- (void)selectBank {
    [_selectPicker showInView:self.view];
    NSLog(@"选择银行");
}

- (void)selectAddress {
    [Tools hiddenKeyboard];
    [_addressPicker showInView:self.view];
    NSLog(@"选择地址");
}

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {

    if (_personRadio.checked) {
        _titles = [NSMutableArray arrayWithObjects:@"", @"开户行", @"开户行支行", @"", @"身份证号", @"卡号", @"确认卡号", @"账户名", nil];
        [_textFields setArray:@[@"", @"", _subBankTF, @"", _cardIdTF, _cardTF, _cardReatTF, _userNameTF]];
    } else {
        _titles = [NSMutableArray arrayWithObjects:@"", @"开户行", @"开户行支行", @"", @"营业执照号", @"卡号", @"确认卡号", @"账户名", nil];
        [_textFields setArray:@[@"", @"", _subBankTF, @"", _companyIdTF, _cardTF, _cardReatTF, _userNameTF]];
    }
    
    [_tableView reloadData];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)chechData {
    if (_backNameLabel.text.length == 0) {
        [Tools showHUD:@"请选择银行"];
        return NO;
    }
    
    if (_subBankTF.text.length == 0) {
        [Tools showHUD:@"请填写开户行支行"];
        return NO;
    }
    
    if (_subBankTF.text.length < 3) {
        [Tools showHUD:@"开户行支行地址不少于3个字符"];
        return NO;
    }
    
    if (_personRadio.checked && _cardIdTF.text.length == 0) {
        [Tools showHUD:@"请填写身份证号"];
        return NO;
    }
    
    if (_personRadio.checked && ![_cardIdTF.text validateIDCardNumber]) {
        [Tools showHUD:@"请填写正确的身份证号"];
        return NO;
    }

    if (_companyRadio.checked && _companyIdTF.text.length == 0) {
        [Tools showHUD:@"请填写营业执照号"];
        return NO;
    }
    
    if (_companyRadio.checked && _companyIdTF.text.length != 15) {
        [Tools showHUD:@"请正确填写15位有效营业执照号码"];
        return NO;
    }
    
    if (_bank.province.length == 0 || _bank.city.length == 0) {
        [Tools showHUD:@"请选择开户地址"];
        return NO;
    }
    
    if (_cardTF.text.length == 0 || _cardReatTF.text.length == 0) {
        [Tools showHUD:@"银行卡号不能为空"];
        return NO;
    }
    
    if (_cardTF.text.length < 16 || _cardTF.text.length > 19) {
        [Tools showHUD:@"请输入正确的银行卡号"];
        return NO;
    }
    
    if (![_cardReatTF.text isEqualToString:_cardTF.text]) {
        [Tools showHUD:@"两次输入的银行卡号不一致"];
        return NO;
    }
    
    if (_userNameTF.text.length == 0) {
        [Tools showHUD:@"持卡人姓名不能为空"];
        return NO;
    }
    
    return YES;
}

- (void)submit {
    
    if (![self chechData]) {
        return;
    }
    NSDictionary *bank = [_bankList objectAtIndex:[_selectPicker.picker selectedRowInComponent:0]];
    NSLog(@"%@",bank);
    NSDictionary *requestData = @{@"BusinessId"     : [UserInfo getUserId],
                                  @"id"             : _bank.binkId ? _bank.binkId : @"",
                                  @"TrueName"       : _userNameTF.text,
                                  @"AccountNo"      : _cardReatTF.text,
                                  @"AccountNo2"     : _cardReatTF.text,
                                  @"AccountType"    : @(1),
                                  @"BelongType"     : _companyRadio.checked ? @(1): @(0),
                                  @"OpenBank"       : _backNameLabel.text,
                                  @"OpenSubBank"    : _subBankTF.text,
                                  @"CreateBy"       : [UserInfo getBussinessName],
                                  @"UpdateBy"       : [UserInfo getBussinessName],
                                  @"OpenProvince"   : _bank.province,
                                  @"OpenProvinceCode" : @(_bank.provinceCode),
                                  @"OpenCityCode"     : @(_bank.cityCode),
                                  @"OpenCity"       : _bank.city,
                                  @"IDCard"         : _personRadio.checked ? _cardIdTF.text : _companyIdTF.text,
                                  @"Version"        : APIVersion};
    
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    BOOL isBind = _bank.bankUserName ? NO : YES;
    [FHQNetWorkingAPI bindingBank:requestData isBind:isBind successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        [self.navigationController popViewControllerAnimated:YES];
        [Tools hiddenProgress:HUD];
        if (isBind) {
            [Tools showHUD:@"绑定成功"];
        } else  {
            [Tools showHUD:@"修改绑定银行卡成功"];
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
    
    
}

#pragma mark 选择银行代理
- (void)selectBankPickerSelect:(SelectBankPicker *)selecterPicker {
    NSString *bank = [[_bankList objectAtIndex:[selecterPicker.picker selectedRowInComponent:0]] getStringWithKey:@"Name"];
    _backNameLabel.text = bank;
}

- (void)addressPickerViewSelected:(AddressPickerView *)addressPicker {
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@",addressPicker.provinceOrigin.name, addressPicker.cityOrigin.name];
    _bank.province = addressPicker.provinceOrigin.name;
    _bank.provinceCode = addressPicker.provinceOrigin.idCode;
    _bank.city = addressPicker.cityOrigin.name;
    _bank.cityCode = addressPicker.cityOrigin.idCode;
}


#pragma mark 键盘相关处理
- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_tableView changeFrameHeight:ScreenHeight - keyboardRect.size.height - 64];
                         UIView *firstResponder = [Tools findFirstResponderFromView:_tableView];
                         CGRect rect = [_tableView convertRect:firstResponder.frame fromView:firstResponder];
                         [_tableView scrollRectToVisible:CGRectInset(rect, 0, -20) animated:YES];
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_tableView changeFrameHeight:ScreenHeight - 64 ];
                     }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)saveBankList {
    if (_bankList.count == 0) {
        return;
    }
    //获取路径和保存文件
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BankList"];
    [NSKeyedArchiver archiveRootObject:_bankList toFile:filename];
}

- (void)getBankListFromCache {
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BankList"];
    _bankList = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    if (!_bankList) {
        _bankList = [NSMutableArray array];
    }
}


@end
