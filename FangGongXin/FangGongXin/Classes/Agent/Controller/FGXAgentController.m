//
//  FGXAgentController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/28.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXAgentController.h"

@interface FGXAgentController ()

@end

@implementation FGXAgentController

+ (instancetype)FGXWithAgentController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.title = @"经纪人";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/



@end
