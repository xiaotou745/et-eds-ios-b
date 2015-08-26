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

#import "ConsigneeModel.h"
#import "ConsigneeInfoCell.h"
#import "DataArchive.h"

#define LocalConsigneeId @"-1"

typedef NS_ENUM(NSInteger, PayStatus) {
    PayStatusComplete,
    PayStatusUnpaid
};

@interface ReleseOrderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddOrderTableViewCellDelegate, UIAlertViewDelegate,ConsigneeInfoCellDelegate>
{
    UITableView *_tableView;
    
    UITextField *_phoneTF;              // 收货人手机
    UITextField *_address;              // 收货人地址
    UITextField *_personName;             // 收货人名称
    
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
    
    // 发单提示
    UITextField *_phoneTF2;
    UITableView *_consigneeTV;
    UIView *_mask2;
    UIView * _bgv;
    UITableView *_consigneeHistoryTV;
    //
    NSMutableArray * _consigneeArray;
    NSMutableArray * _consigneeArrayForDisplay;
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
    
    _consigneeArray = [[NSMutableArray alloc] initWithCapacity:0];
    _consigneeArrayForDisplay = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray * localConsignees = [DataArchive storedConsigneesWithShopid:[UserInfo getUserId]];
    //NSLog(@"localConsignee:%@",localConsignees);
    [_consigneeArray addObjectsFromArray:localConsignees];
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
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
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
    _phoneTF.clearButtonMode = UITextFieldViewModeNever;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    UIButton * _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 55)];
    _phoneBtn.backgroundColor = [UIColor clearColor];
    [_phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_phoneTF addSubview:_phoneBtn];
    
    _address = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 20, 55)];
    _address.textColor = DeepGrey;
    _address.font = [UIFont systemFontOfSize:NormalFontSize];
    _address.placeholder = @"收货地址";
    _address.text = @"";
    _address.clearButtonMode = UITextFieldViewModeWhileEditing;
    _address.delegate = self;
    
    _personName = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 20, 55)];
    _personName.textColor = DeepGrey;
    _personName.font = [UIFont systemFontOfSize:NormalFontSize];
    _personName.placeholder = @"收货人姓名";
    _personName.text = @"";
    _personName.clearButtonMode = UITextFieldViewModeWhileEditing;
    _personName.delegate = self;
    
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
    
    [_cellViews addObjectsFromArray:@[_phoneTF, _address, _personName,_payStatusView,_orderNumberLabel]];
    
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

