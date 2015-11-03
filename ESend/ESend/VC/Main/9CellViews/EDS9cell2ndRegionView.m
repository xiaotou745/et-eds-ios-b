//
//  EDS9cell2ndRegionView.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDS9cell2ndRegionView.h"
#import "Hp9ItemCell.h"

#define EDS9cell2ndRegionViewCellId @"EDS9cell2ndRegionViewCellId"

@interface EDS9cell2ndRegionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView * _bgView;
    UILabel * _titleLabel;
    UICollectionView * _collectionView;
}
@end

@implementation EDS9cell2ndRegionView

- (instancetype)initWithDelegate:(id<EDS9cell2ndRegionViewDelegate>)delegate dataSource:(NSArray *)dataSource regionName:(NSString *)regionName{
    if (self = [super init]) {
        _delegate = delegate;
        self.dataSource = dataSource;
        self.regionName = regionName;
        [self configUIViews];
    }
    return self;
}

- (void)configUIViews{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 30)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor     = DeepGrey;
        _titleLabel.font          = FONT_SIZE(BigFontSize);
    }
    _titleLabel.text = self.regionName;
    [_bgView addSubview:_titleLabel];
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 300)];
        
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([Hp9ItemCell class]) bundle:nil];
        [_collectionView registerNib:cellNib forCellWithReuseIdentifier:EDS9cell2ndRegionViewCellId];

    }
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_bgView addSubview:_collectionView];
    
}

#pragma mark - show & hide


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EDS9cell2ndRegionViewCellId forIndexPath:indexPath];
    cell.secondaryDataModel = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.orderCount ++;

}

@end
