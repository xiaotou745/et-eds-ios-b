//
//  ReleseOrderViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ReleseOrderViewController.h"
#import "QRadioButton.h"
#import "BaseTableViewCell.h"
#import "AddOrderTableViewCell.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import <BaiduMapAPI/BMapKit.h>
#import "JKAlertDialog.h"
#import "NSString+evaluatePhoneNumber.h"

typedef NS_ENUM(NSInteger, PayStatus) {
    PayStatusComplete,
    PayStatusUnpaid
};

@interface ReleseOrderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddOrderTableViewCellDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    UITextField *_phoneTF;
    UITextField *_address;
    
    QRadioButton *_completePayBtn;
    QRadioButton *_unpaidPayBtn;
    UIView *_payStatusView;
    
    UILabel *_orderNumberLabel;
    
    NSMutableArray *_cellViews;
    NSMutableArray *_priceTFList;
    
    UIView *_totalView;
    UIView *_remarkView;
    UITextField *_remarkTF;
    
    UIView *_addNewOrderView;
    
    CGFloat _totalAmount;
    UILabel *_totalLabel;
    
    BMKLocationService *_locService;
    CLLocationCoordinate2D _coordinate;
    
    BOOL _isFirst;
}
@end

@implementation ReleseOrderViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(priceChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
}

- (void)initializeData {
    
    _totalAmount = 0;
    
    _cellViews = [NSMutableArray array];
    _priceTFList = [NSMutableArray array];
    _isFirst = YES;
    
    [self getBusinessStatus];
}

- (void)getBusinessStatus {
    
    NSDictionary *requsetData = @{@"userId" : [UserInfo getUserId],
                                  @"version" : APIVersion};
    
    [FHQNetWorkingAPI getBusinessStatus:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",error.userInfo);
        if ([error.userInfo getIntegerWithKey:@"Status"] == 0) {
            NSDictionary *result = [error.userInfo getDictionaryWithKey:@"Result"];
            [UserInfo setIsOneKeyPubOrder:@([result getIntegerWithKey:@"OneKeyPubOrder"])];
        }
    }];
}

