//
//  FGXChat.h
//  FangGongXin
//
//  Created by Apple on 2017/9/30.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGXChat : NSObject
/** 聊天消息对象 */
@property (nonatomic, strong) NSMutableDictionary *mesag;
/** 文字聊天内容 */
@property (nonatomic, copy, readonly) NSString *contentText;


/** 头像urlStr */
@property (nonatomic, copy, readonly) NSString *userIcon;

/** nickeStr */
@property (nonatomic, copy, readonly) NSString *nickName;

/** timeStr */
@property (nonatomic, copy, readonly) NSString *timeStr;

/** 是我还是他 */
@property (nonatomic, assign, getter=isMe, readonly) BOOL me;

@end
