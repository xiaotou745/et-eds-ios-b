//
//  SSAddressInfo.m
//  ESend
//
//  Created by 台源洪 on 15/11/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSAddressInfo.h"

@implementation SSAddressInfo
- (instancetype)initWithBMKPoiInfo:(BMKPoiInfo *)poi{
    if (self = [super init]) {
        self.name = poi.name;
        self.uid = poi.uid;
        self.address = poi.address;
        self.city = poi.city;
        self.addition = @"";
    }
    return self;
}
@end
