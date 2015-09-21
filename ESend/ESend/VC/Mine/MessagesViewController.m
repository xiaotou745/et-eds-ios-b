//
//  MessagesViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageModel.h"
#import "MessagesTableViewCell.h"
#import "MessageDetailViewController.h"
#import "MJRefresh.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "EmptyAlterView.h"

@interface MessagesViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSMutableArray *_messageList;
    NSInteger _page;
    
    EmptyAlterView *_emptyAlertView;
}

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)initializeData {
    _messageList = [NSMutableArray array];
}

- (void)bulidView {
    
    self.titleLabel.text = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MessagesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MessagesTableViewCell class])];
    [self.view addSubview:_tableView];
    
    // addLegendHeaderWithRefreshingTarget
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

//    _tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [_tableView.header beginRefreshing];
    
    _emptyAlertView = [[EmptyAlterView alloc] initWithMessage:@"暂时没有收到消息"];
    _emptyAlertView.hidden = YES;
    [_tableView addSubview:_emptyAlertView];
}

- (void)refreshData {
    
    _page = 1;
    
    NSDictionary *requsetData = @{@"version"    : APIVersion,
                                  @"BusinessId" : [UserInfo getUserId],
                                  @"PageIndex"  : @(_page)
                                  };
    
    [FHQNetWorkingAPI getMessageList:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        [_messageList removeAllObjects];
        for (NSDictionary *data in result) {
            MessageModel *message = [[MessageModel alloc] initWithDic:data];
            message.title = [data getStringWithKey:@"Content"];
            [_messageList addObject:message];
        }
        [_tableView.header endRefreshing];
        [_tableView reloadData];
        
        if (_messageList.count == 0) {
            _emptyAlertView.hidden = NO;
        } else {
            _emptyAlertView.hidden = YES;
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [_tableView.header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    _page++;
    
    NSDictionary *requsetData = @{@"version" : APIVersion,
                                  @"BusinessId" : [UserInfo getUserId],
                                  @"PageIndex"  : @(_page)
                                  };
    
    [FHQNetWorkingAPI getMessageList:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        for (NSDictionary *data in result) {
            MessageModel *message = [[MessageModel alloc] initWithDic:data];
            message.title = [data getStringWithKey:@"Content"];
            [_messageList addObject:message];
        }
        [_tableView reloadData];
        
        if ([result count] == 0) {
            _page--;
        }
         [_tableView.footer endRefreshing];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        _page--;
        [_tableView.footer endRefreshing];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _messageList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessagesTableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    MessageModel *message = _messageList[indexPath.section];
    [cell loadData:message];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *message = [_messageList objectAtIndex:indexPath.section];
    [self getMessgaeDetail:message];


}

- (void)getMessgaeDetail:(MessageModel*)message {
    
    message.isRead = YES;
    MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
    vc.message = message;
    [_tableView reloadData];
    [self.navigationController pushViewController:vc animated:YES];


}

@end
