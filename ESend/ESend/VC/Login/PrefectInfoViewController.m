//
//  PrefectInfoViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/1.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "PrefectInfoViewController.h"
#import "MapViewController.h"
#import "FHQNetWorkingAPI.h"
#import "DataBase.h"
#import "OriginModel.h"
#import "UserInfo.h"
#import "FHQNetWorkingAPI.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <BaiduMapAPI/BMapKit.h>
#import "InfoInTheReviewViewController.h"
#import "NSString+evaluatePhoneNumber.h"

typedef NS_ENUM(NSInteger, PhotoType) {
    PhotoTypeCard = 6100,
    PhotoTypeLicense,
    PhotoTypeCardDemo,
    PhotoTypeLicenseDemo
};

@interface PrefectInfoViewController ()<UITextFieldDelegate, MapViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate, UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    
    UITextField *_shoppingNameTF;
    UITextField *_addressTF;
    UITextField *_detailAddressTF;
    UITextField *_zipCodeTF;
    UITextField *_phoneTF;
    UITextField *_mobilePhoneTF;
    UIButton *_mapBtn;
    
    UIView *_bottomView;
    UIImageView *_cardImageView;
    UIImageView *_licenseImageView;
    
    MapViewController *_mapVC;
    
    DataBase *_dataBase;
    OriginModel *_origin;
    
    UIView *_maskView;
    UIImageView *_demoImageView;
    UILabel *_demoTitleLabel;
    UILabel *_demoContentLabel;
    
    BMKReverseGeoCodeResult *_addressResult;
    UploadImageModel *_cardImageModel;
    UploadImageModel *_licenseImageModel;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
}
@end

@implementation PrefectInfoViewController

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

- (void)mapViewControllerFinshLoacation:(BMKReverseGeoCodeResult *)addressCodeResult origin:(OriginModel *)origin {
   
    _origin = origin;
    _addressResult = addressCodeResult;
    
    _addressTF.text = [NSString stringWithFormat:@"%@ %@", addressCodeResult.addressDetail.city,addressCodeResult.addressDetail.district];
    _detailAddressTF.text = [NSString stringWithFormat:@"%@%@", addressCodeResult.addressDetail.streetName, addressCodeResult.addressDetail.streetNumber];
    _zipCodeTF.text = origin.zipCode;
   
}

- (void)initializeData {
    
//    _dataBase = [DataBase shareDataBase];
//
//    
//    NSDictionary *requestData = @{@"UserId" : @"1",
//                                  @"Version" : @"1.0"};
//    [FHQNetWorkingAPI getCityList:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
//        NSLog(@"%@",result);
//        [_dataBase updateData:[result getArrayWithKey:@"AreaModels"]];
//    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
//        
//    } isShowError:NO];
}

