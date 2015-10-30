//
//  EDS9CellHomepageVC.m
//  ESend
//
//  Created by 台源洪 on 15/10/29.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDS9CellHomepageVC.h"
#import "MineViewController.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "Hp9ItemCell.h"


#define Hp9ItemCellId @"Hp9cellItemCellId"

@interface EDS9CellHomepageVC ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *Hp_Scroller;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Hp_ScrollerHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *Hp_9cells;

@end

@implementation EDS9CellHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavTitle];
    [self config9Cells];
    
    NSDictionary *requestData = @{
                                  @"BusinessId" : [UserInfo getUserId],
                                  @"version"    : @"1.0",
                                  };
    NSString * urlString = @"BusinessAPI/GetUserStatus";
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    
    [[FHQNetWorkingKit getHTTPSessionManagerWithHost:OPEN_API_SEVER] POST:urlString parameters:requestData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];
    

}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.Hp_ScrollerHeight.constant = ScreenHeight -63 - 44 - 15;
}

/// 配置导航条
- (void)configNavTitle{
    self.titleLabel.text = @"发布任务";
    self.leftBtn.hidden = YES;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(mineBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)config9Cells{
    NSLog(@"%@",NSStringFromClass([Hp9ItemCell class]));
    //Hp9ItemCell
    UINib *cellNib = [UINib nibWithNibName:@"Hp9ItemCell" bundle:nil];
    [self.Hp_9cells registerNib:cellNib forCellWithReuseIdentifier:Hp9ItemCellId];
    self.Hp_9cells.dataSource = self;
    self.Hp_9cells.delegate = self;
    //self.Hp_9cells.
}

- (void)mineBtnAction{
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 9 cell 
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:Hp9ItemCellId forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.orderCount ++;
}

@end
