//
//  MessageDetailViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MJRefresh.h"
#import "FHQNetWorkingAPI.h"

@interface MessageDetailViewController ()
{
    UIScrollView *_scrollView;
    UILabel *_contentLabel;
    UILabel *_dateLabel;
    UIView *_bottomView;
}
@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidView {
    
    self.titleLabel.text = @"消息中心";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64)];
    [self.view addSubview:_scrollView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 100)];
    topView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [_scrollView addSubview:topView];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainWidth - 20, 20)];
//    titleLabel.font = [UIFont systemFontOfSize:LagerFontSize];
//    titleLabel.textColor = DeepGrey;
//    titleLabel.text = _message.title;
//    [topView addSubview:titleLabel];
    
//    titleLabel.frame = [Tools labelForString:titleLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainWidth - 20, 20)];
    _dateLabel.text = _message.date;
    _dateLabel.textColor = MiddleGrey;
    _dateLabel.font = [UIFont systemFontOfSize:SmallFontSize];
    [topView addSubview:_dateLabel];
    
    [topView changeFrameHeight:CGRectGetMaxY(_dateLabel.frame) + 10];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), MainWidth, 100)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bottomView];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(topView.frame) + 20, MainWidth - 30, 100)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _contentLabel.textColor = DeepGrey;
    _contentLabel.backgroundColor = [UIColor whiteColor];
    _contentLabel.text = _message.content;
    [_scrollView addSubview:_contentLabel];
    
    _contentLabel.frame = [Tools labelForString:_contentLabel];
    
    _scrollView.contentSize = CGSizeMake(MainWidth, CGRectGetMaxY(_contentLabel.frame) + 10);
    
    [_bottomView changeFrameHeight:CGRectGetMaxY(_contentLabel.frame) + ScreenHeight];
    
    if (nil != self.messageId) {
        [self getMessgaeDetailWithId:self.messageId];
    }else if (nil != self.message){
        [self getMessgaeDetail:_message];

    }
}

- (void)getMessgaeDetailWithId:(NSString*)messageId {
    
    NSDictionary *requsetData = @{@"MessageId"  : messageId,
                                  @"Version"    : APIVersion};
    
    [FHQNetWorkingAPI getMessageDetail:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        CLog(@"%@",result);
        if (result) {
            _dateLabel.text = [result getStringWithKey:@"PubDate"];
            _contentLabel.text = [result getStringWithKey:@"Content"];
            _contentLabel.frame = [Tools labelForString:_contentLabel];
            
            _scrollView.contentSize = CGSizeMake(MainWidth, CGRectGetMaxY(_contentLabel.frame) + 10);
            
            [_bottomView changeFrameHeight:CGRectGetMaxY(_contentLabel.frame) + ScreenHeight];
        }
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

- (void)getMessgaeDetail:(MessageModel*)message {
    
    NSDictionary *requsetData = @{@"MessageId"  : message.messageId,
                                  @"Version"    : APIVersion};
    
    [FHQNetWorkingAPI getMessageDetail:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        CLog(@"%@",result);
        if (result) {
            message.isRead = YES;
                message.content = [result getStringWithKey:@"Content"];
                message.date = [result getStringWithKey:@"PubDate"];
            _dateLabel.text = message.date;
            _contentLabel.text = message.content;
            _contentLabel.frame = [Tools labelForString:_contentLabel];
            
            _scrollView.contentSize = CGSizeMake(MainWidth, CGRectGetMaxY(_contentLabel.frame) + 10);
            
            [_bottomView changeFrameHeight:CGRectGetMaxY(_contentLabel.frame) + ScreenHeight];
        }
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

    




@end
