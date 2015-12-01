//
//  SSEditorTypeTransformer.h
//  ESend
//
//  Created by 台源洪 on 15/11/26.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SSAddressEditorType) {
    SSAddressEditorTypeFa = 0,
    SSAddressEditorTypeShou
};

#define HpFaTitle @"发货地址"
#define HpShouTitle @"收货地址"

#define NotifyTypeKey @"type"//
#define NotifyInfoKey @"addrInfo"

@interface SSEditorTypeTransformer : NSObject
+ (SSAddressEditorType)typeWithEditorTitleStr:(NSString *)title;
+ (NSString *)titleStringWithEditorType:(SSAddressEditorType)type;
+ (UIImage *)imageWithEditorType:(SSAddressEditorType)type;

@end
