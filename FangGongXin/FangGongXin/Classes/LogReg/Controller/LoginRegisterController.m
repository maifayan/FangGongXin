//
//  LoginRegisterController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/19.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "LoginRegisterController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AFNetworking.h>


#define kMarginX     50
#define kMarginY     150
#define kLabelX      (kMarginX + 70)
#define kInputBoxW   ([UIScreen mainScreen].bounds.size.width - 80 * 2)
#define kInputBoxH   30

@interface LoginRegisterController ()

//注册
@property (nonatomic,strong) UIView      *RegisterView;//注册视图
@property (nonatomic,strong) UITextField *RegUserName;//用户名
@property (nonatomic,strong) UITextField *RegPassword;//密码


//登录
@property (nonatomic,strong) UIView      *LoginView;//登录视图
@property (nonatomic,strong) UITextField *LogUserName;//用户名
@property (nonatomic,strong) UITextField *LogPassword;//密码



@end

@implementation LoginRegisterController

-(void)viewDidLoad{
    [super viewDidLoad];
    //注册
    [self registerFongGongXin];
    //登录
    [self LoginFangGongXin];
    //微信授权登录
    [self WXLogin];
}

#pragma mark - 微信登录
- (void)WXLogin{
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 80, 500, 120, 30)];
    otherLabel.text = @"其他登录方式";
    [self.view addSubview:otherLabel];
    UIButton *WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [WXButton setFrame:CGRectMake(kMarginX, 530, kInputBoxW + 70, 30)];
    [WXButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [WXButton setFont:[UIFont systemFontOfSize:14]];
    [WXButton setBackgroundColor:[UIColor greenColor]];
    [WXButton addTarget:self action:@selector(getAuthWithUserInfoFromWechat) forControlEvents:UIControlEventTouchUpInside];
    [WXButton.layer setCornerRadius:9];
    
    [self.view addSubview:WXButton];
    
}
#pragma mark - 微信登录获取用户信息
- (void)getAuthWithUserInfoFromWechat
{
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            
            [mgr POST:@"http://192.168.0.120:8081/user/pre-sign-up" parameters:resp.originalResponse progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSMutableDictionary *responDic = [NSMutableDictionary dictionary];
                responDic = responseObject[@"data"];
                NSLog(@"responDic =%@",responDic);
//                [[NSUserDefaults standardUserDefaults] setObject:responDic[@"openId"]      forKey:XM_openid];
//                NSString *openStr = [[NSUserDefaults standardUserDefaults] objectForKey:XM_openid];
//                NSLog(@"%@",openStr);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"不返回数据扣2222222");
                NSLog(@"后台数据返回错误: %@",error);
            }];
            
            
//            //获取userDefault单例
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            //登陆成功后把用户名和密码存储到UserDefault
//            [userDefaults setObject:resp.uid          forKey:XM_uid];
//            //            [userDefaults setObject:resp.openid       forKey:XM_openid];
//            //            NSString *openStr = [userDefaults objectForKey:XM_openid];
//            //            NSLog(@"%@",openStr);
//            [userDefaults setObject:resp.accessToken  forKey:XM_accessToken];
//            [userDefaults setObject:resp.refreshToken forKey:XM_refreshToken];
//            [userDefaults setObject:resp.name         forKey:XM_userName];
//            [userDefaults setObject:resp.iconurl      forKey:XM_iconurl];
//            [userDefaults setObject:resp.gender       forKey:XM_gender];
//            [userDefaults synchronize];
            
            
        }
    }];
}

