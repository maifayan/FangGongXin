//
//  FGXChatInputBar.m
//  FangGongXin
//
//  Created by Apple on 2017/9/30.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXChatInputBar.h"
#import "PureLayout.h"

//背景颜色
#define kBkColor             ([UIColor colorWithRed:0.922 green:0.925 blue:0.929 alpha:1])


//输入框最大高度
#define kMaxHeightTextView   (84)

//输入框最小高度
#define kMinHeightTextView          (34)

//默认输入框和父控件底部间隔
#define kDefaultBottomTextView_SupView  (5)

#define kDefaultTopTextView_SupView  (5)

//按钮大小
#define kSizeBtn             (CGSizeMake(60, 34))

@interface FGXChatInputBar ()<UITextViewDelegate>{
    
    /**
     *  @brief  TextView和自己底部约束，会被动态增加、删除
     */
    NSLayoutConstraint *mBottomConstraintTextView;

    /**
     *  @brief  自己和父控件 底部约束，使用这个约束让自己伴随键盘移动
     */
    NSLayoutConstraint *mBottomConstraintWithSupView;

    /**
     *  @brief  TextView的高度
     */
    CGFloat mHeightTextView;
}

//输入框
@property (nonatomic, strong) UITextView    *inputTextView;
//发送按钮
@property (nonatomic, strong) UIButton      *sendBtn;

@end

@implementation FGXChatInputBar

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = kBkColor;
        mHeightTextView      = kMinHeightTextView;//默认设置输入框最小高度
        
        //输入框控件
        [self addSubview:self.inputTextView];
        [self.inputTextView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:5];
        [self.inputTextView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kDefaultTopTextView_SupView];
        mBottomConstraintTextView = [self.inputTextView  autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kDefaultBottomTextView_SupView];
        //发送按钮
        [self addSubview:self.sendBtn];
        [self.sendBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.inputTextView];
        [self.sendBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];
        [self.sendBtn  autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.inputTextView withOffset:0];
        
    }
    return self;
}

//获取自己和父控件底部约束，控制该约束可以让自己伴随键盘移动
-(void)updateConstraints
{
    [super updateConstraints];
    
    
    if (!mBottomConstraintWithSupView)
    {
        NSArray *constraints = self.superview.constraints;
        
        for (int index= (int)constraints.count-1; index>0; index--)
        {//从末尾开始查找
            NSLayoutConstraint *constraint = constraints[index];
            
            if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom)
            {//获取自己和父控件底部约束
                mBottomConstraintWithSupView = constraint;
                
                break;
            }
        }
    }
    
}

/**
 *  @brief  返回自己的固有内容尺寸，刷新固有内容尺寸系统将会重新调用此方法
 *
 *  @return 宽度不设置固有内容尺寸，只设置高度
 */
-(CGSize)intrinsicContentSize
{
    CGFloat height = mHeightTextView+kDefaultBottomTextView_SupView +kDefaultTopTextView_SupView;
    
    //    height += [mMoreView intrinsicContentSize].height; //如果更多视图当前正在显示，需要加上更多视图的高度
    //
    //    height += [mFaceView intrinsicContentSize].height; //如果表情视图当前正在显示，需要加上他的的高度
    
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}


#pragma mark - 伴随键盘移动

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    
    if (notification.name == UIKeyboardWillShowNotification)
    {
        mBottomConstraintWithSupView.constant = -(keyboardEndFrame.size.height);
    }else
    {
        mBottomConstraintWithSupView.constant = 0;
    }
    
    [self.superview layoutIfNeeded];
    
    
    [UIView commitAnimations];
}


#pragma mark -TextView Delegate
//发送事件
- (void)sendClick{
    
    if (!self.inputTextView.text) {//判断输入框为空，就不发送消息
        return;
    }
    if (![self.inputTextView.text isEqualToString:@""]) {
    
        [self textViewDidChange:self.inputTextView];
        
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *timeSp = [self getNowTimeTimestamp3];
     NSString *fromid = [[NSUserDefaults standardUserDefaults] valueForKey:FromId];
        if (!fromid) {
            NSLog(@"用户未登录");
            return;
        }
        dic[@"fromUser"] = fromid;
        dic[@"toUser"]   = [[NSUserDefaults standardUserDefaults] valueForKey:ToId];
        dic[@"content"]  = self.inputTextView.text;
        dic[@"timeStamp"]= timeSp;
        NSString *urlStr = [NSString stringWithFormat:@"%@message/send",chatUrl];
        
        [mgr POST:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self.inputTextView resignFirstResponder];
            
            self.inputTextView.text = @"";//清空输入框
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}


//根据输入文字多少，自动调整输入框的高度
-(void)textViewDidChange:(UITextView *)textView
{
    //计算输入框最小高度
    CGSize size =  [textView sizeThatFits:CGSizeMake(textView.contentSize.width, 0)];
    
    CGFloat contentHeight;
    
    //输入框的高度不能超过最大高度
    if (size.height > kMaxHeightTextView)
    {
        contentHeight = kMaxHeightTextView;
        textView.scrollEnabled = YES;
    }else
    {
        contentHeight = size.height;
        textView.scrollEnabled = NO;
    }

    if (mHeightTextView != contentHeight)
    {//如果当前高度需要调整，就调整，避免多做无用功
        mHeightTextView = contentHeight ;//重新设置自己的高度
        [self invalidateIntrinsicContentSize];
    }
}
#pragma mark - 时间戳
//获取当前时间戳  （以毫秒为单位）

- (NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}


#pragma mark - 懒加载
- (UITextView *)inputTextView{
    if (!_inputTextView) {
        //PureLayout 布局
        _inputTextView          = [[UITextView alloc]initForAutoLayout];
        _inputTextView.delegate = self;
        //边界设置
        _inputTextView.layer.cornerRadius  = 4;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.layer.borderWidth   = 1;
        _inputTextView.layer.borderColor   = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4]CGColor];
        //约束条件
        _inputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 4.0f);
        _inputTextView.contentInset          = UIEdgeInsetsZero;
        _inputTextView.scrollEnabled         = NO;
        _inputTextView.scrollsToTop          = NO;
        _inputTextView.userInteractionEnabled= YES;
        _inputTextView.font                  = [UIFont systemFontOfSize:14];
        _inputTextView.textColor             = [UIColor blackColor];
        _inputTextView.backgroundColor       = [UIColor whiteColor];
        _inputTextView.keyboardAppearance    = UIKeyboardAppearanceDefault;
        _inputTextView.keyboardType          = UIKeyboardTypeDefault;
        _inputTextView.returnKeyType         = UIReturnKeyDefault;
        _inputTextView.textAlignment         = NSTextAlignmentLeft;
    }
    return _inputTextView;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setBackgroundColor:[UIColor greenColor]];
        [_sendBtn autoSetDimensionsToSize:kSizeBtn];
        [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
