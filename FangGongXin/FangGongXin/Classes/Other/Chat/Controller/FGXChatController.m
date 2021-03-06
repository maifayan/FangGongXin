//
//  FGXChatController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/29.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXChatController.h"
#import "FGXChatInputBar.h"
#import "PureLayout.h"
#import "SRWebSocket.h"
#import "FMDatabase.h"
#import "FGXChat.h"
#import "FGXChatFrame.h"
#import "FGXChatCell.h"

#define FGXToId  [[NSUserDefaults standardUserDefaults] valueForKey:ToId]

@interface FGXChatController ()<UITableViewDelegate,UITableViewDataSource,SRWebSocketDelegate>

//聊天显示
@property (nonatomic, strong) UITableView           *tableView;
//底部控件
@property (nonatomic, strong) FGXChatInputBar       *inputBar;
//websocket
@property (nonatomic, strong) SRWebSocket           *webSocket;
//表格
@property (nonatomic, strong) FMDatabase            *database;
//后台返回数据
@property (nonatomic, copy)   NSMutableDictionary   *dataDic;
//聊天记录
@property (nonatomic, copy)   NSMutableArray        *dataArray;



@end

#define FGXInputViewH    46
@implementation FGXChatController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //websocket连接服务器
    [self Reconnect];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //解决第一次进入Vc的时候,未滚动到最底部
    [self  tableViewScrollToBottom];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    
    
    // Close WebSocket
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nick = [[NSUserDefaults standardUserDefaults] valueForKey:ToName];
    self.navigationItem.title = nick;

    
    
    //添加控件
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeBottom];
    
    [self.view addSubview:self.inputBar];
    [self.inputBar autoPinEdgesToSuperviewEdgesWithInsets:inset excludingEdge:ALEdgeTop];
    [self.inputBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tableView];
    //创建数据库，存储数据
    [self setupDatabase];
    //获取数据
    [self getChatData];
    
    //监听键盘弹出,对相应的布局做修改
    [self xmg_observerKeyboardFrameChange];
    //
    [self setupTapGestureRecognizer];
    
}
#pragma mark - 点击空白区域键盘收回
- (void)setupTapGestureRecognizer{
    /**
     点击 空白区域取消
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
}
#pragma mark - 创建数据库
- (void)setupDatabase{
    //1.获取数据库文件的路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    NSString *compontentStr = [NSString stringWithFormat:@"%@.sqlite",FGXToId];
    NSString *fileName = [path stringByAppendingPathComponent:compontentStr];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    //3.打开数据库
    if ([db open]) {
        //4.创表
        BOOL result=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS compontentStr (id integer PRIMARY KEY AUTOINCREMENT, content varchar(255) NOT NULL, fromUser varchar NOT NULL,timeStamp datetime,toUser varchar NOT NULL);"];
        if (result) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创表失败");
        }
    }
    self.database = db;
    
    
}

//聊天记录
- (void)query {
    // 首先刷新的时候要移除已有的对象
    [self.dataArray removeAllObjects];
    // 1.执行查询语句
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM compontentStr"];
    // 2.遍历结果
    NSMutableDictionary *resultDic = (NSMutableDictionary *)resultSet;
    
    while ([resultSet next]) {
        FGXChat *chat = [[FGXChat alloc]init];
        chat.mesag = resultDic;
        FGXChatFrame *chatFrame = [[FGXChatFrame alloc]init];
        chatFrame.chat = chat;
        [self.dataArray addObject:chatFrame];
        

        //删除表(测试)
//        BOOL delete = [self.database executeUpdate:@"delete from compontentStr"];
//        if (delete) {
//            NSLog(@"删除成功");
//        }else{
//            NSLog(@"删除失败");
//        }
        
    }
    
}

//插入
- (void)insert
{
    [self.database executeUpdate:@"INSERT INTO compontentStr (content,fromUser,timeStamp,toUser) VALUES (?,?,?,?);", self.dataDic[@"content"],self.dataDic[@"fromUser"], self.dataDic[@"timeStamp"],self.dataDic[@"toUser"]];
    [self getChatData];
}
#pragma mark - 聊天记录
- (void)getChatData{
    [self query];
    [self.tableView reloadData];
    [self tableViewScrollToBottom];
}
#pragma mark - RocketSocket
//初始化
- (void)Reconnect{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    NSString *chatFromId = [[NSUserDefaults standardUserDefaults] valueForKey:FromId];
    if (!chatFromId) {
        NSLog(@"聊天界面:用户未登录");
        return;
    }
    NSString *messageStr = [NSString stringWithFormat:@"%@/chat?userId=%@",chatUrl,chatFromId];
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:messageStr]]];
    self.webSocket.delegate = self;

    [self.webSocket open];
}

//代理方法实现  SRWebSocketDelegate
//websocket连接后回调
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    
}

//链接失败
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.webSocket = nil;
    // 断开连接后每过1s重新建立一次连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self Reconnect];
    });
}
//接收消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    
    self.dataDic = [NSMutableDictionary dictionary];
//    NSLog(@"message >>>> %@",message);
    self.dataDic = [self parseJSONStringToNSDictionary:message];
    if ([self.dataDic[@"content"] isEqualToString:@"成功建立socket连接"]) return;
    [self insert];
    
}
//后台给的是string数据，实际上是字典，需要转换
-(NSMutableDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"responseJSON = %@",responseJSON);
    return responseJSON;
}

//链接断开
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@",reason);
    
    self.webSocket = nil;
}
//
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"%@",reply);
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FGXChatCell *cell   = [FGXChatCell FGXCellWithTableView:tableView];
    
    cell.chatFrame      = self.dataArray[indexPath.row];
    
    //解决滑动时卡顿
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataArray[indexPath.row] cellH];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
}


#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - FGXInputViewH) style:UITableViewStylePlain];
        _tableView.accessibilityIdentifier = @"table_view";
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (FGXChatInputBar *)inputBar{
    if (!_inputBar) {
        _inputBar       =  [[FGXChatInputBar alloc]init];
        _inputBar.frame =  CGRectMake(0, self.view.bounds.size.height - FGXInputViewH, self.view.bounds.size.width, FGXInputViewH);
        
    }
    return _inputBar;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 私有方法
- (void)xmg_observerKeyboardFrameChange
{
    [[NSNotificationCenter defaultCenter] addObserverForName: UIKeyboardWillChangeFrameNotification
                                                      object:nil
                                                       queue: [NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      //
                                                      //                                                      NSLog(@"%s, line = %d,note =%@", __FUNCTION__, __LINE__, note);
                                                      /**
                                                       note.userInfo
                                                       UIKeyboardAnimationCurveUserInfoKey = 7;
                                                       UIKeyboardAnimationDurationUserInfoKey = "0.25";
                                                       UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
                                                       UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
                                                       UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
                                                       UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
                                                       UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
                                                       UIKeyboardIsLocalUserInfoKey = 1;
                                                       self.view 可以根据 end.oriY来进行 布局改变
                                                       */
                                                      CGFloat endY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
                                                      CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                      
                                                      CGFloat tempY = endY - self.view.bounds.size.height;
                                                      CGRect tempF = CGRectMake(0, tempY, self.view.bounds.size.width, self.view.bounds.size.height);
                                                      self.view.frame = tempF;
                                                      [UIView animateWithDuration:duration animations:^{
                                                          [self.view setNeedsLayout];
                                                      }];
                                                      
                                                      
                                                  }];
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.dataArray.count==0)
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
