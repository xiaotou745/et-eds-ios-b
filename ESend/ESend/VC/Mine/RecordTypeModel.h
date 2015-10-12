//
//  RecordTypeModel.h
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, BS_RecordType) {
    BS_RecordTypeAll = 0,     // 出账入账
    BS_RecordTypeOut = 1,     // 出账
    BS_RecordTypeIn = 2,      // 入账
};


@interface RecordTypeModel : BaseModel

@property (nonatomic, assign) NSInteger code;   // 交易类型码
@property (nonatomic, copy) NSString * desc;    // 交易类型
/// 出入账类型 0 出账入账 1出账 2入账
@property (nonatomic, assign) BS_RecordType type;   // 0,1,2

@property (nonatomic, assign) BOOL selected;    // 是否被选中

@end
