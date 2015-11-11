//
//  Hp9ItemSecondaryCell.h
//  ESend
//
//  Created by 台源洪 on 15/11/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hp9cellSecondaryRegion.h"

@interface Hp9ItemSecondaryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIView *contents;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *regionName;

@property (strong, nonatomic) Hp9cellSecondaryRegion * dataModel;

@end
