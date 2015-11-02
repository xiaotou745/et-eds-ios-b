//
//  EDS9cell2ndRegionView.h
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EDS9cell2ndRegionView;

@protocol EDS9cell2ndRegionViewDelegate <NSObject>



@end

@interface EDS9cell2ndRegionView : UIView

- (instancetype)initWithDelegate:(id<EDS9cell2ndRegionViewDelegate>)delegate;

@end
