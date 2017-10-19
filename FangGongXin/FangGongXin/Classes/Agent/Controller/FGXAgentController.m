//
//  FGXAgentController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/28.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXAgentController.h"
#import "FGXAgentModel.h"
#import "FGXAgentCell.h"
#import "FGXChatController.h"

@interface FGXAgentController ()<UISearchResultsUpdating>

//搜索框
@property (nonatomic, strong) UISearchController *searchController;
//搜索数据源
@property (nonatomic, strong) NSMutableArray     *searchList;

//model
@property (nonatomic ,strong) FGXAgentModel  *agentModel;
//数据源
@property (nonatomic ,strong) NSMutableArray *agentArray;


@end

@implementation FGXAgentController

+ (instancetype)FGXWithAgentController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.searchController.active) {
                self.searchController.active = NO;
                [self.searchController.searchBar removeFromSuperview];
            }
            [self.searchController dismissViewControllerAnimated:YES completion:^{
            }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"经纪人";
    //获取数据
    [self getAgentData];

}


#pragma mark - Data
- (void)getAgentData{
    /*
     responseObject === >{
     data =     (
     {
     userWx =             {
     
     createdAt = 1505453863000;时间
     headImageUrl = "http://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTIrDxpnFoIlFFWrib0jJlA91L1mHHGWUQLFrRQKhvia06W9jV3hftfc6mKNLER3mKEMxK4j6WLwDYvQ/0";
     nickname = "\U6930\U5b50.Zz";
     openid = "oL50Ywa-fQnHv2KVx4EyDVwJn1I8";
     updatedAt = 1505453863000;
     userId = "203c4264-d1a5-4ceb-aeb1-32802091b64f";
     };
     }
     );
     
     }
     */
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSString *urlStr = [NSString stringWithFormat:@"%@agent/list",chatUrl];
    [mgr POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject === >%@",responseObject);
        NSMutableArray *dataArray = [NSMutableArray array];
        dataArray = responseObject[@"data"];
        NSMutableDictionary *responDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < dataArray.count; i++) {
            [responDic setDictionary:dataArray[i]];
            NSString *idStr = [[NSUserDefaults standardUserDefaults] valueForKey:FromId];
            if (idStr &&![responDic[@"userWx"][@"userId"] isEqualToString:idStr]) {
                _agentModel = [[FGXAgentModel alloc]init];
                _agentModel.headimg  = responDic[@"userWx"][@"headImageUrl"];
                _agentModel.nickname = responDic[@"userWx"][@"nickname"];
                _agentModel.userId   = responDic[@"userWx"][@"userId"];
                [self.agentArray addObject:_agentModel];

            }
        }
        //刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *inputStr = searchController.searchBar.text;
    if (self.searchList.count > 0) {
        [self.searchList removeAllObjects];
    }
    
    for (FGXAgentModel *listModel in self.agentArray) {
        NSString *str  = listModel.nickname;
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            
            [self.searchList addObject:listModel];
        }
        
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        return self.searchList.count;
    }
    return self.agentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FGXAgentCell *cell = [FGXAgentCell agentCellWithTableView:tableView];
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        cell.agentModel     =     self.searchList[indexPath.row];
    }else{
        cell.agentModel     =  self.agentArray[indexPath.row];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"详情");
    FGXAgentCell *cell = [tableView cellForRowAtIndexPath:indexPath];// 获取cell 对象
    //对方
    [[NSUserDefaults standardUserDefaults] setObject:cell.userId forKey:@"cellID"];
    [[NSUserDefaults standardUserDefaults] setObject:cell.headUrl  forKey:@"cellHeadimg"];
    [[NSUserDefaults standardUserDefaults] setObject:cell.nickName.text forKey:@"cellNickname"];
    
}

//头像点击
- (void)headBtnClick:(UIButton *)button{
    CGPoint point = [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:point];
    FGXAgentCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    //对方
    [[NSUserDefaults standardUserDefaults] setObject:cell.userId        forKey:ToId];
    [[NSUserDefaults standardUserDefaults] setObject:cell.headUrl       forKey:ToImage];
    [[NSUserDefaults standardUserDefaults] setObject:cell.nickName.text forKey:ToName];
    FGXChatController *chatVC = [[FGXChatController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)viewDidLayoutSubviews{
    //处理cell分割线左边距离
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }


}


#pragma mark - 懒加载

- (NSMutableArray *)agentArray
{
    if (!_agentArray) {
        _agentArray = [NSMutableArray array];
    }
    return _agentArray;
}

- (NSMutableArray *)searchList{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (UISearchController *)searchController{
    if (!_searchController) {
        // 创建UISearchController, 这里使用当前控制器来展示结果
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        // 设置结果更新代理
        _searchController.searchResultsUpdater = self;
        // 因为在当前控制器展示结果, 所以不需要这个透明视图
        _searchController.dimsBackgroundDuringPresentation = NO;
        // 将searchBar赋值给tableView的tableHeaderView
        self.tableView.tableHeaderView = _searchController.searchBar;
        _searchController.searchBar.placeholder = @"经纪人 微信昵称/电话";

    }
    return _searchController;
}

@end
