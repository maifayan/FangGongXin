//
//  FGXPersonalInfoCell.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXPersonalInfoCell.h"
#import "FGXPersonalInfoModel.h"
@interface FGXPersonalInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation FGXPersonalInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setPersonalModel:(FGXPersonalInfoModel *)personalModel{
    _personalModel   = personalModel;
    self.title.text  = personalModel.title;
    self.detail.text = personalModel.detail;
    
}


@end
