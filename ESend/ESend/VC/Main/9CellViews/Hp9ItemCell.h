//
//  Hp9ItemCell.h
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hp9CellRegionModel.h"

@class Hp9ItemCell;

@protocol Hp9ItemCellDelegate <NSObject>
@optional
- (void)hp9ItemShouldCallOutSecondaryRegionView:(Hp9ItemCell *)cell;

@end

@interface Hp9ItemCell : UICollectionViewCell

// @property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIView *contents;
// @property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *regionName;
// 显示与隐藏
@property (strong, nonatomic) IBOutlet UIImageView *minusImg;
@property (strong, nonatomic) IBOutlet UIButton *minusActionBtn;
@property (strong, nonatomic) IBOutlet UILabel *orderCountLbl;

@property (strong, nonatomic) Hp9CellRegionModel * dataModel;

@property (weak, nonatomic) id<Hp9ItemCellDelegate>delegate;

@end
