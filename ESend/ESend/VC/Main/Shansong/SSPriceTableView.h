//
//  SSPriceTableView.h
//  ESend
//
//  Created by 台源洪 on 15/12/20.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSPriceTableView : UIView

- (id)initWithmasterKG:(NSInteger)masterKG
              masterKM:(NSInteger)masterKM
masterDistributionPrice:(double)masterDistributionPrice
                 oneKM:(NSInteger)oneKM
  oneDistributionPrice:(double)oneDistributionPrice
                 twoKG:(NSInteger)twoKG
  twoDistributionPrice:(double)twoDistributionPrice;

- (void)showInView:(UIView *)view;
@end
