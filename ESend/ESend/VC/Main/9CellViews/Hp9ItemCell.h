//
//  Hp9ItemCell.h
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hp9CellRegionModel.h"

@interface Hp9ItemCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIView *contents;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *regionName;

@property (strong, nonatomic) Hp9CellRegionModel * dataModel;

@end
