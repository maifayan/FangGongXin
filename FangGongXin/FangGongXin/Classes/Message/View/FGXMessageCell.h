//
//  FGXMessageCell.h
//  FangGongXin
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGXMessageModel;
@interface FGXMessageCell : UITableViewCell
@property (nonatomic ,strong) FGXMessageModel *messageModel;

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel   *nickName;
@property (weak, nonatomic) IBOutlet UILabel   *time;
@property (weak, nonatomic) IBOutlet UILabel   *content;
@property (nonatomic, strong)        NSString  *userId;

@property (weak, nonatomic) IBOutlet UILabel *count;
+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@end
