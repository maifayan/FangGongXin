//
//  FGXTabBarController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXTabBarController.h"

@interface FGXTabBarController ()

@end

@implementation FGXTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [MainStoryboard instantiateViewControllerWithIdentifier: NSStringFromClass([FGXTabBarController class])];
    }
    return self;
}

+ (instancetype)FGXWithTabBarController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *selColor = [UIColor colorWithRed: 0
                                        green: 190 / 255.0
                                         blue: 12 / 255.0
                                        alpha: 1];
    for (UINavigationController *nav in self.childViewControllers) {
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selColor}
                                      forState: UIControlStateSelected];
    }
    
    self.tabBar.tintColor = selColor;
    
    
}

@end
