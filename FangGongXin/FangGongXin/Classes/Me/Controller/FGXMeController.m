//
//  FGXMeController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXMeController.h"
#import "FGXSettingController.h"
#import "FGXContractController.h"
#import "FGXProcessController.h"

@interface FGXMeController ()

@end


@implementation FGXMeController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillAppear:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //头像
    [self headerView];
}

- (void)headerView{
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderViewH)];
        [headerV setBackgroundColor:[UIColor purpleColor]];
        self.tableView.tableHeaderView = headerV;
    
        //头像
        UIImageView *headImageView = [[UIImageView alloc]init];
        //禁用antoresizing
        headImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [headImageView setFrame:CGRectMake(0, 0, 80, 80)];
        [headImageView setImage:[UIImage imageNamed:@"setup-head-default.png"]];
    
        CGPoint headCenter = headImageView.center;
        headCenter.x = kScreenW / 2;
        headCenter.y = headerV.center.y - 5;
        headImageView.center = headCenter;
        //圆角
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius  = 40;
        headImageView.layer.borderWidth   = 5;
        headImageView.layer.borderColor   = [[UIColor whiteColor] CGColor];
    
        //用户名
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
        name.text = @"麦子熟了";
        name.font = [UIFont systemFontOfSize:17];
        name.textAlignment = NSTextAlignmentCenter;
        CGPoint nameCenter = headImageView.center;
        nameCenter.x = kScreenW / 2;
        nameCenter.y = headerV.center.y + 50;
        name.center  = nameCenter;
        
        //添加控件
        [headerV addSubview:headImageView];
        [headerV addSubview:name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            FGXSettingController *settingC = [[FGXSettingController alloc]init];
            [self.navigationController pushViewController:settingC animated:YES];
        }else if(indexPath.row == 2){
            FGXContractController *contractC = [[FGXContractController alloc]init];
            [self.navigationController pushViewController:contractC animated:YES];
        }else if(indexPath.row == 1){
            FGXProcessController *processC = [[FGXProcessController alloc]init];
            [self.navigationController pushViewController:processC animated:YES];
        }else if(indexPath.row == 0){
            
        }
    }else if (indexPath.section == 0){
        if (indexPath.row == 2) {
            
        }else if(indexPath.row == 1){
            
        }else if(indexPath.row == 0){
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

@end
