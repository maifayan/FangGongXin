//
//  FGXChatCell.h
//  FangGongXin
//
//  Created by Apple on 2017/9/30.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGXChatFrame;
@interface FGXChatCell : UITableViewCell

@property (nonatomic, strong) FGXChatFrame *chatFrame;

+ (instancetype)FGXCellWithTableView:(UITableView *)tableView;

@end
