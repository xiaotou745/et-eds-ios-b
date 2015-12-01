//
//  SSAddrAdditionViewController.m
//  ESend
//
//  Created by 台源洪 on 15/12/1.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSAddrAdditionViewController.h"

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
    
}

@end