- (void)bulidView {
    
    _mapVC = [[MapViewController alloc] init];
    _mapVC.delegate = self;
    
    
    self.titleLabel.text = @"商户信息";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64)];
    [self.view addSubview:_scrollView];
    
    _shoppingNameTF = [self createTextField:@"店铺名称"];
    _shoppingNameTF.frame = CGRectMake(0, 15, MainWidth, 55);
    _shoppingNameTF.delegate = self;
    [_scrollView addSubview:_shoppingNameTF];
    
    UIView *line1 = [Tools createLine];
    line1.frame = CGRectMake(0, CGRectGetMaxY(_shoppingNameTF.frame), MainWidth, 0.5);
    [_scrollView addSubview:line1];
    
    _addressTF = [self createTextField:@"所在地区"];
    _addressTF.enabled = NO;
    _addressTF.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), MainWidth, 55);
    _addressTF.delegate = self;
    [_scrollView addSubview:_addressTF];
    
    _mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mapBtn setTitle:@"当前位置" forState:UIControlStateNormal];
    [_mapBtn setBackgroundSmallImageNor:@"blue_border_btn_nor" smallImagePre:@"blue_btn_nor" smallImageDis:nil];
    [_mapBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    _mapBtn.frame = CGRectMake(MainWidth - 100, FRAME_Y(_addressTF) + 5, 80, 45);
    [_mapBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    [_mapBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_scrollView addSubview:_mapBtn];
    
    UIView *line2 = [Tools createLine];
    line2.frame = CGRectMake(0, CGRectGetMaxY(_addressTF.frame), MainWidth, 0.5);
    [_scrollView addSubview:line2];
    
    _detailAddressTF = [self createTextField:@"详细地址"];
    _detailAddressTF.frame = CGRectMake(0, CGRectGetMaxY(line2.frame), MainWidth, 55);
    _detailAddressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _detailAddressTF.delegate = self;
    _detailAddressTF.returnKeyType = UIReturnKeyDone;
    [_scrollView addSubview:_detailAddressTF];
    
    UIView *line3 = [Tools createLine];
    line3.frame = CGRectMake(0, CGRectGetMaxY(_detailAddressTF.frame), MainWidth, 0.5);
    [_scrollView addSubview:line3];
    
    _zipCodeTF = [self createTextField:@"区号"];
    _zipCodeTF.frame = CGRectMake(0, CGRectGetMaxY(line3.frame), 110, 55);
    _zipCodeTF.textAlignment = NSTextAlignmentCenter;
    _zipCodeTF.enabled = NO;
    [_scrollView addSubview:_zipCodeTF];
    
    _phoneTF = [self createTextField:@"座机号码"];
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.frame = CGRectMake(CGRectGetMaxX(_zipCodeTF.frame), FRAME_Y(_zipCodeTF), MainWidth - 110, 55);
    [_scrollView addSubview:_phoneTF];
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_zipCodeTF.frame), CGRectGetMaxY(line3.frame), 0.5, 55)];
    vLine.backgroundColor = line3.backgroundColor;
    [_scrollView addSubview:vLine];
    
    UIView *line4 = [Tools createLine];
    line4.frame = CGRectMake(0, CGRectGetMaxY(_phoneTF.frame), MainWidth, 0.5);
    [_scrollView addSubview:line4];
    
    _mobilePhoneTF = [self createTextField:@"手机号码"];
    _mobilePhoneTF.frame = CGRectMake(0, CGRectGetMaxY(line4.frame), MainWidth, 55);
    _mobilePhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _mobilePhoneTF.text = [UserInfo getTelephoneNum];
    [_scrollView addSubview:_mobilePhoneTF];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mobilePhoneTF.frame) + 15, MainWidth, 200)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bottomView];
    
    UILabel *cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 45)];
    cardLabel.text = @"店主手持身份证照片";
    cardLabel.textColor = DeepGrey;
    cardLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_bottomView addSubview:cardLabel];
    
    UILabel *cardDemoLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 100, 0, 90, 45)];
    cardDemoLabel.textAlignment = NSTextAlignmentRight;
    cardDemoLabel.text = @"查看示例";
    cardDemoLabel.tag = PhotoTypeCardDemo;
    cardDemoLabel.textColor = BlueColor;
    cardDemoLabel.font = [UIFont systemFontOfSize:BigFontSize];
    cardDemoLabel.userInteractionEnabled = YES;
    [_bottomView addSubview:cardDemoLabel];
    
    UITapGestureRecognizer *tapCardDemo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCardDemo:)];
    [cardDemoLabel addGestureRecognizer:tapCardDemo];
    
    _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainWidth - 140)/2, CGRectGetMaxY(cardLabel.frame) + 10, 140, 105)];
    _cardImageView.image = [UIImage imageNamed:@"photo_default"];
    _cardImageView.userInteractionEnabled = YES;
    _cardImageView.tag = PhotoTypeCard;
    _cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bottomView addSubview:_cardImageView];
    
    UITapGestureRecognizer *tapCard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_cardImageView addGestureRecognizer:tapCard];
    
    UILabel *licenseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_cardImageView.frame) + 10, MainWidth, 45)];
    licenseLabel.text = @"营业执照或卫生许可证照片";
    licenseLabel.textColor = DeepGrey;
    licenseLabel.font = [UIFont systemFontOfSize:BigFontSize];
    licenseLabel.userInteractionEnabled = YES;
    [_bottomView addSubview:licenseLabel];
    
    UILabel *licenseDemoLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 100, CGRectGetMaxY(_cardImageView.frame) + 10, 90, 45)];
    licenseDemoLabel.textAlignment = NSTextAlignmentRight;
    licenseDemoLabel.text = @"查看示例";
    licenseDemoLabel.tag = PhotoTypeLicenseDemo;
    licenseDemoLabel.textColor = BlueColor;
    licenseDemoLabel.font = [UIFont systemFontOfSize:BigFontSize];
    licenseDemoLabel.userInteractionEnabled = YES;
    [_bottomView addSubview:licenseDemoLabel];
    
    UITapGestureRecognizer *tapLicenseDemo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCardDemo:)];
    [licenseDemoLabel addGestureRecognizer:tapLicenseDemo];
    
    _licenseImageView = [[UIImageView alloc] initWithFrame:CGRectMake((MainWidth - 140)/2, CGRectGetMaxY(licenseLabel.frame) + 10, 140, 105)];
    _licenseImageView.image = [UIImage imageNamed:@"photo_default"];
    _licenseImageView.userInteractionEnabled = YES;
    _licenseImageView.tag = PhotoTypeLicense;
    _licenseImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bottomView addSubview:_licenseImageView];

    [_bottomView changeFrameHeight:CGRectGetMaxY(_licenseImageView.frame) + 20];
    
    UITapGestureRecognizer *tapLicense = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_licenseImageView addGestureRecognizer:tapLicense];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, CGRectGetMaxY(_bottomView.frame) + 20, MainWidth - 20, 44);
    [submitBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"blue_btn_pre"];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:submitBtn];

    
    _scrollView.contentSize = CGSizeMake(MainWidth, CGRectGetMaxY(submitBtn.frame) + 30);
    

    [self loadData];

}

