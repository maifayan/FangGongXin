//
//  FGXAgentCell.m
//  FangGongXin
//
//  Created by Apple on 2017/9/28.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXAgentCell.h"
#import "FGXAgentModel.h"


@interface FGXAgentCell ()


@end

@implementation FGXAgentCell

+ (instancetype)agentCellWithTableView:(UITableView *)tableView{
    static NSString *ID = nil;
    if (!ID) {
        ID = [NSString stringWithFormat:@"%@ID",NSStringFromClass(self)];
    }
    static UITableView *tableV = nil;
    if (![tableView isEqual:tableV]) {
        // 如果使用的是不同的tableView,那就更新缓存池对应的tableV
        tableV = tableView;
    }
    id cell = [tableV dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    
    return cell;
}


- (void)awakeFromNib {
    //圆角
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.cornerRadius  = 25;
    _headBtn.layer.borderWidth   = 1;
    _headBtn.layer.borderColor   = [[UIColor whiteColor] CGColor];
    [super awakeFromNib];
}


- (void)setAgentModel:(FGXAgentModel *)agentModel{
    _agentModel = agentModel;
    
    self.headUrl = [NSString stringWithFormat:@"%@",agentModel.headimg];
    NSURL  *imageUrl =  [NSURL URLWithString:self.headUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    [self.headBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    self.nickName.text  = agentModel.nickname;
    self.userId         = agentModel.userId;

}



- (IBAction)entrust:(id)sender {
    NSLog(@"委托过户");
}



@end
