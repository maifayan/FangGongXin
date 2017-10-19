//
//  FGXMessageCell.m
//  FangGongXin
//
//  Created by Apple on 2017/10/12.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXMessageCell.h"
#import "FGXMessageModel.h"


@implementation FGXMessageCell

+ (instancetype)messageCellWithTableView:(UITableView *)tableView{
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
    [super awakeFromNib];
}

- (void)setMessageModel:(FGXMessageModel *)messageModel{
    _messageModel = messageModel;
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",messageModel.headIcon]];
    NSData *headData = [NSData dataWithContentsOfURL:headUrl];
    self.headIcon.image = [UIImage imageWithData:headData];
    self.nickName.text = messageModel.nickName;
    self.content.text  = messageModel.content;
    self.time.text     = messageModel.time;
    self.count.text    = messageModel.count;
}

@end