#pragma mark - tableViewDelegate datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView) {
        if (indexPath.section == 2) {
            return 60;
        }
        
        return 55;
    }else if (tableView == _consigneeHistoryTV){
        return 78;
    }else{
        return 0;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return 3;
    }else if (tableView == _consigneeHistoryTV) {
        return 1;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView == _tableView) {
        if (section == 1 || section == 2) {
            return 55;
        }
        return 0.1;
    }else if (tableView == _consigneeHistoryTV){
        return 0.1;
    }else{
        return 0;
    }
    

}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 1) {
            return _addNewOrderView;
        }
        
        if (section == 2) {
            return _remarkTF;
        }
        
        return nil;
    }else if (tableView == _consigneeHistoryTV) {
        return nil;
    }else{
        return nil;
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        if (section == 0) {
            return _cellViews.count;
        }
        
        if (section == 1) {
            return _priceTFList.count;
        }
        
        return 1;
    }else if (tableView == _consigneeHistoryTV) {
        return _consigneeArrayForDisplay.count;
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
    ///////////////////////////////////
    if (tableView == _tableView) {
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
            
            if(_priceTFList.count == 1){
                cell.deleteBtn.hidden = YES;
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
    }else if (tableView == _consigneeHistoryTV) {
        static NSString * consigneeCellId = @"consigneeCellId";
        ConsigneeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:consigneeCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsigneeInfoCell" owner:nil options:nil] lastObject];
        }
        cell.consigneeInfo = [_consigneeArrayForDisplay objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        return nil;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _consigneeHistoryTV) {
        ConsigneeModel * consignee = [_consigneeArrayForDisplay objectAtIndex:indexPath.row];
        _phoneTF.text = consignee.consigneePhone;
        _address.text = consignee.consigneeAddress;
        _personName.text = consignee.consigneeUserName;
        [self _cancelAction:nil];
    }
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
        [Tools showHUD:@"最多只能发布15个订单！"];
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
    
    // 只有一个cell不能删除
    if (_priceTFList.count == 1) {
        [Tools showHUD:@"至少有一个订单"];
        return;
    }
    
    
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

/// 修改金额
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
        
        if (_personName.text.length >= 20) {
            [Tools showHUD:@"收货人姓名长度不能超过20位"];
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
        //
        ConsigneeModel * consignee = [[ConsigneeModel alloc] init];
        consignee.consigneePhone = _phoneTF.text ? _phoneTF.text : @"";
        consignee.consigneeAddress = _address.text ? _address.text : @"";
        consignee.consigneeUserName = _personName.text ? _personName.text : @"";
        consignee.consigneeId = LocalConsigneeId;      // 本地存储的，都是-1，删除consignee接口调用时，-1，只需要删除本地，不用调接口了。
        [self storeConsigneeModel:consignee];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];

}

/// 发单成功存储用户手机，地址
- (void)storeConsigneeModel:(ConsigneeModel *)consignee{
    NSString * bid = [UserInfo getUserId];
    NSMutableArray * localConsignees = [NSMutableArray arrayWithArray:[DataArchive storedConsigneesWithShopid:bid]];
    if (localConsignees.count > 0) {
        
//        for (ConsigneeModel * aConsignee in localConsignees) {
//            if ([aConsignee samePhoneWithConsignee:consignee]) {
//                localConsignees repla
//            }
//        }
        BOOL contain = NO;
        for (int i = 0; i < localConsignees.count; i ++) {
            ConsigneeModel * aConsignee = [localConsignees objectAtIndex:i];
            if ([consignee samePhoneWithConsignee:aConsignee]) {
                [localConsignees replaceObjectAtIndex:i withObject:consignee];
                contain = YES;
                break;
            }
            
        }
        
        if (!contain) {
            [localConsignees addObject:consignee];
        }
        
        [DataArchive storeConsignees:localConsignees shopId:bid];
        
    }else{
        [DataArchive storeConsignees:[NSArray arrayWithObjects:consignee, nil] shopId:bid];
    }
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

#pragma mark - 电话联想

- (void)phoneBtnAction:(id)sender{
    [self showSearchViews];
}

- (void)showSearchViews{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    _bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 64)];
    _bgv.backgroundColor = [UIColor whiteColor];
    _bgv.layer.borderWidth = 0.5f;
    _bgv.layer.borderColor = [MiddleGrey CGColor];
    [self.view addSubview:_bgv];
    
    _mask2 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, MainHeight - 44)];
    _mask2.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    _mask2.alpha = 1.0f;
    [self.view addSubview:_mask2];
    //
    _phoneTF2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, MainWidth - 20 - 100, 44)];
    _phoneTF2.backgroundColor = [UIColor whiteColor];
    _phoneTF2.font = [UIFont systemFontOfSize:NormalFontSize];
    _phoneTF2.textColor = DeepGrey;
    _phoneTF2.placeholder = @"收货人电话";
    _phoneTF2.text = _phoneTF.text;
    _phoneTF2.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTF2.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF2.delegate = self;
    [_phoneTF2 becomeFirstResponder];
    [_bgv addSubview:_phoneTF2];
    
    UIButton * _okbtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + _phoneTF2.frame.size.width, 24, 49, 36)];
    _okbtn.layer.borderWidth = 0.5;
    _okbtn.layer.borderColor = [MiddleGrey CGColor];
    _okbtn.layer.cornerRadius = 2;
    _okbtn.layer.masksToBounds = YES;
    [_okbtn addTarget:self action:@selector(_okbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_okbtn setTitle:@"确 定" forState:UIControlStateNormal];
    [_okbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _okbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_bgv addSubview:_okbtn];
    
    UIButton * _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(_okbtn.frame.origin.x + 51, 24, 49, 36)];
    _cancelBtn.layer.borderWidth = 0.5;
    _cancelBtn.layer.borderColor = [MiddleGrey CGColor];
    _cancelBtn.layer.cornerRadius = 2;
    _cancelBtn.layer.masksToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(_cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bgv addSubview:_cancelBtn];
    
    // table
    _consigneeHistoryTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, MainHeight - 44) style:UITableViewStylePlain];
    _consigneeHistoryTV.dataSource = self;
    _consigneeHistoryTV.delegate = self;
    _consigneeHistoryTV.backgroundColor = [UIColor clearColor];
    _consigneeHistoryTV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _consigneeHistoryTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mask2 addSubview:_consigneeHistoryTV];
}

