//
//  EDSFullfillOptionCell.h
//  ESend
//
//  Created by 台源洪 on 15/9/14.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EDSPaymentType) {
    EDSPaymentTypeAlipay = 1,                  // alipay
    EDSPaymentTypeWechatPay = 2                // wechatpay
};

@interface EDSPaymentTypeModel : NSObject

@property (nonatomic, assign) EDSPaymentType  paymentType;
@property (nonatomic, copy) NSString * paymentName;
@property (nonatomic, assign) BOOL selected;

@end


@interface EDSFullfillOptionCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *FFOC_PaymentTypeImg;
@property (strong, nonatomic) IBOutlet UIImageView *FFOC_PaymentMarker;
@property (strong, nonatomic) IBOutlet UILabel *FFOC_PaymentNameLbl;
@property (strong, nonatomic) IBOutlet UIImageView *FFOC_CellSeparatorLine;

@property (strong, nonatomic) EDSPaymentTypeModel * paymentModel;

@end
