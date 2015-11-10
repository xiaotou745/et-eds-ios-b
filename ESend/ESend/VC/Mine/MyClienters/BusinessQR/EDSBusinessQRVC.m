//
//  EDSBusinessQRVC.m
//  ESend
//
//  Created by 台源洪 on 15/11/9.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBusinessQRVC.h"
#import "ZXingObjC.h"
#import "UserInfo.h"
#import "UIColor+KMhexColor.h"
#import "Security.h"

@interface EDSBusinessQRVC ()
@property (strong, nonatomic) IBOutlet UIView *QR_BgView;
@property (strong, nonatomic) IBOutlet UILabel *QR_Name;
@property (strong, nonatomic) IBOutlet UILabel *QR_Phone;
@property (strong, nonatomic) IBOutlet UIImageView *QR_img;
@property (strong, nonatomic) IBOutlet UILabel *QR_Note;

@end

@implementation EDSBusinessQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的二维码";
    self.view.backgroundColor = [UIColor km_colorWithHexString:@"363A3E"];
    self.QR_BgView.layer.cornerRadius = 2.0f;
    self.QR_BgView.layer.masksToBounds = YES;
    self.QR_Name.textColor =
    self.QR_Note.textColor =
    self.QR_Phone.textColor = DeepGrey;
    
    NSString * uid = [UserInfo getUserId];
    NSString * uname = [UserInfo getBussinessName];
    NSString * uphone = [UserInfo getbussinessPhone];
    
    self.QR_Name.text = uname;
    self.QR_Phone.text = uphone;
    
     NSError *error = nil;
     ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
//     NSString * strC = [[NSString stringWithFormat:@"%@-%@",uid,uname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString* strAfterDecodeByUTF8AndURI = [strC stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@  \n  %@",strC,strAfterDecodeByUTF8AndURI);
    NSString * strC = [Security AesEncrypt:[NSString stringWithFormat:@"%@-%@",uid,uname]];

     ZXBitMatrix* result = [writer encode:strC format:kBarcodeFormatQRCode width:500 height:500 error:&error];
     if (result) {
         CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
         self.QR_img.image = [UIImage imageWithCGImage:image];
         // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
     } else {
         NSString *errorMessage = [error localizedDescription];
         NSLog(@"%@",errorMessage);
     }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