- (void)_okbtnAction:(id)sender{
    
    if ([_phoneTF2.text rightConsigneeContactInfo]) {
        _phoneTF.text = _phoneTF2.text;
        [self _cancelAction:nil];
    }else{
        [Tools showHUD:@"请输入正确的手机或座机号"];
    }
    

}

- (void)_cancelAction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [_bgv removeFromSuperview];
    _bgv = nil;
    [_mask2 removeFromSuperview];
    _mask2 = nil;
}


#pragma mark - UITextFieldDelegate
/// 字符变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
   // NSLog(@"%@",toBeString);
    if (textField == _phoneTF2 && toBeString.length >= 3) {
        // 手机号，超过3级以上，联想
        [_consigneeArrayForDisplay removeAllObjects];
        for (ConsigneeModel * aConsignee in _consigneeArray) {
            if ([aConsignee.consigneePhone containsString:toBeString]) {
                [_consigneeArrayForDisplay addObject:aConsignee];
            }
        }
        [_consigneeHistoryTV reloadData];
    }
    
    if (textField == _personName) {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            [Tools showHUD:@"收货人姓名长度不能超过20位"];
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - ConsigneeInfoCellDelegate
/// 删除历史发单记录
- (void)ConsigneeInfoCell:(ConsigneeInfoCell *)cell deleteButtonAction:(ConsigneeModel *)consignee{
    if ([consignee.consigneeId compare:LocalConsigneeId] == NSOrderedSame) {
        // -1,删除本地即可
        
        [DataArchive deleteConsignee:consignee shopId:[UserInfo getUserId]];
        
        NSIndexPath *indexPath = [_consigneeHistoryTV indexPathForCell:cell];
        [_consigneeArrayForDisplay removeObjectAtIndex:indexPath.row];
        
        
        [_consigneeHistoryTV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_consigneeHistoryTV reloadData];
        
        [_consigneeArray removeAllObjects];
        NSArray * localConsignees = [DataArchive storedConsigneesWithShopid:[UserInfo getUserId]];
        //NSLog(@"localConsignee:%@",localConsignees);
        [_consigneeArray addObjectsFromArray:localConsignees];
        
        
    }else{
        // 删除服务器
        NSDictionary *requsetData = @{@"BusinessId" : [UserInfo getUserId],
                                      @"Version" : APIVersion,
                                      @"AddressId" : consignee.consigneeId
                                      };
        [FHQNetWorkingAPI RemoveAddressB:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
            
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            
        }];
        // 删除本地
        [DataArchive deleteConsignee:consignee shopId:[UserInfo getUserId]];

        
        NSIndexPath *indexPath = [_consigneeHistoryTV indexPathForCell:cell];
        [_consigneeArrayForDisplay removeObjectAtIndex:indexPath.row];
        
        [_consigneeHistoryTV deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_consigneeHistoryTV reloadData];
        
        [_consigneeArray removeAllObjects];
        NSArray * localConsignees = [DataArchive storedConsigneesWithShopid:[UserInfo getUserId]];
        //NSLog(@"localConsignee:%@",localConsignees);
        [_consigneeArray addObjectsFromArray:localConsignees];
    }
    
}
@end
