//
//  SSPayMethodCell.h
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPayMethodTypes.h"
#import "BaseModel.h"
#import "SSPayMethodTypes.h"

@interface SSPayMethodModel : BaseModel

@property (nonatomic,assign) SSPayMethodType payType;
@property (nonatomic,assign) BOOL selected;

- (NSString *)payMethodString;
- (NSString *)payMethodImgString;

@end

@interface SSPayMethodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payTypeImg;
@property (weak, nonatomic) IBOutlet UIImageView *separator;
@property (weak, nonatomic) IBOutlet UIImageView *selectionMarker;
@property (weak, nonatomic) IBOutlet UILabel *payTypeTitle;

@property (strong,nonatomic) SSPayMethodModel *datasource;

@end
