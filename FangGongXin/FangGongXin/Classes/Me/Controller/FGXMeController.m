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

#import "FGXRealNameAuthenticationController.h"

@interface FGXMeController ()
@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@end


@implementation FGXMeController


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillAppear:YES];
    
}
+ (instancetype)FGXWithMeController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headView setImage:[UIImage imageNamed:@"setup-head-default.png"]];
    self.nickName.text = @"麦子熟了";
    
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
            UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"realName" bundle:nil];
            FGXRealNameAuthenticationController *realNameC = [storyB instantiateViewControllerWithIdentifier:@"FGXRealNameAuthenticationController"];
            [self.navigationController pushViewController:realNameC animated:YES];
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
