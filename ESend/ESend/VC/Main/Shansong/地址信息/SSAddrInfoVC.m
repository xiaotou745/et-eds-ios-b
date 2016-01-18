//
//  SSAddrInfoVC.m
//  ESend
//
//  Created by 台源洪 on 16/1/15.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import "SSAddrInfoVC.h"
#import "SSEditAdderssViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "NSString+PhoneFormat.h"
#import "NSString+allSpace.h"
#import "NSString+evaluatePhoneNumber.h"

#define SS_HPWrongPhoneNumberMsg @"请输入正确的手机号"
#define SS_HPNoFaAddressMsg @"请输入发货地址"
#define SS_HPNoShouAddressMsg @"请输入收货地址"
#define SS_HpNoShouNameMsg @"请输入收货人姓名"
#define SS_HpNoShouPhoneMsg @"请输入收货人电话"
#define SS_HpWrongShouPhongMsg @"收货人电话格式不对"
#define SS_HpNoFaNameMsg @"请输入寄货人姓名"
#define SS_HpNoFaPhoneMsg @"请输入寄货人电话"
#define SS_HpWrongFaPhongMsg @"寄货人电话格式不对"

#define SS_HpFaNameMaxLengh @"寄货人姓名不能超过10个字"
#define SS_HpShouNameMaxLengh @"收货人姓名不能超过10个字"

#define SS_HpFaNameMinLengh @"寄货人姓名不能少于2个字"
#define SS_HpShouNameMinLengh @"收货人姓名不能少于2个字"


@interface SSAddrInfoVC ()<ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate>
{
    BOOL _genderIsWoman;
}
@property (weak, nonatomic) IBOutlet UIImageView *aiAddrTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *aiAddrText;
@property (weak, nonatomic) IBOutlet UITextField *aiAddrAdtion;
@property (weak, nonatomic) IBOutlet UITextField *aiAddrPhone;
@property (weak, nonatomic) IBOutlet UIImageView *aiAddrGender;
@property (weak, nonatomic) IBOutlet UITextField *aiAddrPersonName;

@end

@implementation SSAddrInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aiAddrInfoTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    // nav
    [self.rightBtn addTarget:self action:@selector(clickConformAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self UIViewsWithAddrType:self.addrType];
}

- (void)UIViewsWithAddrType:(SSAddressEditorType)addrType{
    if (addrType == SSAddressEditorTypeFa) {
        self.aiAddrTypeImg.image = [UIImage imageNamed:@"ss_release_fa"];
        self.aiAddrText.text = SS_HPNoFaAddressMsg;
        self.aiAddrPhone.placeholder = @"发货人电话";
        self.aiAddrPersonName.placeholder = @"发货人姓名";
    }else{
        self.aiAddrTypeImg.image = [UIImage imageNamed:@"ss_release_shou"];
        self.aiAddrText.text = SS_HPNoShouAddressMsg;
        self.aiAddrPhone.placeholder = @"收货人电话";
        self.aiAddrPersonName.placeholder = @"收货人姓名";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)aiAddrPhoneChoosingAction:(UIButton *)sender {
    NSLog(@"%s",__func__);
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
}
- (IBAction)aiAddrTextEditorAction:(UITapGestureRecognizer *)sender {
    NSLog(@"%s",__func__);
    SSEditAdderssViewController * eavc = [[SSEditAdderssViewController alloc] initWithNibName:@"SSEditAdderssViewController" bundle:nil Type:self.addrType];
    eavc.currentCityName = self.currentCityName;
//    eavc.delegate = self;
    [self.navigationController pushViewController:eavc animated:YES];
}

- (IBAction)aiGenderChoosingAction:(UIButton *)sender {
    _genderIsWoman = !_genderIsWoman;
    NSString * imgName = _genderIsWoman?@"ss_woman":@"ss_man";
    [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
//选择属性之后，注意如果上面的代理方法实现后此方法不会被调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        //NSLog(@"%@",[phone phoneFormat]);
        NSString * name = (__bridge NSString *)(ABRecordCopyCompositeName(person));
        self.aiAddrPhone.text = [phone phoneFormat];
        self.aiAddrPersonName.text = name;
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        NSString * name = (__bridge NSString *)(ABRecordCopyCompositeName(person));
        //NSLog(@"%@",name);
        //NSLog(@"%@",[phone phoneFormat]);
        self.aiAddrPhone.text = [phone phoneFormat];
        self.aiAddrPersonName.text = name;
    }
    return NO;
}


#pragma mark - 导航栏事件
- (void)clickConformAction{
    if (self.aiAddrPersonName.text.length <= 0 || [self.aiAddrPersonName.text allSpace]) { // *货人姓名
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpNoFaNameMsg:SS_HpNoShouNameMsg];
        return;
    }
    if (self.aiAddrPersonName.text.length < 2) { // *货人姓名
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpFaNameMinLengh:SS_HpShouNameMinLengh];
        return;
    }
    if (self.aiAddrPhone.text.length <= 0 || [self.aiAddrPhone.text allSpace]) { // *货人电话
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpNoFaPhoneMsg:SS_HpNoShouPhoneMsg];
        return;
    }
    if (![self.aiAddrPhone.text rightConsigneeContactInfo]) {// *货人电话
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpWrongFaPhongMsg:SS_HpWrongShouPhongMsg];
        return;
    }
}

#pragma mark - UITextFieldDelegate
- (void)aiAddrInfoTextFieldChanged:(NSNotification *)notify{
    UITextField * textField = (UITextField *)notify.object;
    if (textField == self.aiAddrPersonName && textField.text.length > 10) { // *货人名称
        textField.text = [textField.text substringToIndex:10];
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpFaNameMaxLengh:SS_HpShouNameMaxLengh];
    }
}

@end