- (void)bulidView {
    
    self.titleLabel.text = @"发布订单";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
    
    [self createNumberTextFieldView];
    
    _phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 20, 55)];
    _phoneTF.font = [UIFont systemFontOfSize:NormalFontSize];
    _phoneTF.textColor = DeepGrey;
    _phoneTF.placeholder = @"收货人电话";
    _phoneTF.text = @"";
    _phoneTF.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _address = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 20, 55)];
    _address.textColor = DeepGrey;
    _address.font = [UIFont systemFontOfSize:NormalFontSize];
    _address.placeholder = @"收货地址";
    _address.text = @"";
    _address.clearButtonMode = UITextFieldViewModeAlways;
    _address.delegate = self;
    
    _orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 20, 55)];
    _orderNumberLabel.textColor = DeepGrey;
    _orderNumberLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    _orderNumberLabel.text = @"订单数: 1单";

    _payStatusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 54)];
    _payStatusView.backgroundColor = [UIColor whiteColor];
    
    _completePayBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"payStatus"];
    _completePayBtn.frame = CGRectMake(10, 0, 120, 55);
    [_completePayBtn setTitle:@"顾客已付款" forState:UIControlStateNormal];
    [_completePayBtn setTitleColor:DeepGrey forState:UIControlStateNormal];
    [_completePayBtn setTitleColor:BlueColor forState:UIControlStateSelected];
    _completePayBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    _completePayBtn.checked = YES;
    [_payStatusView addSubview:_completePayBtn];
    
    _unpaidPayBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"payStatus"];
    [_unpaidPayBtn setTitle:@"顾客未付款" forState:UIControlStateNormal];
    [_unpaidPayBtn setTitleColor:DeepGrey forState:UIControlStateNormal];
    [_unpaidPayBtn setTitleColor:BlueColor forState:UIControlStateSelected];
    _unpaidPayBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    _unpaidPayBtn.frame = CGRectMake(170, 0, 120, 55);
    [_payStatusView addSubview:_unpaidPayBtn];
    
    [_cellViews addObjectsFromArray:@[_phoneTF, _address, _payStatusView,_orderNumberLabel]];
    
    //创建添加新订单的界面
    _addNewOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 55)];
    _addNewOrderView.backgroundColor = [UIColor whiteColor];
    _addNewOrderView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapAddNewOrder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewOrder)];
    [_addNewOrderView addGestureRecognizer:tapAddNewOrder];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImageNor:@"add_icon" imagePre:@"" imageSelected:nil];
    addBtn.frame = CGRectMake(10, 0, 24, 55);
    addBtn.enabled = NO;
    [_addNewOrderView addSubview:addBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addBtn.frame) + 10, 0, 100, 55)];
    label.font = [UIFont systemFontOfSize:NormalFontSize];
    label.textColor = DeepGrey;
    label.text = @"添加订单";
    [_addNewOrderView addSubview:label];
    
    //总金额
    _totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 60)];
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 10, 60)];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    NSString *price = @"0.00";
    NSMutableAttributedString *mbstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单总金额:%@元",price]];
    [mbstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize],
                          NSForegroundColorAttributeName : DeepGrey
                           } range:NSMakeRange(0, mbstr.length)];
    [mbstr addAttributes:@{NSForegroundColorAttributeName : RedDefault} range:[mbstr.string rangeOfString:price]];
    _totalLabel.attributedText = mbstr;
    [_totalView addSubview:_totalLabel];
    
    //备注
    _remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 55)];
    _remarkTF.placeholder = @"备注";
    _remarkTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 55)];
    _remarkTF.leftViewMode = UITextFieldViewModeAlways;
    _remarkTF.font = [UIFont systemFontOfSize:NormalFontSize];
    _remarkTF.textColor = DeepGrey;
    _remarkTF.backgroundColor = [UIColor whiteColor];
    _remarkTF.returnKeyType = UIReturnKeyDone;
    _remarkTF.delegate = self;
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(0, 54.5, MainWidth, 0.5);
    [_remarkTF addSubview:line];
    
    //发布按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 80)];
    
    UIButton *releseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releseBtn.frame = CGRectMake(10, 20, MainWidth - 20, 44);
    [releseBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [releseBtn setTitle:@"发布任务" forState:UIControlStateNormal];
    [releseBtn addTarget:self action:@selector(releseTask) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:releseBtn];
    
    _tableView.tableFooterView = footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        return 60;
    }
    
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 55;
    }
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return _addNewOrderView;
    }
    
    if (section == 2) {
        return _remarkTF;
    }
    
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _cellViews.count;
    }
    
    if (section == 1) {
        return _priceTFList.count;
    }
    
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *cellId = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    if (indexPath.section == 0) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        [cell addSubview:_cellViews[indexPath.row]];
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        AddOrderTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AddOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.delegate = self;
        }
        
        if (cell.numberTF != [_priceTFList objectAtIndex:indexPath.row]) {
            //解决cell重用冲突
            UIView *view = [cell viewWithTag:1000];
            [view removeFromSuperview];
            
            cell.numberTF = [_priceTFList objectAtIndex:indexPath.row];
            [cell addSubview:[_priceTFList objectAtIndex:indexPath.row]];
        }
        
        cell.titleNumberLabel.text = [NSString stringWithFormat:@"订单 %ld",(long)indexPath.row + 1];
        
        
        if (_isFirst) {
            cell.deleteBtn.hidden = YES;
            _isFirst = NO;
        }
        
        return cell;
    };
    
    if (indexPath.section == 2) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        [cell addSubview:_totalView];
        
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)addNewOrder {
    
    if (_priceTFList.count > 14) {
        [Tools showHUD:@"最多只能发布15个定单！"];
        return;
    }
    
    for (UITextField *textField in _priceTFList) {
        if (textField.text.length == 0) {
            [textField becomeFirstResponder];
            [Tools showHUD:@"订单金额不能为0元"];
            return ;
        }
        if ([textField.text floatValue] > 1000 || [textField.text floatValue] < 5) {
            [textField becomeFirstResponder];
            [Tools showHUD:@"金额范围5~1000元"];
            return;
        }
    }
    
    [self createNumberTextFieldView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_priceTFList.count-1 inSection:1];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [_tableView reloadData];
    [self changeValue];
    
    [[_priceTFList lastObject] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
}

- (void)removeNewOrderCell:(AddOrderTableViewCell *)addOrderTableViewCell {
    
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:addOrderTableViewCell];
    [_priceTFList removeObjectAtIndex:indexPath.row];
    [self priceChange:nil];
    
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [_tableView reloadData];
    [self changeValue];
}

