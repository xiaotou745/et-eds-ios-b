//
//  RecordTypeModel.h
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface RecordTypeModel : BaseModel

@property (nonatomic, assign) NSInteger code;   // 交易类型码
@property (nonatomic, copy) NSString * desc;    // 交易类型
@property (nonatomic, assign) NSInteger type;   // 出入账类型 0 出账入账 1出账 2入账

@end
