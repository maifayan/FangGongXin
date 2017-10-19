//
//  FGXMessageController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/28.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXMessageController.h"
#import "FGXMessageCell.h"
#import "FGXMessageModel.h"
#import "FGXChatController.h"
#import "NSString+YFTimestamp.h"
#import "FMDB.h"

@interface FGXMessageController ()

@property (nonatomic ,strong) NSMutableArray *messageArr;

@property (nonatomic, strong) FMDatabase     *database;

@end

@implementation FGXMessageController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.messageArr removeAllObjects];
    [self getMessageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会话列表";
    
//    [self query];
}

#pragma mark - Data
- (void)getMessageData{
    /*
     headImageUrl = "http://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIrDxpnFoIlFFWrib0jJlA91L1mHHGWUQLFrRQKhvia06W9jV3hftfc6mKNLER3mKEMxK4j6WLwDYvQ/0";
     
     nickname = "\U6930\U5b50.Zz";
     
     userId = "203c4264-d1a5-4ceb-aeb1-32802091b64f";
     };
     }
     */
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString  *urlStr = [NSString stringWithFormat:@"%@message/chat-list",chatUrl];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"id"] = [[NSUserDefaults standardUserDefaults] valueForKey:FromId];
    
    [mgr POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject === >%@",responseObject);
        NSMutableArray *dataArray = [NSMutableArray array];
        dataArray = responseObject[@"data"];
        NSMutableDictionary *responDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < dataArray.count; i++) {
            [responDic setDictionary:dataArray[i]];
            FGXMessageModel *messageModel = [[FGXMessageModel alloc]init];
            messageModel.headIcon = responDic[@"userWx"][@"headImageUrl"];
            messageModel.nickName = responDic[@"userWx"][@"nickname"];
            messageModel.userId   = responDic[@"userWx"][@"userId"];
            messageModel.content  = responDic[@"message"][@"content"];
            messageModel.time     = [NSString yf_convastionTimeStr:[responDic[@"message"][@"timeStamp"] longLongValue]];
            messageModel.count    = [responDic[@"count"] stringValue];
            FGXChatController *chat = [[FGXChatController alloc]init];

            messageModel.content  =  chat.dataDic[@"content"];
            
            [self.messageArr addObject:messageModel];
        }
        //刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

////聊天记录
//- (void)query {
//    [self.database open];
//    
//    // 1.执行查询语句
//    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM compontentStr"];
//    // 2.遍历结果
//    NSMutableDictionary *resultDic = (NSMutableDictionary *)resultSet;
//    
//    while ([resultSet next]) {
//        FGXMessageModel *meModel = [[FGXMessageModel alloc]init];
//        
//        
//        meModel.content  = [resultSet stringForColumn:@"content"];
//        
//        NSLog(@"%@",meModel.content);
//    }
//    
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FGXMessageCell  *cell = [FGXMessageCell messageCellWithTableView:tableView];
    cell.messageModel     = self.messageArr[indexPath.row];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    return cell;
   
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *markAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标为中介" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"标为中介");
    }];
    UITableViewRowAction *entrustAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"委托过户" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"委托过户");
    }];
    entrustAction.backgroundColor = [UIColor colorWithRed:119 / 255.0  green:91 / 255.0 blue:189 / 255.0 alpha:1];
    markAction.backgroundColor  = [UIColor colorWithRed:143 / 255.0 green:119 / 255.0 blue:199 / 255.0 alpha:1];
    return @[entrustAction,markAction];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleNone;
}
#pragma mark - 懒加载
- (NSMutableArray *)messageArr{
    if (!_messageArr) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
}

@end
