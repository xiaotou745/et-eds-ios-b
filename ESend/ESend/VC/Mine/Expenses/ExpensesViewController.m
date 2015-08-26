//
//  ExpensesViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.




//  收支明细

#import "ExpensesViewController.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "ExpensesInfoModel.h"
#import "ExpensesMonthDataModel.h"
#import "ExpensesInfoCell.h"
#import "EmptyAlterView.h"
#import "MJRefresh.h"

#import "ExpensesDetailVC.h"

@interface ExpensesViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataList;
    
    UITableView * _listView;
    EmptyAlterView *_emptyAlertView;
}
@end

@implementation ExpensesViewController

- (void)initializeData {
    
    _dataList = [NSMutableArray array];
    
}



- (void)bulidView {
    
    self.titleLabel.text = @"收支明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight -64)];
    _listView.backgroundColor = [UIColor clearColor];
    _listView.delegate        = self;
    _listView.dataSource      = self;
    _listView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_listView];
    
    _listView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshingData)];
    [_listView.header beginRefreshing];
    
    _emptyAlertView = [[EmptyAlterView alloc] initWithMessage:@"暂时没有收支记录，快去发布任务吧"];
    _emptyAlertView.hidden = YES;
    [_listView addSubview:_emptyAlertView];
    
    
}

- (void)refreshingData {
    
    NSDictionary *requsetData = @{@"version" : APIVersion,
                                  @"BusinessId" : [UserInfo getUserId]
                                  };
    [FHQNetWorkingAPI getExpense:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {

        [_dataList removeAllObjects];
        
        BOOL isHaveData = NO;
        
        for (NSDictionary * itemDic in result) {
            ExpensesMonthDataModel * monthModel = [[ExpensesMonthDataModel alloc] init];
            monthModel.month = [itemDic getStringWithKey:@"MonthIfo"];
            
            NSArray * dataArr = [itemDic getArrayWithKey:@"Datas"];
            for (NSDictionary * itemDic in dataArr) {
                isHaveData = YES;
                ExpensesInfoModel * infoModel = [[ExpensesInfoModel alloc] init];
                infoModel.infoType = [itemDic getStringWithKey:@"RecordTypeStr"];
                infoModel.amount   = [itemDic getFloatWithKey:@"Amount"];
                infoModel.time     = [NSString stringWithFormat:@"%@ %@",[itemDic getStringWithKey:@"DateInfo"],[itemDic getStringWithKey:@"TimeInfo"]];
                infoModel.state    = [itemDic getStringWithKey:@"StatusStr"];
                
                infoModel.Remark   = [itemDic getStringWithKey:@"Remark"];
                infoModel.OperateTime = [itemDic getStringWithKey:@"OperateTime"];
                
                [monthModel.dataArr addObject:infoModel];
            }
            
            [_dataList addObject:monthModel];
        }
        
        if (!isHaveData) {
            _emptyAlertView.hidden = NO;
            [_dataList removeAllObjects];
        } else {
            _emptyAlertView.hidden = YES;
        }
        
        [_listView reloadData];
        [_listView.header endRefreshing];
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [_listView.header endRefreshing];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ExpensesMonthDataModel * model = _dataList[section];;
    return model.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ExpensesInfoCell calculateCellHeight:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ExpensesMonthDataModel * monthModel = _dataList[section];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25.f)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, 0, 80, VIEW_HEIGHT(headerView))];
    titleLabel.text      = monthModel.month;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font      = FONT_SIZE(SmallFontSize);
    [headerView addSubview:titleLabel];
    
    UIView * line1 = [Tools createLine];
    [line1 setFrame:CGRectMake(0, 0, ScreenWidth, 0.5f)];
    [headerView addSubview:line1];
    
    UIView * line2 = [Tools createLine];
    [line2 setFrame:CGRectMake(0, VIEW_Y_Bottom(headerView)-0.5, ScreenWidth, 0.5f)];
    [headerView addSubview:line2];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"ExpensesInfoCell";
    ExpensesInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ExpensesInfoCell alloc] init];
    }
    
    ExpensesMonthDataModel * monthModel = _dataList[indexPath.section];
    ExpensesInfoModel      * infoModel  = monthModel.dataArr[indexPath.row];
    
    [cell loadData:infoModel];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpensesMonthDataModel * monthModel = _dataList[indexPath.section];
    ExpensesInfoModel      * infoModel  = monthModel.dataArr[indexPath.row];
    ExpensesDetailVC * vc = [[ExpensesDetailVC alloc] initWithNibName:@"ExpensesDetailVC" bundle:nil];
    vc.expenseInfoModel = infoModel;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
