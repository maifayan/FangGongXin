//
//  FGXContractController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXContractController.h"

@interface FGXContractController ()

@end
#define contractUrl  @"http://www.fanggongxin.net/manual-contract"


@implementation FGXContractController

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

    [super viewDidAppear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"合同范本";
    
    [self setUpWebView];
    
}

- (void)setUpWebView{
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:contractUrl]]]];
    [self.view addSubview:webView];
}

@end
