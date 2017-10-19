//
//  FGXTermsController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/27.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXTermsController.h"

@interface FGXTermsController ()

@end

@implementation FGXTermsController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mob.fangqinhui.com/html/broker/userAgreement.html"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
}



@end
