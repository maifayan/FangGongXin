//
//  FGXAgentCell.h
//  FangGongXin
//
//  Created by Apple on 2017/9/28.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGXAgentModel;
@interface FGXAgentCell : UITableViewCell
@property (nonatomic, strong) FGXAgentModel *agentModel;

@property (nonatomic, strong) NSString  *userId;

@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

//因为按钮头像很难获取到，所以专门存储一个属性获取；
@property (nonatomic, strong) NSString *headUrl;

+ (instancetype)agentCellWithTableView:(UITableView *)tableView;


@end
