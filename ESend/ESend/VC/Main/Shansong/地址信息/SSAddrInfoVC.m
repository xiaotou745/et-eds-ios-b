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

#define SS_HPNoFaAddressMsg @"请输入发货地址"
#define SS_HPNoShouAddressMsg @"请输入收货地址"
#define SS_HPWrongPhoneNumberMsg @"请输入正确的手机号"
#define SS_HPNoFaAddressMsg @"请输入发货地址"
#define SS_HPNoShouAddressMsg @"请输入收货地址"
#define SS_HpNoShouNameMsg @"请输入收货人姓名"
#define SS_HpNoShouPhoneMsg @"请输入收货人电话"
#define SS_HpWrongShouPhongMsg @"收货人电话格式不对"
#define SS_HpNoFaNameMsg @"请输入发货人姓名"
#define SS_HpNoFaPhoneMsg @"请输入发货人电话"
#define SS_HpWrongFaPhongMsg @"发货人电话格式不对"

#define SS_HpFaNameMaxLengh @"发货人姓名不能超过10个字"
#define SS_HpShouNameMaxLengh @"收货人姓名不能超过10个字"

#define SS_HpFaNameMinLengh @"发货人姓名不能少于2个字"
#define SS_HpShouNameMinLengh @"收货人姓名不能少于2个字"


@interface SSAddrInfoVC ()<ABPeoplePickerNavigationControllerDelegate,UITextFieldDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,SSEditAdderssViewControllerDelegate>
{
    BOOL _genderIsWoman;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    BOOL _has_addr_value;
}
@property (weak, nonatomic) IBOutlet UIImageView *aiAddrTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *aiAddrText;
@property (weak, nonatomic) IBOutlet UITextField *aiAddrAdtion;
@property (weak, nonatomic) IBOutlet UITextField *aiAddrPhone;
@property (weak, nonatomic) IBOutlet UITextField *aiAddrPersonName;
@property (weak, nonatomic) IBOutlet UIButton *aiAddrPersonGender;

@end

@implementation SSAddrInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aiAddrInfoTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssAddrMapPOINotify:) name:ShanSongAddressMapPOISectedNotify object:nil];
    // nav
    [self.rightBtn addTarget:self action:@selector(clickConformAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self UIViewsWithAddrType:self.addrType];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.addrInfo.uid == nil && self.addrType == SSAddressEditorTypeFa) {
        _searcher = [[BMKGeoCodeSearch alloc] init];
        // 定位，反编码
        if (!_locService) {
            _locService = [[BMKLocationService alloc]init];
            _locService.delegate = self;
        }
        [_locService startUserLocationService];
        _searcher.delegate = self;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_locService) {
        [_locService stopUserLocationService];
        _locService.delegate = nil;
    }
    if (_searcher) {
        _searcher.delegate = nil;
    }
}

