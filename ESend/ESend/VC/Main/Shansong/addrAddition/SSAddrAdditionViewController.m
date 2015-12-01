//
//  SSAddrAdditionViewController.m
//  ESend
//
//  Created by 台源洪 on 15/12/1.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSAddrAdditionViewController.h"
#import "NSString+allSpace.h"
#import "SSHttpReqServer.h"

@interface SSAddrAdditionViewController ()
@property (nonatomic,assign) SSAddressEditorType type;
@property (nonatomic,strong) SSAddressInfo * addrInfo;

@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollerHeight;
@property (strong, nonatomic) IBOutlet UIImageView *typeImg;
@property (strong, nonatomic) IBOutlet UILabel *addressContent;
@property (strong, nonatomic) IBOutlet UITextField *addrAdditioinTF;

@end

@implementation SSAddrAdditionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type Addr:(SSAddressInfo *)info{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.type = type;
        self.addrInfo = info;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == SSAddressEditorTypeFa) {
        self.titleLabel.text = @"补充发货地址";
    }else{
        self.titleLabel.text = @"补充收货地址";
    }
    self.typeImg.image = [SSEditorTypeTransformer imageWithEditorType:self.type];
    self.addressContent.text = self.addrInfo.name;
    [self.confirmBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.scrollerHeight.constant = ScreenHeight - 63;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmBtnAction:(UIButton *)sender {
    if (self.addrAdditioinTF.text.length <= 0 || [self.addrAdditioinTF.text allSpace]) {
        [Tools showHUD:[NSString stringWithFormat:@"请%@",self.titleLabel.text]];
        return;
    }
    self.addrInfo.addition = self.addrAdditioinTF.text;
    NSDictionary * notifyInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.addrInfo,NotifyInfoKey,[NSNumber numberWithInteger:self.type],NotifyTypeKey, nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShanSongAddressAdditionFinishedNotify object:nil userInfo:notifyInfo];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    NSDictionary * paraDict = @{
//                                @"businessid":@"1105",//[UserInfo getUserId],
//                                @"pubname":@"san",
//                                @"islogin":@"true",
//                                @"publongitude":@"116.516578",
//                                @"publatitude":@"39.917445",
//                                @"pubphoneno":@"18810287488",
//                                @"pubaddress":@"尚8里文创园A座7-11",
//                                @"taketype":@"0",
//                                @"takelongitude":@"0",
//                                @"takelatitude":@"0",
//                                @"recevicename":@"四",
//                                @"recevicephoneno":@"15392978661",
//                                @"receviceaddress":@"v华腾",
//                                @"recevicelongitude":@"116.516578",
//                                @"recevicelatitude":@"39.917445",
//                                @"productname":@"货物名字",
//                                @"remark":@"这是备注",
//                                @"amount":@"10.00",
//                                @"weight":@"3",
//                                @"km":@"4",
//                                };
//    if (AES_Security) {
//        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
//        NSString * aesString = [Security AesEncrypt:jsonString2];
//        paraDict = @{@"data":aesString,};
//    }
//    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
//    [SSHttpReqServer orderflashpush:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [Tools hiddenProgress:HUD];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [Tools hiddenProgress:HUD];
//
//    }];
}

@end
