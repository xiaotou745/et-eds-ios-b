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
    
    self.backgroundColor = [UIColor whiteColor];
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 30)];
        _titleLabel.backgroundColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor     = [UIColor blackColor];
        _titleLabel.font          = FONT_SIZE(BigFontSize);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer:tap];
    }
    _titleLabel.text = self.regionName;
    [self addSubview:_titleLabel];
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setItemSize:CGSizeMake(86, 68)];//设置cell的尺寸
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置其边界
        //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 94, ScreenWidth, ScreenHeight - 100) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor yellowColor];


    }
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([Hp9ItemSecondaryCell class]) bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:EDS9cell2ndRegionViewCellId];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self addSubview:_collectionView];

}

#pragma mark - show & hide

- (void)show{
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    self.layer.transform = CATransform3DMakeScale(1.3f, 0.9f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor whiteColor];
                         self.layer.opacity = 1.0f;
                         self.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:^(BOOL finished) {
//                         if (![NSThread isMainThread]) {
//                             [_collectionView reloadData];
//                         } else {
//                             [_collectionView reloadData];
//                         }
                     }
     ];
}

- (void)close{
    CATransform3D currentTransform = self.layer.transform;
    self.layer.opacity = 1.0f;
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
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