- (void)UIViewsWithAddrType:(SSAddressEditorType)addrType{
    if (addrType == SSAddressEditorTypeFa) {
        self.titleLabel.text = @"发货人信息";
        self.aiAddrTypeImg.image = [UIImage imageNamed:@"ss_release_fa"];
        self.aiAddrText.text = SS_HPNoFaAddressMsg;
        self.aiAddrPhone.placeholder = @"发货人电话";
        self.aiAddrPersonName.placeholder = @"发货人姓名";
    }else{
        self.titleLabel.text = @"收货人信息";
        self.aiAddrTypeImg.image = [UIImage imageNamed:@"ss_release_shou"];
        self.aiAddrText.text = SS_HPNoShouAddressMsg;
        self.aiAddrPhone.placeholder = @"收货人电话";
        self.aiAddrPersonName.placeholder = @"收货人姓名";
    }
    if (self.addrInfo) {
        // 带入地址
        self.aiAddrText.text = [NSString stringWithFormat:@"%@(%@)",self.addrInfo.name,self.addrInfo.address];
        self.aiAddrText.textColor = DeepGrey;
        if (self.addrInfo.addition.length > 0) {
            self.aiAddrAdtion.text = self.addrInfo.addition;
        }
        self.aiAddrPersonName.text = self.addrInfo.personName;
        self.aiAddrPhone.text = self.addrInfo.personPhone;
        _genderIsWoman = self.addrInfo.genderIsWoman;
        NSString * imgName = _genderIsWoman?@"ss_woman":@"ss_man";
        [self.aiAddrPersonGender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        _has_addr_value = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)aiAddrPhoneChoosingAction:(UIButton *)sender {
    [Tools hiddenKeyboard];
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
}
- (IBAction)aiAddrTextEditorAction:(UITapGestureRecognizer *)sender {
    [Tools hiddenKeyboard];
    SSEditAdderssViewController * eavc = [[SSEditAdderssViewController alloc] initWithNibName:@"SSEditAdderssViewController" bundle:nil Type:self.addrType];
    eavc.currentCityName = self.currentCityName;
    eavc.delegate = self;
    [self.navigationController pushViewController:eavc animated:YES];
}

- (IBAction)aiGenderChoosingAction:(UIButton *)sender {
    [Tools hiddenKeyboard];
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


#pragma mark - 导航栏确定
- (void)clickConformAction{
    if (!_has_addr_value) {
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HPNoFaAddressMsg:SS_HPNoShouAddressMsg];
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
    if (self.aiAddrPersonName.text.length <= 0 || [self.aiAddrPersonName.text allSpace]) { // *货人姓名
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpNoFaNameMsg:SS_HpNoShouNameMsg];
        return;
    }
    if (self.aiAddrPersonName.text.length < 2) { // *货人姓名
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpFaNameMinLengh:SS_HpShouNameMinLengh];
        return;
    }
    self.addrInfo.addition = isCanUseString(self.aiAddrAdtion.text)?self.aiAddrAdtion.text:@"";
    self.addrInfo.personPhone = self.aiAddrPhone.text;
    self.addrInfo.personName = self.aiAddrPersonName.text;
    self.addrInfo.genderIsWoman = _genderIsWoman;
    if (!isCanUseString(self.addrInfo.uid)) {
        self.addrInfo.uid = [self generateUniqueId];
    }
    NSDictionary * notifyInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.addrInfo,NotifyInfoKey,[NSNumber numberWithInteger:self.addrType],NotifyTypeKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShanSongAddressAdditionFinishedNotify object:nil userInfo:notifyInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void)aiAddrInfoTextFieldChanged:(NSNotification *)notify{
    UITextField * textField = (UITextField *)notify.object;
    if (textField == self.aiAddrPhone && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
        [Tools showHUD:SS_HPWrongPhoneNumberMsg];
    }
    if (textField == self.aiAddrPersonName && textField.text.length > 10) { // *货人名称
        textField.text = [textField.text substringToIndex:10];
        [Tools showHUD:(self.addrType == SSAddressEditorTypeFa)?SS_HpFaNameMaxLengh:SS_HpShouNameMaxLengh];
    }
}


#pragma mark - BMKMapViewDelegate  BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (!_addrInfo) {
            _addrInfo = [[SSAddressInfo alloc] init];
        }
        _addrInfo.name = result.addressDetail.streetName;
        _addrInfo.address = result.address;
        _addrInfo.addition = @"";
        _addrInfo.uid = [self generateUniqueId];
        _addrInfo.city = result.addressDetail.city;
        self.currentCityName = _addrInfo.city;
        _addrInfo.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        _addrInfo.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        _addrInfo.selected = YES;
        _has_addr_value = YES;
        
        self.aiAddrText.text = [NSString stringWithFormat:@"%@(%@)",_addrInfo.name,_addrInfo.address];
        self.aiAddrText.textColor = DeepGrey;
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - general uid
- (NSString *)generateUniqueId{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}


#pragma mark SSEditAdderssViewControllerDelegate
- (void)editAddressVC:(SSEditAdderssViewController *)vc disSelectPOIAddr:(SSAddressInfo *)poiInfo{
    self.addrInfo = poiInfo;
    _has_addr_value = YES;
    self.currentCityName = poiInfo.city;
    self.aiAddrText.text = [NSString stringWithFormat:@"%@(%@)",_addrInfo.name,_addrInfo.address];
    self.aiAddrText.textColor = DeepGrey;
}

#pragma mark - 地图选择通知
- (void)ssAddrMapPOINotify:(NSNotification *)notify{
    NSDictionary * info = notify.userInfo;
    SSAddressInfo * addrInfo = [info objectForKey:NotifyInfoKey];
    self.addrInfo = addrInfo;
    _has_addr_value = YES;
    self.currentCityName = addrInfo.city;
    self.aiAddrText.text = [NSString stringWithFormat:@"%@(%@)",_addrInfo.name,_addrInfo.address];
    self.aiAddrText.textColor = DeepGrey;
}

@end
