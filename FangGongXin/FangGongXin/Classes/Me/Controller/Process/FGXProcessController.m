//
//  FGXProcessController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXProcessController.h"

@interface FGXProcessController ()

@end
#define processUrl  @"http://www.fanggongxin.net/manual-trade"

@implementation FGXProcessController

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    [super viewDidAppear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"交易流程";
    
    [self setUpWebView];
    
}

- (void)setUpWebView{
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:processUrl]]]];
    [self.view addSubview:webView];
}

@end