- (void)loadData {
    
//    [self beginLoacation];
    
    
    
    if (!_bussiness) {
        [self.leftBtn setImageNor:nil imagePre:nil];
        [self.leftBtn changeFrameWidth:90];
        [self.leftBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        //
        [self.leftBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        [self beginLoacation];
        
    } else {
        
        if (!isCanUseString([_bussiness getStringWithKey:@"district"])) {
            [self beginLoacation];
        } else {
            _addressResult = [[BMKReverseGeoCodeResult alloc] init];
            _addressResult.addressDetail = [[BMKAddressComponent alloc] init];
            _addressResult.addressDetail.province = [_bussiness getStringWithKey:@"Province"];
            _addressResult.addressDetail.city = [_bussiness getStringWithKey:@"City"];
            _addressResult.addressDetail.district = [_bussiness getStringWithKey:@"district"];
            CLLocationCoordinate2D location;
            location.latitude = [_bussiness getFloatWithKey:@"Latitude"];
            location.longitude = [_bussiness getFloatWithKey:@"Longitude"];
            _addressResult.location = location;

        }
        
        
        _shoppingNameTF.text = [_bussiness getStringWithKey:@"Name"];
        _mobilePhoneTF.text = [_bussiness getStringWithKey:@"PhoneNo2"];
        _detailAddressTF.text = [_bussiness getStringWithKey:@"Address"];
        _addressTF.text = [NSString stringWithFormat:@"%@ %@",[_bussiness getStringWithKey:@"City"], [_bussiness getStringWithKey:@"district"]];
        
        NSString *landline = [_bussiness getStringWithKey:@"Landline"];
        if (isCanUseString(landline)) {
            NSArray *strArr = [landline componentsSeparatedByString:@"-"];
            if ([strArr count] == 2) {
                _zipCodeTF.text = strArr[0];
                _phoneTF.text = strArr[1];
            } else {
                _phoneTF.text = landline;
            }

        }
        
        [_cardImageView sd_setImageWithURL:[NSURL URLWithString:[_bussiness getStringWithKey:@"CheckPicUrl"]] placeholderImage:[UIImage imageNamed:@"photo_default"]];
        [_licenseImageView sd_setImageWithURL:[NSURL URLWithString:[_bussiness getStringWithKey:@"BusinessLicensePic"]] placeholderImage:[UIImage imageNamed:@"photo_default"]];
    }
    
    
    
}

- (BOOL)checkData {
    
    if (_shoppingNameTF.text.length == 0) {
        [Tools showHUD:@"请输入店铺名称"];
        [_shoppingNameTF becomeFirstResponder];
        return NO;
    }
    
    if (_shoppingNameTF.text.length > 20) {
        [Tools showHUD:@"商户名称不能超过20个字符"];
        [_shoppingNameTF becomeFirstResponder];
        return NO;
    }
    
    if ([Tools isContainsEmoji:_shoppingNameTF.text]) {
        [Tools showHUD:@"店铺名称不能输入表情"];
        return NO;
    }
    
    if (!_addressResult) {
        [Tools showHUD:@"请选择您的位置位置！"];
        return NO;
    }
    
    if (_detailAddressTF.text.length > 30) {
        [Tools showHUD:@"地址长度不能超过30个字符"];
        return NO;
    }
    
    if (_phoneTF.text.length == 0) {
        [Tools showHUD:@"请输入座机号码"];
        [_phoneTF becomeFirstResponder];
        return NO;
    }
    
    if (_phoneTF.text.length < 7 || _phoneTF.text.length > 8) {
        [Tools showHUD:@"请输入正确的座机号码"];
        [_phoneTF becomeFirstResponder];
        return NO;
    }
    
    if (_mobilePhoneTF.text.length == 0) {
        [Tools showHUD:@"请输入手机号码"];
        [_mobilePhoneTF becomeFirstResponder];
        return NO;
    }
    
    if (_mobilePhoneTF.text.length != 11 || ![_mobilePhoneTF.text isRightPhoneNumberFormat]) {
        [Tools showHUD:@"请输入正确的手机号码"];
        [_mobilePhoneTF becomeFirstResponder];
        return NO;
    }
    
    if (!_bussiness) {
        if (_cardImageModel == nil) {
            [Tools showHUD:@"请上传证件照片"];
            return NO;
        }
        if (_licenseImageModel == nil) {
            [Tools showHUD:@"请上传营业执照照片"];
            return NO;
        }
    } else {
        if (!isCanUseString([_bussiness getStringWithKey:@"CheckPicUrl"]) && !_cardImageModel.imageData) {
            [Tools showHUD:@"请上传身份证照片"];
            return NO;
        }
        if (!isCanUseString([_bussiness getStringWithKey:@"BusinessLicensePic"]) && !_licenseImageModel.imageData) {
            [Tools showHUD:@"请上传营业执照照片"];
            return NO;
        }
    }
    
    return YES;
}

- (void)submit {
    if(![self checkData]) {
        return;
    }
    
    if ([UserInfo getStatus] == UserStatusComplete ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交信息后您的账号将会进入审核状态！确定要修改信息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        [self uploadData];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self uploadData];
    }
}

- (void)uploadData {
    NSString *landline = @"";
    if (isCanUseString(_zipCodeTF.text)) {
        landline = [NSString stringWithFormat:@"%@-%@",_zipCodeTF.text, _phoneTF.text];
    } else {
        landline = _phoneTF.text;
    }
    
    
    NSDictionary *requestData = @{@"Version"                : APIVersion,
                                  @"userId"                 : [UserInfo getUserId],
                                  @"businessName"           : _shoppingNameTF.text,
                                  @"Address"                : _detailAddressTF.text,
                                  @"phoneNo"                : _mobilePhoneTF.text,
                                  @"landLine"               : landline,
                                  @"Province"               : _addressResult.addressDetail.province,
                                  @"City"                   : _addressResult.addressDetail.city,
                                  @"districtName"           : _addressResult.addressDetail.district,
                                  @"longitude"              : @(_addressResult.location.longitude),
                                  @"latitude"                   : @(_addressResult.location.latitude),
                                  @"IsUpdateCheckPicUrl"        : _cardImageModel ? @(0) : @(1),
                                  @"IsUpdateBusinessLicensePic" : _licenseImageModel ? @(0) : @(1)
                                  };
    
    NSMutableArray *imageLists = [NSMutableArray array];
    if (_cardImageModel) {
        [imageLists addObject:_cardImageModel];
    }
    
    if (_licenseImageModel) {
        [imageLists addObject:_licenseImageModel];
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI prefectAccount:requestData imageList:imageLists successBlock:^(id result, AFHTTPRequestOperation *operation) {
        [UserInfo saveUserInfo:result];
        if (_bussiness) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            InfoInTheReviewViewController *vc = [[InfoInTheReviewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        }
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];

}

-(void)tapCardDemo:(UITapGestureRecognizer*)tap {
    [Tools hiddenKeyboard];
    
    [self createDemoView];
    
    UIView *view = tap.view;
    if (view.tag == PhotoTypeCardDemo) {

        _demoContentLabel.text = @"请上传足够清晰的店主手持身份证照片，E代送将以此照片审核您的资质";
        _demoImageView.image = [UIImage imageNamed:@"demo_card"];
        
    } else {
        _demoContentLabel.text = @"请上传足够清晰的营业执照或卫生许可证照片，E代送将以此照片审核您的资质";
        _demoImageView.image = [UIImage imageNamed:@"demo_license"];
    }
    
    _demoContentLabel.frame = [Tools labelForString:_demoContentLabel];
    
    _maskView.alpha = 0;
    [self.view addSubview:_maskView];
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 1;
    }];
}

- (void)createDemoView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, MainWidth, ScreenHeight - 63)];
        _maskView.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
        
        _demoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, MainWidth - 40, 210)];
        _demoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _demoImageView.image = [UIImage imageNamed:@"demo_license"];
        [_maskView addSubview:_demoImageView];
        
        _demoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_demoImageView.frame) + 20, MainWidth, 25)];
        _demoTitleLabel.font = [UIFont systemFontOfSize:LagerFontSize];
        _demoTitleLabel.text = @"示例";
        _demoTitleLabel.textColor = [UIColor whiteColor];
        [_maskView addSubview:_demoTitleLabel];
        
        _demoContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_demoTitleLabel.frame) + 5, MainWidth - 60, 20)];
        _demoContentLabel.numberOfLines = 0;
        _demoContentLabel.font = [UIFont systemFontOfSize:LagerFontSize];
        _demoContentLabel.text = @"请上传足够清晰的店主手持身份证照片，E代送将以此照片审核您的资质";
        _demoContentLabel.textColor = [UIColor whiteColor];
        [_maskView addSubview:_demoContentLabel];
        _demoContentLabel.frame = [Tools labelForString:_demoContentLabel];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setTitle:@"关   闭" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@""];
        closeBtn.frame = CGRectMake(20, ScreenHeight - 64 - 44 - 80, MainWidth - 40, 44);
        [closeBtn addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:closeBtn];
        
    }
}