- (void)changeValue {
    _orderNumberLabel.text = [NSString stringWithFormat:@"订单数: %ld单" ,(long)[_priceTFList count]];
    if (_priceTFList.count == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:HiddenDeleteIconNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowDeleteIconNotification object:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)createNumberTextFieldView {
    
    UITextField *numberTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 10, 60, 35)];
    numberTF.textColor = DeepGrey;
    numberTF.textAlignment = NSTextAlignmentCenter;
    numberTF.font = [UIFont systemFontOfSize:NormalFontSize];
    numberTF.layer.borderColor = LightGrey.CGColor;
    numberTF.layer.borderWidth = 0.5;
    numberTF.delegate = self;
    numberTF.tag = 1000;
    numberTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    [_priceTFList addObject:numberTF];
    [self changeValue];
}

- (void)priceChange:(NSNotification*)sender {
    
    if (sender && ![_priceTFList containsObject:sender.object]) {
        return;
    }
    
    _totalAmount = 0;
    for (UITextField *priceTF in _priceTFList) {
        _totalAmount += [priceTF.text floatValue];
    }
    
    _totalLabel.textAlignment = NSTextAlignmentRight;
    NSString *price = [NSString stringWithFormat:@"%.2f",_totalAmount];
    NSMutableAttributedString *mbstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"订单总金额:%@元",price]];
    [mbstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize],
                           NSForegroundColorAttributeName : DeepGrey
                           } range:NSMakeRange(0, mbstr.length)];
    [mbstr addAttributes:@{NSForegroundColorAttributeName : RedDefault} range:[mbstr.string rangeOfString:price]];
    _totalLabel.attributedText = mbstr;
}

- (BOOL)checkData {
    
    if (_priceTFList.count == 0) {
        [Tools showHUD:@"请至少添加一个订单"];
        return NO;
    }
    
    for (UITextField *textField in _priceTFList) {
        if (textField.text.length == 0) {
            [Tools showHUD:@"订单金额不能为0"];
            return NO;
        }
        
        if ([textField.text floatValue] > 1000 || [textField.text floatValue] < 5) {
            [textField becomeFirstResponder];
            [Tools showHUD:@"金额范围5~1000元"];
            return NO;
        }
    }

    if (![UserInfo isOneKeyPubOrder]) {
        if (_phoneTF.text.length == 0) {
            [Tools showHUD:@"请添加手机号码"];
            return NO;
        }
        
        if (_phoneTF.text.length != 11 || ![_phoneTF.text isRightPhoneNumberFormat]) {
            [Tools showHUD:@"请填写正确的手机号码"];
            return NO;
        }
        
        if (_address.text.length == 0) {
            [Tools showHUD:@"请填写地址"];
            return NO;
        }
    }
    
    if (_remarkTF.text.length > 50) {
        [Tools showHUD:@"备注长度不能超过50个字符"];
        return NO;
    }
    
    return YES;
}

- (void)releseTask {

    if (![self checkData]) {
        return;
    }
    [Tools hiddenKeyboard];
    
    
    NSDictionary *requsetData = @{@"BussinessId" : [UserInfo getUserId],
                                  @"Version" : APIVersion,
                                  @"Amount" : @(_totalAmount),
                                  @"OrderCount" : @(_priceTFList.count)};
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI getDistribSubsidy:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        
        CGFloat distrib = [result getFloatWithKey:@"DistribSubsidy"];
        NSString *str = [NSString stringWithFormat:@"总金额:%.2f元\n订单金额:%.2f元\n订单数量:%ld\n配送费:%.2f元",_totalAmount + distrib * _priceTFList.count ,_totalAmount, (long)_priceTFList.count,distrib * _priceTFList.count];
        
        JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"确定要发布订单吗？" message:str];
        [alert addButton:Button_CANCEL withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
            
        }];
        [alert addButton:Button_OK withTitle:@"确定" handler:^(JKAlertDialogItem *item) {
            [self releseInfo];
        }];
        [alert show];
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
    
    return;
    //配送费
 
   
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要发布订单吗" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
}

