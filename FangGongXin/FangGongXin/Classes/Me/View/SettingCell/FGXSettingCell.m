//
//  FGXSettingCell.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXSettingCell.h"
#import "FGXSettingModel.h"
@interface FGXSettingCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation FGXSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (void)setTitleModel:(FGXSettingModel *)titleModel{
    _titleModel = titleModel;
    self.title.text  = titleModel.title;
}



@end