- (void)hiddenAlert {
    
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
    }];
}

- (void)clickImage:(UITapGestureRecognizer*)tap {
    
    [Tools hiddenKeyboard];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传照片"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册上传", nil];
    sheet.tag = tap.view.tag;
    [sheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    imagePicker.view.tag = actionSheet.tag;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self,  nil , nil );
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (picker.view.tag == PhotoTypeCard) {
        _cardImageView.image = [UIImage imageWithData:imageData];
        _cardImageModel = [[UploadImageModel alloc] init];
        _cardImageModel.imageName = @"CheckPicUrl";
        _cardImageModel.imageData = imageData;
    } else {
        _licenseImageView.image = [UIImage imageWithData:imageData];
        _licenseImageModel = [[UploadImageModel alloc] init];
        _licenseImageModel.imageName = @"BusinessLicensePic";
        _licenseImageModel.imageData = imageData;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)showMapView {
    CLLocationCoordinate2D locationCoordinate2D;
    locationCoordinate2D.latitude = 0;
    locationCoordinate2D.longitude = 0;
    if (_bussiness && [_bussiness getDoubleWithKey:@"Latitude"] != 0) {
        locationCoordinate2D.latitude = [_bussiness getDoubleWithKey:@"Latitude"];
        locationCoordinate2D.longitude = [_bussiness getDoubleWithKey:@"Longitude"];
    }
    _mapVC.locationCoordinate2D = locationCoordinate2D;
    [self.navigationController pushViewController:_mapVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if ([Tools isContainsEmoji:string]) {
//        return NO;
//    }
    return YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (UITextField*)createTextField:(NSString*)placeholder {
    
    UITextField *texfield = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 55)];
    texfield.placeholder = placeholder;
    texfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 2)];
    texfield.leftViewMode = UITextFieldViewModeAlways;
    texfield.font = [UIFont systemFontOfSize:BigFontSize];
    texfield.textColor = DeepGrey;
    texfield.backgroundColor = [UIColor whiteColor];
    
    return texfield;
}

