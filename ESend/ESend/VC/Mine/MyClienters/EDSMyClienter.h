//
//  EDSMyClienter.h
//  ESend
//
//  Created by 台源洪 on 15/11/6.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface EDSMyClienter : BaseModel

@property (nonatomic,copy) NSString * headPhoto;
@property (nonatomic,copy) NSString * trueName;
@property (nonatomic,copy) NSString * phoneNo;
@property (nonatomic,assign) NSInteger relationId;
@property (nonatomic,assign) NSInteger clienterId;

@end
