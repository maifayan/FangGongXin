//
//  FGXPersonalInfoController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXPersonalInfoController.h"
#import "FGXPersonalInfoModel.h"
#import "FGXPersonalInfoCell.h"


@interface FGXPersonalInfoController ()

@property (nonatomic, strong) NSMutableArray *dataArray;


@end
static NSString *personalId = @"personalId";
@implementation FGXPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    //数据
    [self dataDeal];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"FGXPersonalInfoCell" bundle:nil] forCellReuseIdentifier:personalId];
}

//处理数据
- (void)dataDeal{
    NSArray *titleValue  = @[@"昵称",@"性别"];
    for (int i = 0; i < titleValue.count; i++) {
        FGXPersonalInfoModel *personalModel = [[FGXPersonalInfoModel alloc]init];
        personalModel.title = titleValue[i];
        [self.dataArray addObject:personalModel];
    }

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FGXPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalId" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.personalModel = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.detail.text = @"麦子熟了";
    }else{
        cell.detail.text = @"男";
    }
    
    return cell;
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
    return _dataArray;
}


@end