- (void)back {
    
    if (!_bussiness) {
        [UserInfo clearUserInfo];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        if (_bussiness) {
            [APPDLE showLoginAnimated:YES];
        }
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

#pragma mark 百度地图定位
- (void)beginLoacation {
    
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    
    //启动LocationService
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        if (!_dataBase) {
            _dataBase = [DataBase shareDataBase];
        }
        
        NSString *addres = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",result.addressDetail.province, result.addressDetail.city, result.addressDetail.district, result.addressDetail.streetName, result.addressDetail.streetNumber];
        CLog(@"%@",addres);
        
        if (!isCanUseString(result.addressDetail.city)) {
            [Tools showHUD:@"定位失败"];
            return;
        }
        OriginModel *origin = [_dataBase getDistrictWithName:result.addressDetail.district city:result.addressDetail.city];
        NSLog(@"%@",origin);
        if (origin.idCode == 0) {
            [Tools showHUD:@"该地区暂未开通"];
            return;
        }
        
        _origin = origin;
        _addressResult = result;
        
        _addressTF.text = [NSString stringWithFormat:@"%@ %@", result.addressDetail.city,result.addressDetail.district];
        _detailAddressTF.text = [NSString stringWithFormat:@"%@%@", result.addressDetail.streetName, result.addressDetail.streetNumber];
        _zipCodeTF.text = origin.zipCode;
        
        
    }
    else {
        [Tools showHUD:@"未找到结果"];
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 退出登录action
- (void)logoutAction:(id)sender{
    [UserInfo clearUserInfo];
    [APPDLE showLoginAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotifaction object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
