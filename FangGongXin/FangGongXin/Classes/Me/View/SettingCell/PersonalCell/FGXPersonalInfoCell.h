//
//  FGXPersonalInfoCell.h
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  FGXPersonalInfoModel;
@interface FGXPersonalInfoCell : UITableViewCell
@property (nonatomic, strong) FGXPersonalInfoModel *personalModel;

@property (weak, nonatomic) IBOutlet UILabel *detail;


@end
