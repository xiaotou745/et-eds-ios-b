//
//  MessageModel.m
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.title = [dic getStringWithKey:@""];
        self.messageId = [dic getStringWithKey:@"Id"];
        self.content = [dic getStringWithKey:@"Content"];
        self.isRead = [dic getIntegerWithKey:@"IsRead"];
        self.date = [dic getStringWithKey:@"PubDate"];
        
    }
    return self;
}

@end
