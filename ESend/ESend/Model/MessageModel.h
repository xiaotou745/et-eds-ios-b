//
//  MessageModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) BOOL isRead;

@end
