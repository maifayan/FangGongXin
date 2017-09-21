//
//  FGXHomeController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXHomeController.h"

@interface FGXHomeController ()

@end

@implementation FGXHomeController


+ (instancetype)FGXWithHomeController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
}



@end
