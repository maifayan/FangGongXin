//
//  FGXChat.m
//  FangGongXin
//
//  Created by Apple on 2017/9/30.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXChat.h"
#import "NSString+YFTimestamp.h"


@interface FGXChat ()

/** 文字聊天内容 */
@property (nonatomic, copy) NSString *contentText;

/** 头像urlStr */
@property (nonatomic, copy) NSString *userIcon;

/** nickeStr */
@property (nonatomic, copy) NSString *nickName;

/** timeStr */
@property (nonatomic, copy) NSString *timeStr;

/** 是我还是他 */
@property (nonatomic, assign, getter=isMe) BOOL me;

@end

@implementation FGXChat


- (void)setMesag:(NSMutableDictionary *)mesag{
    _mesag = mesag;
    //用户ID
    NSString *loginUser = [[NSUserDefaults standardUserDefaults] valueForKey:FromId];
    if ([loginUser isEqualToString:mesag[@"fromUser"]]) {
        self.me = YES;
        self.userIcon = [[NSUserDefaults standardUserDefaults] valueForKey:FromImage];
        self.nickName = [[NSUserDefaults standardUserDefaults]valueForKey:FromName];
        
    }else {
        self.me = NO;
        self.userIcon = [[NSUserDefaults standardUserDefaults]valueForKey:ToImage];
        self.nickName = [[NSUserDefaults standardUserDefaults]valueForKey:ToName];
       
    }
    
        self.timeStr = [NSString yf_convastionTimeStr:[mesag[@"timeStamp"] longLongValue]];
        // 解析消息内容
        self.contentText = mesag[@"content"];
    
    
}


@end
