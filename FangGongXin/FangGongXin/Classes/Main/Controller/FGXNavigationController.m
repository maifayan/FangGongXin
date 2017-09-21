//
//  FGXNavigationController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXNavigationController.h"

@interface FGXNavigationController ()<UIGestureRecognizerDelegate>

//返回
@property (nonatomic,strong)UIBarButtonItem *backItem;
//关闭
@property (nonatomic,strong)UIBarButtonItem *closeItem;

@end

@implementation FGXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 微信的navBar颜色不是黑色,具体颜色再看
    [self.navigationBar setBackgroundColor: [UIColor purpleColor]];
    // 修改标题颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    // 修改左右UIBarButtonItem主题色
    self.navigationBar.tintColor = [UIColor blackColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:nil];
    
    
    [self.view addGestureRecognizer:pan];
    // 控制手势什么时候触发,只有非根控制器才需要触发手势
    pan.delegate = self;
    //禁止之前手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
}

// 修改状态栏格式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIGestureRecognizerDelegate
//决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return self.childViewControllers.count > 1;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {//非根控制器
        
        //隐藏底部标签栏
        viewController.hidesBottomBarWhenPushed = YES;
        
        viewController.navigationItem.leftBarButtonItem = self.backItem;
        
    }
    //真正的跳转
    [super pushViewController:viewController animated:animated];
}

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc]init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"navigationButtonReturn"];
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [button sizeToFit];
        //左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //让返回按钮内容继续向左边偏移15，如果不设置的话，就会发现返回按钮离屏幕的左边的距离有点儿大，不美观
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        button.frame = CGRectMake(0, 0, 40, 40);
        _backItem.customView = button;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
        [_closeItem setTintColor:[UIColor blackColor]];
    }
    
    return _closeItem;
}
/*
 
 
 */
- (void)backNative{
    
    //判断是否有上一层H5页面
    if ([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        self.navigationItem.leftBarButtonItems = @[self.backItem,self.closeItem];
    }else{
        [self closeNative];
    }
}

//关闭H5页面，直接回到原生页面
- (void)closeNative{
    [self popViewControllerAnimated:NO];
}


@end
