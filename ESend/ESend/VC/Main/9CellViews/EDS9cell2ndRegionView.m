//
//  EDS9cell2ndRegionView.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDS9cell2ndRegionView.h"

#define EDS9cell2ndRegionViewCellId @"EDS9cell2ndRegionViewCellId"

@interface EDS9cell2ndRegionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UILabel * _titleLabel;
    UICollectionView * _collectionView;
}
@end

@implementation EDS9cell2ndRegionView

- (instancetype)initWithDelegate:(id<EDS9cell2ndRegionViewDelegate>)delegate dataSource:(NSArray *)dataSource regionName:(NSString *)regionName{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _delegate = delegate;
        self.dataSource = dataSource;
        self.regionName = regionName;
        [self configUIViews];
    }
    return self;
}

- (void)configUIViews{
    
    self.backgroundColor = BackgroundColor;
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
        _titleLabel.backgroundColor = BackgroundColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor     = DeepGrey;
        _titleLabel.font          = FONT_SIZE(BigFontSize);
        UITapGestureRecognizer * tapTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:tapTitle];
    }
    _titleLabel.text = self.regionName;
    [self addSubview:_titleLabel];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setItemSize:CGSizeMake(86, 68)];//设置cell的尺寸
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//设置其边界
        flowLayout.minimumLineSpacing = 10;
        if (iPhone6plus) {
            flowLayout.minimumInteritemSpacing = 40;
        }else{
            flowLayout.minimumInteritemSpacing = 10;
        }
        
        NSInteger rows = (self.dataSource.count%3 == 0)?self.dataSource.count/3:self.dataSource.count/3 + 1;
        CGFloat collectionHeight = flowLayout.minimumLineSpacing * (rows - 1) + flowLayout.sectionInset.top + flowLayout.sectionInset.bottom + flowLayout.itemSize.height * rows;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), ScreenWidth, collectionHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.layer.borderColor = [SeparatorColorC CGColor];
        _collectionView.layer.borderWidth = 0.5f;
        
    }
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([Hp9ItemSecondaryCell class]) bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:EDS9cell2ndRegionViewCellId];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];
    
    UIView * maskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), ScreenWidth, ScreenHeight - CGRectGetHeight(_collectionView.frame) - 64)];
    maskView.backgroundColor = BackgroundColor;
    maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapMask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [maskView addGestureRecognizer:tapMask];
    [self addSubview:maskView];
}

#pragma mark - show & hide

- (void)show{
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
}

- (void)close{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    [self removeFromSuperview];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemSecondaryCell * cell = (Hp9ItemSecondaryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:EDS9cell2ndRegionViewCellId forIndexPath:indexPath];
    cell.dataModel = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     Hp9ItemSecondaryCell * cell = (Hp9ItemSecondaryCell *)[collectionView cellForItemAtIndexPath:indexPath];
     cell.dataModel.orderCount ++;
}

/*
 //定义每个UICollectionView 的间距（返回UIEdgeInsets：上、左、下、右）
 -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
 //定义每个UICollectionView 纵向的间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
 //UICollectionView被选中时调用的方法
 -(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
 */

@end
