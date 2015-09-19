//
//  EDSStatisticsInfoClienterInfoModel.h
//  ESend
//
//  Created by 台源洪 on 15/9/19.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"


@interface EDSStatisticsInfoClienterInfoModel : BaseModel

@property (nonatomic, assign) long clienterId;
@property (nonatomic, copy) NSString * clienterName;
@property (nonatomic, copy) NSString * clienterPhone;
@property (nonatomic, copy) NSString * clienterPhoto;
@property (nonatomic, assign) long orderCount;
@property (nonatomic, copy) NSString * pubDate;

@end
