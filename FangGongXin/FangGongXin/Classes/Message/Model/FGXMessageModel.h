//
//  FGXMessageModel.h
//  FangGongXin
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGXMessageModel : NSObject

@property (nonatomic ,strong) NSString *headIcon;
@property (nonatomic ,strong) NSString *nickName;
@property (nonatomic ,strong) NSString *time;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *count;
@property (nonatomic ,strong) NSString *userId;

@end
