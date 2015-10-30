//
//  Hp9ItemCell.h
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hp9ItemCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIView *contents;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;

/// 此单元格的总的订单数量
@property (assign, nonatomic) NSInteger orderCount;




@end
