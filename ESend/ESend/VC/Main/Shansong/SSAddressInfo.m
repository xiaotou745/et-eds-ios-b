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
        self.latitude = [NSString stringWithFormat:@"%f",poi.pt.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",poi.pt.longitude];

//        self.coordinate = poi.pt;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_latitude forKey:@"latitude"];
    [aCoder encodeObject:_longitude forKey:@"longitude"];
    [aCoder encodeObject:_addition forKey:@"addition"];
    [aCoder encodeObject:[NSNumber numberWithBool:_selected] forKey:@"selected"];
    //
    [aCoder encodeObject:_personName forKey:@"personName"];
    [aCoder encodeObject:_personPhone forKey:@"personPhone"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _uid = [aDecoder decodeObjectForKey:@"uid"];
        _address = [aDecoder decodeObjectForKey:@"address"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _latitude = [aDecoder decodeObjectForKey:@"latitude"];
        _longitude = [aDecoder decodeObjectForKey:@"longitude"];
        _addition = [aDecoder decodeObjectForKey:@"addition"];
        _selected = [[aDecoder decodeObjectForKey:@"selected"] boolValue];
        _personName = [aDecoder decodeObjectForKey:@"personName"];
        _personPhone = [aDecoder decodeObjectForKey:@"personPhone"];
    }
    
    return  self;
}

- (BOOL)sameTo:(SSAddressInfo *)anAddr{
    BOOL result = NO;
    if ([self.name isEqualToString:anAddr.name] &&
        [self.address isEqualToString:anAddr.address] &&
        [self.city isEqualToString:anAddr.city] &&
//        [self.latitude isEqualToString:anAddr.latitude] &&
//        [self.longitude isEqualToString:anAddr.longitude] &&
        [self.addition isEqualToString:anAddr.addition] &&
        [self.personPhone isEqualToString:anAddr.personPhone] &&
        [self.personName isEqualToString:anAddr.personName]) {
        result = YES;
    }
    return result;
}

@end
