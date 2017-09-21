//
//  FGXSettingController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXSettingController.h"
#import "FGXSettingCell.h"
#import "FGXSettingModel.h"
#import "FGXPersonalInfoController.h"
#import "FGXAboutController.h"

@interface FGXSettingController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *settingId = @"settingId";

@implementation FGXSettingController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    //数据
    [self dataDeal];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"FGXSettingCell" bundle:nil] forCellReuseIdentifier:settingId];
}

//数据处理
- (void)dataDeal{
    NSArray *deal = @[@"个人信息",@"关于我们"];
    for (int i = 0; i < deal.count; i++) {
        FGXSettingModel *model = [[FGXSettingModel alloc]init];
        model.title = deal[i];
        [self.dataArray addObject:model];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FGXSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingId forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleModel = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FGXPersonalInfoController *personalInfo = [[FGXPersonalInfoController alloc]init];
        [self.navigationController pushViewController:personalInfo animated:YES];
    }else{
        FGXAboutController *about = [[FGXAboutController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - Separator左边距离
- (void)viewDidLayoutSubviews{
    //处理cell分割线左边距离
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}
#pragma mark - 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray ;
}

@end
