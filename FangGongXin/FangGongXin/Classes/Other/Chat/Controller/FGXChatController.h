//
//  FGXChatController.h
//  FangGongXin
//
//  Created by Apple on 2017/9/29.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^messageBlock)(NSString *, NSString * ,NSString *);
@interface FGXChatController : UIViewController

@property (nonatomic, strong) messageBlock megBlock;
@property (nonatomic, copy, readonly)   NSMutableDictionary   *dataDic;

@end
