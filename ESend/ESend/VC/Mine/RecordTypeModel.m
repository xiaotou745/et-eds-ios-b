//
//  RecordTypeModel.m
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "RecordTypeModel.h"

@implementation RecordTypeModel

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.code = [dic getIntegerWithKey:@"code"];
        self.desc = [dic getStringWithKey:@"desc"];
        self.type = [dic getIntegerWithKey:@"type"];
        
        self.selected = NO;
    }
    return self;
}

@end
