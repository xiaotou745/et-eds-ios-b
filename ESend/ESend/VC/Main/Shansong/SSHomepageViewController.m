//
//  SSHomepageViewController.m
//  ESend
//
//  Created by 台源洪 on 15/11/25.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSHomepageViewController.h"
#import "SSEditAdderssViewController.h"
#import "MineViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "NSString+PhoneFormat.h"

@interface SSHomepageViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>

// 地址
@property (strong, nonatomic) IBOutlet UILabel *hp_FaAddrLabel;
@property (strong, nonatomic) IBOutlet UILabel *hp_ShouAddrLabel;

@property (strong, nonatomic) SSAddressInfo * api_addr_fa;
@property (strong, nonatomic) SSAddressInfo * api_addr_shou;

@property (assign, nonatomic) BOOL api_addr_fa_hasValue;
@property (assign, nonatomic) BOOL api_addr_shou_hasValue;

// 公斤
@property (nonatomic, assign) NSInteger api_kilo;
@property (strong, nonatomic) IBOutlet UITextField *kiloTextField;

// 距离
@property (nonatomic, assign) double api_distance;
@property (strong, nonatomic) IBOutlet UILabel *hp_distanceLabel;

// 姓名,电话
@property (strong, nonatomic) IBOutlet UITextField *hp_ShouNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_ShouPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_FaNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_FaPhoneTextField;
@property (assign,nonatomic) SSAddressEditorType phoneType;

@end

@implementation SSHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    // notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongAddrAdditionFinishedNotify:) name:ShanSongAddressAdditionFinishedNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kiloTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    self.titleLabel.text = @"E代送";
    [self.leftBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickUserVC) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - outlet actions
- (IBAction)addKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",++self.api_kilo];
}

- (IBAction)minusKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    if (self.api_kilo == 0) {
        return;
    }
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",--self.api_kilo];
}

- (IBAction)shouPhoneAction:(UIButton *)sender {
    self.phoneType = SSAddressEditorTypeShou;
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
}
- (IBAction)faPhoneAction:(UIButton *)sender {
    self.phoneType = SSAddressEditorTypeFa;
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
}

- (void)clickUserVC{
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (IBAction)editAddress:(UIButton *)sender {
    SSEditAdderssViewController * eavc = [[SSEditAdderssViewController alloc] initWithNibName:NSStringFromClass([SSEditAdderssViewController class]) bundle:nil Type:[SSEditorTypeTransformer typeWithEditorTitleStr:sender.currentTitle]];
    [self.navigationController pushViewController:eavc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (void)kiloTextFieldChanged:(NSNotification *)notify{
    if (((UITextField *)notify.object) == self.kiloTextField) {
        self.api_kilo = [((UITextField *)notify.object).text integerValue];

    }
}

#pragma mark - nofitys
- (void)shanSongAddrAdditionFinishedNotify:(NSNotification *)notify{
    NSDictionary * info = notify.userInfo;
    SSAddressEditorType addrType = [[info objectForKey:NotifyTypeKey] integerValue];
    SSAddressInfo * addrInfo = [info objectForKey:NotifyInfoKey];
    if (addrType == SSAddressEditorTypeFa) {
        self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@%@",addrInfo.name,addrInfo.addition];
        self.hp_FaAddrLabel.textColor = DeepGrey;
        self.api_addr_fa = addrInfo;
        self.api_addr_fa_hasValue = YES;
    }else if(addrType == SSAddressEditorTypeShou){
        self.hp_ShouAddrLabel.text = [NSString stringWithFormat:@"%@%@",addrInfo.name,addrInfo.addition];
        self.hp_ShouAddrLabel.textColor = DeepGrey;
        self.api_addr_shou = addrInfo;
        self.api_addr_shou_hasValue = YES;
    }
    if (self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(self.api_addr_fa.coordinate);
        BMKMapPoint point2 = BMKMapPointForCoordinate(self.api_addr_shou.coordinate);
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2); //m
        self.api_distance = distance/1000;
        self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.2f",self.api_distance];
    }
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
//选择属性之后，注意如果上面的代理方法实现后此方法不会被调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        NSLog(@"%@",[phone phoneFormat]);
        if (self.phoneType == SSAddressEditorTypeFa) {
            self.hp_FaPhoneTextField.text = [phone phoneFormat];
        }else{
            self.hp_ShouPhoneTextField.text = [phone phoneFormat];
        }
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        NSLog(@"%@",[phone phoneFormat]);
        if (self.phoneType == SSAddressEditorTypeFa) {
            self.hp_FaPhoneTextField.text = [phone phoneFormat];
        }else{
            self.hp_ShouPhoneTextField.text = [phone phoneFormat];
        }
    }
    return NO;
}
//点击取消按钮
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
   // NSLog(@"取消选择.");
}

@end
