//
//  SSEditorTypeTransformer.m
//  ESend
//
//  Created by 台源洪 on 15/11/26.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSEditorTypeTransformer.h"

@implementation SSEditorTypeTransformer

+ (NSString *)titleStringWithEditorType:(SSAddressEditorType)type{
    NSString * result = nil;
    switch (type) {
        case SSAddressEditorTypeFa:result = HpFaTitle;break;
        case SSAddressEditorTypeShou: result = HpShouTitle;break;
        default: break;
    }
    return result;
}

+ (SSAddressEditorType)typeWithEditorTitleStr:(NSString *)title{
    NSAssert(nil != title, @"title != nil");
    if (NSOrderedSame == [title compare:HpFaTitle]) {
        return SSAddressEditorTypeFa;
    }else {
        return SSAddressEditorTypeShou;
    }
}

@end
