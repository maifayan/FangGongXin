//
//  FGXRealNameAuthenticationController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXRealNameAuthenticationController.h"

@interface FGXRealNameAuthenticationController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *realName;
@property (weak, nonatomic) IBOutlet UITextField *cardNum;

@end

@implementation FGXRealNameAuthenticationController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewWillAppear:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    //头视图
    [self headerView];
    
}


- (void)headerView{
    UIView *headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    [headerV setBackgroundColor:[UIColor whiteColor]];
    self.tableView.tableHeaderView = headerV;
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 80)];
    [promptLabel setBackgroundColor:[UIColor colorWithRed:218 / 255.0 green:217 / 255.0 blue:218 / 255.0 alpha:1]];
    promptLabel.text = @"温馨提示: 为保障信息真实有效，在本平台发布或浏览房源，或接收委托过户任务，必须使用真实身份。";
    promptLabel.textColor     = [UIColor redColor];
    promptLabel.font          = [UIFont systemFontOfSize:14];
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.numberOfLines = 0;//表示label可以多行显示
    CGPoint promptCenter = promptLabel.center;
    promptCenter.x       = kScreenW / 2;
    promptCenter.y       = headerV.center.y;
    promptLabel.center   = promptCenter;
    
    [headerV addSubview:promptLabel];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.cardNum) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return textField;
}

@end
