//
//  TaskInRegionModel.h
//  ESend
//
//  Created by 台源洪 on 15/11/4.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface TaskInRegionModel : BaseModel

@property (nonatomic,assign) NSInteger clienterId;
@property (nonatomic,copy) NSString * clienterName;
@property (nonatomic,copy) NSString * clienterPhoneNo;
@property (nonatomic,copy) NSString * orderRegionTwoName;
@property (nonatomic,copy) NSString * grabTime;
@property (nonatomic, copy) NSString * pickUpTime;
@property (nonatomic,copy) NSString * clienterHeadPhoto;
@property (nonatomic,copy) NSString * actualDoneDate;
@property (nonatomic,assign) NSInteger orderCount;
@property (nonatomic,copy) NSString * orderRegionOneName;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger grabOrderId;

@end
