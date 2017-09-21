//
//  FGXAboutController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/21.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXAboutController.h"

@interface FGXAboutController ()

@end

#define aboutUrl  @"http://www.fanggongxin.net/settings/about"

@implementation FGXAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    
    [self setUpWebView];

}

- (void)setUpWebView{
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:aboutUrl]]]];
    [self.view addSubview:webView];
}


@end