#pragma mark - 注册
- (void)registerFongGongXin{
    _RegisterView = [[UIView alloc]initWithFrame:self.view.frame];
    [_RegisterView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_RegisterView];
    
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginX, kMarginY, 100, 30)];
    userLabel.text = @"用户名:";
    [_RegisterView addSubview:userLabel];
    //密码
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginX, kMarginY + 50, 100, 30)];
    passwordLabel.text = @"密    码:";
    [_RegisterView addSubview:passwordLabel];
    
    //用户名
    _RegUserName = [[UITextField alloc]initWithFrame:CGRectMake(kLabelX , kMarginY, kInputBoxW, kInputBoxH)];
    _RegUserName.borderStyle = UITextBorderStyleRoundedRect;
    [_RegisterView addSubview:_RegUserName];
    
    //密码
    _RegPassword = [[UITextField alloc]initWithFrame:CGRectMake(kLabelX, kMarginY + 50, kInputBoxW, kInputBoxH)];
    _RegPassword.borderStyle = UITextBorderStyleRoundedRect;
    _RegPassword.secureTextEntry = YES;
    [_RegisterView addSubview:_RegPassword];
    
    //跳转注册
    UIButton *regJump = [UIButton buttonWithType:UIButtonTypeCustom];
    [regJump setTitle:@"已有账号" forState:UIControlStateNormal];
    [regJump setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [regJump setFrame:CGRectMake(250, 100, 100, 40)];
    [regJump addTarget:self action:@selector(exchangeSubview) forControlEvents:UIControlEventTouchUpInside];
    [_RegisterView addSubview:regJump];
    
    //立即注册
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(kMarginX,kMarginY + 40 + kInputBoxH * 2, kInputBoxW + 70, 30)];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton setFont:[UIFont systemFontOfSize:14]];
    [registerButton setBackgroundColor:[UIColor blueColor]];
    [registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton.layer setCornerRadius:9];

    [_RegisterView addSubview:registerButton];

}

#pragma mark - 登录
- (void)LoginFangGongXin{
    //登录视图
    _LoginView = [[UIView alloc]initWithFrame:self.view.frame];
    [_LoginView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_LoginView];
    
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginX, kMarginY, 100, 30)];
    userLabel.text = @"用户名:";
    [_LoginView addSubview:userLabel];
    //密码
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMarginX, kMarginY + 50, 100, 30)];
    passwordLabel.text = @"密    码:";
    [_LoginView addSubview:passwordLabel];
    
    //用户名
    _LogUserName = [[UITextField alloc]initWithFrame:CGRectMake(kLabelX , kMarginY, kInputBoxW, kInputBoxH)];
    _LogUserName.borderStyle = UITextBorderStyleRoundedRect;
    
    [_LoginView addSubview:_LogUserName];
    //密码
    _LogPassword = [[UITextField alloc]initWithFrame:CGRectMake(kLabelX, kMarginY + 50, kInputBoxW, kInputBoxH)];
    _LogPassword.borderStyle = UITextBorderStyleRoundedRect;
    
    _LogPassword.secureTextEntry = YES;
    [_LoginView addSubview:_LogPassword];
    
    //跳转登录
    UIButton *loginJump = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginJump setTitle:@"注册账号" forState:UIControlStateNormal];
    [loginJump setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginJump setFrame:CGRectMake(250, 100, 100, 40)];
    [loginJump addTarget:self action:@selector(exchangeSubview) forControlEvents:UIControlEventTouchUpInside];
    [_LoginView addSubview:loginJump];
    //立即登录
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor orangeColor]];
    [loginButton setFrame:CGRectMake(kMarginX,kMarginY + 40 + kInputBoxH * 2, kInputBoxW + 70, 30)];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton.layer setCornerRadius:9];
    
    [_LoginView addSubview:loginButton];
    
    //忘记密码
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetButton setFrame:CGRectMake(250, kMarginY + 40 + kInputBoxH * 2 + 40, 100, 40)];
    [forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [_LoginView addSubview:forgetButton];
    
}
//register
- (void)registerClick{
    
}

//login
- (void)loginClick{
}

//forget
- (void)forgetClick{
    
}
#pragma mark - 翻转界面
- (void)exchangeSubview{
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView commitAnimations];
    
}



@end
