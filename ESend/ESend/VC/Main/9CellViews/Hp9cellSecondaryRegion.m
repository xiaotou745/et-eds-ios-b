//
//  Hp9cellSecondaryRegion.m
//  ESend
//
//  Created by 台源洪 on 15/11/3.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "Hp9cellSecondaryRegion.h"

@implementation Hp9cellSecondaryRegion

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.regionId = [[dic objectForKey:@"id"] integerValue];
        self.regionName = [dic objectForKey:@"regionName"];
    }
    return self;
}

@end
