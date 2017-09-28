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

#import "FGXTermsController.h"
#import "FGXTabBarController.h"

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
@property (nonatomic,strong) UIButton    *registerButton;//按钮


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
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 47, 450, 120, 30)];
    otherLabel.text = @"其他登录方式";
    [self.LoginView addSubview:otherLabel];
    UIButton *WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [WXButton setFrame:CGRectMake(kMarginX, 480, kInputBoxW + 70, 30)];
    [WXButton setTitle:@"微信登录" forState:UIControlStateNormal];
    [WXButton setBackgroundColor:[UIColor greenColor]];
    [WXButton addTarget:self action:@selector(getAuthWithUserInfoFromWechat) forControlEvents:UIControlEventTouchUpInside];
    [WXButton.layer setCornerRadius:9];
    
    [self.LoginView addSubview:WXButton];
    
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
            // 授权信息
//            NSLog(@"Wechat uid: %@", resp.uid);
//            NSLog(@"Wechat openid: %@", resp.openid);
//            NSLog(@"Wechat accessToken: %@", resp.accessToken);
//            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            [mgr POST:@"http://192.168.0.114:8081/user/pre-sign-up" parameters:resp.originalResponse progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSMutableDictionary *responDic = [NSMutableDictionary dictionary];
                responDic = responseObject[@"data"];
//                NSLog(@"responDic =%@",responDic);
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:responDic[@"token"] forKey:FromToken];
                [userDefaults setObject:responDic[@"userInfoWrapper"][@"userWx"][@"openid"]      forKey:FromOpenid];
                [userDefaults setObject:responDic[@"userInfoWrapper"][@"userWx"][@"userId"]      forKey:FromId];
                [userDefaults setObject:responDic[@"userInfoWrapper"][@"userWx"][@"nickname"]      forKey:FromName];
                [userDefaults setObject:responDic[@"userInfoWrapper"][@"userWx"][@"headImageUrl"]      forKey:FromImage];
                [userDefaults synchronize];
                
                // 2.切换根控制器为: tabVc
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [FGXTabBarController FGXWithTabBarController];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"不返回数据扣2222222");
                NSLog(@"后台数据返回错误: %@",error);
            }];
            
            /*
             responDic ={
             userInfoWrapper = {
                 userWx =         {
                 headImageUrl = "http://wx.qlogo.cn/mmopen/vi_32/wic3CVWepfNb6qfsMIgccsDmz2dKXkQMvmyukX9CAdaA5osTchaF7yLho7HZZR4LnILNW1icdB02q90XuGK9icMdQ/0";
                 nickname = "\U9ea6\U5b50\U719f\U4e86";
                 openid = "o2NRg00J1id_ijYHCk656gvAv-NQ";
                 userId = "94de4fae-e00c-4ef8-b0d6-c54f2237dee1";
                 };
             };
             }
             */
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
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setFrame:CGRectMake(kMarginX,kMarginY + 40 + kInputBoxH * 2, kInputBoxW + 70, 30)];
    [_registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerButton setBackgroundColor:[UIColor grayColor]];
    [_registerButton.layer setCornerRadius:9];
    [_RegisterView addSubview:_registerButton];
    
    
    //勾选按钮
    UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBox setFrame:CGRectMake(kMarginX , kMarginY + 80 + kInputBoxH * 2, 20, 20)];
    [checkBox setImage:[UIImage imageNamed:@"icon_ CheckBox"] forState:UIControlStateNormal];
    [checkBox setImage:[UIImage imageNamed:@"icon_ CheckBox_selectd"] forState:UIControlStateSelected];
    [checkBox addTarget:self action:@selector(checkBoxSelectd:) forControlEvents:UIControlEventTouchUpInside];
    checkBox.backgroundColor = [UIColor clearColor];
    [_RegisterView addSubview:checkBox];
    
    //房公信条款
    UIButton *terms = [UIButton buttonWithType:UIButtonTypeCustom];
    [terms setFrame:CGRectMake(kMarginX + 10,kMarginY + 80 + kInputBoxH * 2, 280, 20)];
    NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc]initWithString:@"我已阅读并同意《房公信服务条款》"];
    [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 16)];
    [terms setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [terms setAttributedTitle:titleAtt forState:UIControlStateNormal];
    [terms setBackgroundColor:[UIColor clearColor]];
    [terms addTarget:self action:@selector(clickTerms) forControlEvents:UIControlEventTouchUpInside];
    [_RegisterView addSubview:terms];

}

// 勾选
- (void)checkBoxSelectd:(UIButton *)button{
    
    button.selected = !button.selected;
    if (button.selected) {
        [_registerButton setBackgroundColor:[UIColor blueColor]];
        [_registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_registerButton setBackgroundColor:[UIColor grayColor]];

    }
    
}


//clickTerms
- (void)clickTerms{
    
    FGXTermsController *termsC = [[FGXTermsController alloc]init];
    [self.navigationController pushViewController:termsC animated:YES];
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