- (void)releseInfo {
    NSMutableArray *childList = [NSMutableArray array];
    for (NSInteger i = 0; i < _priceTFList.count; i++) {
        UITextField *textFiled = _priceTFList[i];
        NSDictionary *childOrder = @{@"GoodPrice" : @([textFiled.text floatValue])};
        [childList addObject:childOrder];
    }
    NSData *childListData = [NSJSONSerialization dataWithJSONObject:childList options:NSJSONWritingPrettyPrinted error:NULL];
    
    
    NSDictionary *requsetData = @{@"userId"                 : [UserInfo getUserId],
                                  @"receviceName"           : @"",
                                  @"receviceAddress"        : _address.text ? _address.text : @"",
                                  @"recevicePhone"          : _phoneTF.text ? _phoneTF.text : @"",
                                  @"Amount"                 : @(_totalAmount),
                                  @"IsPay"                  : @(_completePayBtn.checked),
                                  @"Remark"                 : _remarkTF.text,
                                  @"OrderChlidJson"         : [[NSString alloc]initWithData:childListData encoding:NSUTF8StringEncoding],
                                  @"version"                : @"1.0",
                                  @"TimeSpan"               : @((int)[[NSDate date] timeIntervalSince1970]),
                                  @"longitude"              : @(0.0),
                                  @"laitude"                : @(0.0),
                                  @"OrderCount"             : @(_priceTFList.count),
                                  @"OrderSign"              : @"",
                                  @"PubLatitude"            : @(_coordinate.latitude),
                                  @"PubLongitude"           : @(_coordinate.longitude)
                                  };
    
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI releseOrder:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ReleseOrderNotification object:nil];
        
        [Tools showHUD:@"发布成功"];
        [Tools hiddenProgress:HUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];

}

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 1) {
        return;
    }
    
    NSMutableArray *childList = [NSMutableArray array];
    for (NSInteger i = 0; i < _priceTFList.count; i++) {
        UITextField *textFiled = _priceTFList[i];
        NSDictionary *childOrder = @{
                                     //                                     @"ChildId"     : @(i),
                                     @"GoodPrice"   : @([textFiled.text floatValue])};
        [childList addObject:childOrder];
    }
    NSData *childListData = [NSJSONSerialization dataWithJSONObject:childList options:NSJSONWritingPrettyPrinted error:NULL];
    

    NSDictionary *requsetData = @{@"userId"                 : [UserInfo getUserId],
                                  @"receviceName"           : @"",
                                  @"receviceAddress"        : _address.text ? _address.text : @"",
                                  @"recevicePhone"          : _phoneTF.text ? _phoneTF.text : @"",
                                  @"Amount"                 : @(_totalAmount),
                                  @"IsPay"                  : @(_completePayBtn.checked),
                                  @"Remark"                 : _remarkTF.text,
                                  @"OrderChlidJson"         : [[NSString alloc]initWithData:childListData encoding:NSUTF8StringEncoding],
                                  @"version"                : @"1.0",
                                  @"TimeSpan"               : @((int)[[NSDate date] timeIntervalSince1970]),
                                  @"longitude"              : @(0.0),
                                  @"laitude"                : @(0.0),
                                  @"OrderCount"             : @(_priceTFList.count),
                                  @"OrderSign"              : @"",
                                  @"PubLatitude"            : @(_coordinate.latitude),
                                  @"PubLongitude"           : @(_coordinate.longitude)
                                  };
    
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI releseOrder:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ReleseOrderNotification object:nil];
        
        [Tools showHUD:@"发布成功"];
        [Tools hiddenProgress:HUD];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
}
*/
 
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    
    _coordinate.latitude = userLocation.location.coordinate.latitude;
    _coordinate.longitude = userLocation.location.coordinate.longitude;
    
}

#pragma mark 键盘相关处理
- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_tableView changeFrameHeight:ScreenHeight - keyboardRect.size.height - 64];
                         UIView *firstResponder = [Tools findFirstResponderFromView:_tableView];
                         [_tableView scrollRectToVisible:CGRectInset(firstResponder.frame, 0, -20) animated:YES];
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_tableView changeFrameHeight:ScreenHeight - 64 ];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
