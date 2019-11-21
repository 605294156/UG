//
//  UGHomeMessageVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/22.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMessageVC.h"
#import "UGHomeMessageCell.h"
#import "UGSystemMessagesListVC.h"
#import "UGAccountMessageVC.h"
#import "UGTabBarController.h"
#import "UGNotifyListViewController.h"

#import "UGNotifyModelTool.h"
#import "UGRemotemessageHandle.h"
#import "UGJPushMesageModel.h"

#import "UGMessageApi.h"
#import "UGNotifyModel.h"
#import "UGJPushHandle.h"
#import "UGupdateAllApi.h"

#import "UGHomeChatTableViewCell.h"
#import "UGScheduleView.h"
#define MessageCellIdentifier @"UGHomeMessageCell"

//网易七鱼
#import "QYPOPSDK.h"
#import "UGNavController.h"
#import "UGQYSDKManager.h"

#import "UGChatModel.h"

typedef NS_ENUM(NSInteger, UGHomessageType) {
    UGHomessageType_DYNAMIC_CHANGE_INFO  = 0 , //动账消息 :
    UGHomessageType_SYSTEM_CHANGE_INFO = 1 , //系统消息
    UGHomessageType_INFORM_INFO   = 2   //通知消息
};

@interface UGHomeMessageVC ()<QYConversationManagerDelegate, QYSessionViewDelegate>

@property(nonatomic,strong)UGNotifySuperModel *notifySuperModel;
@property(nonatomic,assign)NSInteger totalNoRead;//动账数据未读数
@property(nonatomic,assign)NSInteger chatNoRead;//聊天未读数
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t messageQueue;

/**
 聊天会话列表
 */
@property (nonatomic, strong) NSMutableArray *chatList;
/**
 客服会话
 */
//@property (nonatomic, strong) UGChatModel *sessionChatModel;

/**
 消息列表
 */
@property (nonatomic, strong) NSArray *messageList;

@property (nonatomic, assign) BOOL isFirstView;
@end

@implementation UGHomeMessageVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (![self.tableView.mj_header isRefreshing]) {
        [self sendMessageListRequestCompletionHandler:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getOrderWaitingData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UGScheduleView hidePopView];
}

#pragma mark -隐藏待办事项
-(void)hidenShowGuideView{
    [UGScheduleView hidePopView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.messageQueue = dispatch_queue_create("com.bibei.messageQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"收到推送消息" object:nil];// 推送暂时去掉
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTime) name:@"登录失效" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTime) name:@"LOGINSUCCES" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAllConversations) name:@"发起新的聊天" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"登录成功刷新界面数据" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerBeginRefresh) name:@"刷新消息列表" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reShowScheduleView) name:@"发现有待办事项" object:nil];
    
    dispatch_resume(self.timer);
    //网易七鱼
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
}

-(void)reShowScheduleView{
    [self getOrderWaitingData];
}

-(NSMutableArray *)chatList{
    if (!_chatList) {
        _chatList = [NSMutableArray new];
        UGChatModel *model = [UGChatModel new];
        model.avatar = [UGManager shareInstance].hostInfo.userInfoModel.customerAvatar;
        model.userName = @"在线客服";
        model.content = @"暂无消息";
        [_chatList addObject:model];
    }
    return _chatList;
}

-(NSArray *)messageList{
    if (!_messageList) {
        _messageList = [NSArray new];
    }
    return _messageList;
}

-(void)languageChange{
   self.navigationItem.title = LocalizationKey(@"message");
}

-(void)initUI{
    [self languageChange];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGHomeMessageCell class]) bundle:nil] forCellReuseIdentifier:MessageCellIdentifier];
    [self.tableView ug_registerNibCellWithCellClass:[UGHomeChatTableViewCell class]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.noDataTipText = @"暂无通知消息！";
    [self.tableView.mj_header beginRefreshing];
}

- (void)startTime {
    [self stopTime];
    dispatch_resume(self.timer);
}

- (void)stopTime  {
    if (_timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

//更新会话列表
- (void)updateAllConversations {
    //网易七鱼获取会话列表
    NSArray *arrInfo = [[[QYSDK sharedSDK] conversationManager] getSessionList];
    if(!UG_CheckArrayIsEmpty(arrInfo) && arrInfo.count > 0)
    {
        QYSessionInfo *info = arrInfo[0];
        //更新角标数量
        UGChatModel *model = self.chatList.firstObject;
        model.content = info.lastMessageText;
        model.timestamp = [UG_MethodsTool getFriendIntervalTime:info.lastMessageTimeStamp];
        model.unreadCount = info.unreadCount;
        self.chatNoRead = info.unreadCount;
    }else{
        UGChatModel *model = self.chatList.firstObject;
        model.content = @"暂无消息";
        model.timestamp = @"";
        model.unreadCount = 0;
        self.chatNoRead = 0;
    }
    
    NSMutableArray *dataArray = [NSMutableArray new];
    [dataArray addObjectsFromArray:self.messageList];
    [dataArray addObjectsFromArray:self.chatList];
    self.dataSource = dataArray.copy;
    [self setBage];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)getOrderWaitingData{
    if (![[UIViewController currentViewController] isKindOfClass:[UGHomeMessageVC class]]) {
        return;
    }
//    if (!self.isFirstView) {
//        self.isFirstView = YES;
        [[UGManager shareInstance]  getOrderWaitingDealList:^(BOOL complete, NSMutableArray * _Nonnull object) {
            //显示待办事项
            if (object.count>0) {
                //先隐藏
                [UGScheduleView hidePopView];
                @weakify(self);
                [UGScheduleView initWithArr:object WithHandle:^(UGOrderWaitingModel * _Nonnull model) {
                    @strongify(self);
                    [self gotoDetail:model];
                }WithViewHandle:^(UGScheduleView * _Nonnull scheduleView) {
                    
                } WithCloseHandle:^{
                    
                }];
            }
        }];
//    }
}

#pragma mark - 下拉刷新
- (void)refreshData {
    dispatch_async(self.messageQueue, ^{
        dispatch_group_t messageGroup = dispatch_group_create();
        
        dispatch_group_enter(messageGroup);
        dispatch_group_async(messageGroup, self.messageQueue, ^(){
            //获取其它消息列表
            [self sendMessageListRequestCompletionHandler:^{
                dispatch_group_leave(messageGroup);
            }];
        });

        dispatch_group_notify(messageGroup, self.messageQueue, ^(){
            
            NSMutableArray *dataArray = [NSMutableArray new];
            [dataArray addObjectsFromArray:self.messageList];
            [dataArray addObjectsFromArray:self.chatList];
            self.dataSource = dataArray.copy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];

            });
        });
    });
}

-(void)setBage{
    NSInteger total = self.totalNoRead+self.chatNoRead;
    [UGJPushHandle setBageWith:total];
}

/**
 获取消息列表

 @param completionHandler 请求是否完成
 */
- (void)sendMessageListRequestCompletionHandler:(void (^)(void))completionHandler {
    NSArray *arrInfo = [[[QYSDK sharedSDK] conversationManager] getSessionList];
    if(!UG_CheckArrayIsEmpty(arrInfo) && arrInfo.count > 0)
    {
        QYSessionInfo *info = arrInfo[0];
        UGChatModel *model = self.chatList.firstObject;
        model.content = info.lastMessageText;
        model.timestamp = [UG_MethodsTool getFriendIntervalTime:info.lastMessageTimeStamp];
        model.unreadCount = info.unreadCount;
        self.chatNoRead = info.unreadCount;
    }else{
        UGChatModel *model = self.chatList.firstObject;
        model.content = @"暂无消息";
        model.timestamp = @"";
        model.unreadCount = 0;
        self.chatNoRead = 0;
    }
    
    [UGJPushHandle getMessageVCDataCompletionBlock:^(UGApiError *apiError, id object) {
        
        if (!apiError) {
            
            if ([object isKindOfClass:[UGNotifySuperModel class]]) {
                
                self.notifySuperModel = (UGNotifySuperModel *)object;
                
                self.totalNoRead = self.notifySuperModel.informNoNum+self.notifySuperModel.systemNoNum+self.notifySuperModel.balanceNoNum;
                
                NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:self.notifySuperModel.rows];
                
                for (UGNotifyModel *model in dataArray) {
                    
                    UGHomessageType homeMessageType = [self convertToUGHomessageTypeWithParentMessageType:model.parentMessageType];
                    
                    switch (homeMessageType) {
                            
                        case UGHomessageType_DYNAMIC_CHANGE_INFO: //动账消息
                        {
                            if ([model.messageType isEqualToString:@"BALANCE_CHANGE_INFO"]) {
                                //转账消息
                                model.data  = [UGTransferModel mj_objectWithKeyValues:model.data];
                                
                            }else if([model.messageType isEqualToString:@"OTC_CHANGE_INFO"]){
                                //OTC消息
                                model.data  = [UGOTCOrderMeeageModel mj_objectWithKeyValues:model.data];
                            }else if([model.messageType isEqualToString:@"SYS_FREEZE_RESULT"]){
                                //系统冻结返还
                                model.data  = [UGSysFreezeResultModel mj_objectWithKeyValues:model.data];
                            }
                        }
                            break;
                        case UGHomessageType_INFORM_INFO:   //通知消息
                        {
                          
                            model.data  = [UGJpushNotifyModel mj_objectWithKeyValues:model.data];
                            
                        }
                            break;
                        case UGHomessageType_SYSTEM_CHANGE_INFO:  //系统消息
                        {
                           
                            model.data  = [UGJpushSystemModel mj_objectWithKeyValues:model.data];
                            
                        }
                            break;
                            
                        default:
                            //该类型无法找到则直接移除数据
                            [dataArray removeObject:model];
                            break;
                    }
                    self.messageList = dataArray;
                }
                
            }
        }
        [self setBage];
        if (completionHandler) {
            completionHandler();
        }
    }];
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id obj = self.dataSource[indexPath.section];
    //动账
    if ([obj isKindOfClass:[UGNotifyModel class]]) {
        UGNotifyModel *dataModel = (UGNotifyModel *)obj;
        UGHomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier forIndexPath:indexPath];
        //通知消息=OTC消息
        BOOL notifyMessage = [dataModel.data isKindOfClass:[UGJpushNotifyModel class]];
        //系统消息
        BOOL systemMessage = [dataModel.data isKindOfClass:[UGJpushSystemModel class]];
        //动账消息
        BOOL dynamicMessage = [dataModel.data isKindOfClass:[UGTransferModel class]] || [dataModel.data isKindOfClass:[UGOTCOrderMeeageModel class]] || [dataModel.data isKindOfClass:[UGSysFreezeResultModel class]];
        
        [cell updateWithModel:obj WithBage: notifyMessage ? self.notifySuperModel.informNoNum : systemMessage ? self.notifySuperModel.systemNoNum : dynamicMessage ? self.notifySuperModel.balanceNoNum : 0];
        return cell;
    }
    //聊天
    UGHomeChatTableViewCell *chatCell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGHomeChatTableViewCell class] forIndexPath:indexPath];
    chatCell.chatModel = (UGChatModel *)obj;
    //删除会话
    @weakify(self);
    chatCell.deleteConversation = ^(UGChatModel * _Nonnull chatModel) {
        @strongify(self);
        NSMutableArray *dataSource = [[NSMutableArray alloc] initWithArray:self.dataSource];
        NSInteger index = [dataSource indexOfObject:chatModel];
        if (index != NSNotFound) {
            [dataSource removeObjectAtIndex:index];
            self.dataSource = dataSource.copy;
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    return chatCell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id obj = self.dataSource[indexPath.section];
    
    if ([obj isKindOfClass:[UGNotifyModel class]]) {
        
        UGNotifyModel *notifyModel = (UGNotifyModel*)obj;
        
        UGHomessageType homeMessageType = [self convertToUGHomessageTypeWithParentMessageType:notifyModel.parentMessageType];
        
        switch (homeMessageType) {
            case UGHomessageType_INFORM_INFO:
            {
                //标记为已读
                [self setMessagesHadReadWithParentMessageType:notifyModel.parentMessageType];
                //OTC通知
                [self.navigationController pushViewController:[UGNotifyListViewController new] animated:YES];
            }
                break;
            case UGHomessageType_DYNAMIC_CHANGE_INFO:
            {
                //标记为已读
                [self setMessagesHadReadWithParentMessageType:notifyModel.parentMessageType];
                [self.navigationController pushViewController:[UGAccountMessageVC new] animated:YES];

            }
                break;
            case UGHomessageType_SYSTEM_CHANGE_INFO:
            {
                //标记为已读
                [self setMessagesHadReadWithParentMessageType:notifyModel.parentMessageType];
                [self.navigationController pushViewController:[UGSystemMessagesListVC new] animated:YES];

            }
                break;

            default:
                break;
        }

    }
        
    //聊天
    if ([obj isKindOfClass:[UGChatModel class]]) {
       #pragma mark -网易七鱼在线客服
        [self onChat];
        
    }
}

#pragma mark -网易七鱼相关
- (void)onChat{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"UG钱包";
    
    [[UGQYSDKManager shareInstance] updateDateQYUserInfo:@"" isLogin:NO];

    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
    sessionViewController.sessionTitle = @"在线客服";
    sessionViewController.source = source;
    
    UGNavController* navi = [[UGNavController alloc]initWithRootViewController:sessionViewController];

    [sessionViewController setNavigation];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//会话未读数变化
-(void)onUnreadCountChanged:(NSInteger)count{
    NSLog(@"未读数----%ld",count);
}

//监听消息接收
-(void)onReceiveMessage:(QYMessageInfo *)message{
     NSLog(@"监听消息接收----%@",message);
}

/**
 *  会话列表变化；非平台电商用户，只有一个会话项，平台电商用户，有多个会话项
 */
- (void)onSessionListChanged:(NSArray<QYSessionInfo *> *)sessionList{
     NSLog(@"会话列表变化-%@",sessionList);
    [self updateAllConversations];
}

- (void)configBadgeView
{
    //获取消息未读数
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    //    [_badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    //    [_badgeView setBadgeValue:value];
    NSLog(@"未读数----%@",value);
}
#pragma -----以上网易七鱼---------

- (UGHomessageType )convertToUGHomessageTypeWithParentMessageType:(NSString *)parentMessageType {
    
    if ([parentMessageType isEqualToString:@"DYNAMIC_CHANGE_INFO"]) {
        //动账消息
        return UGHomessageType_DYNAMIC_CHANGE_INFO;
        
    } else if([parentMessageType isEqualToString:@"SYSTEM_CHANGE_INFO"]) {
        //系统消息
        return UGHomessageType_SYSTEM_CHANGE_INFO;
        
    } else if([parentMessageType isEqualToString:@"INFORM_INFO"]) {
        //通知消息
        return UGHomessageType_INFORM_INFO;
    }
    return NSNotFound;
}
    
#pragma mark - 标志消息为全部已读
-(void)setMessagesHadReadWithParentMessageType:(NSString *)parentMessageType {
    
    if (self.notifySuperModel.balanceNoNum == 0 && self.notifySuperModel.systemNoNum == 0 && self.notifySuperModel.informNoNum == 0) {
        return;
    }
    //标记为已读
    [UGJPushHandle updateMessageWithType:parentMessageType CompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
            
            //本地修改数据
            if (([parentMessageType isEqualToString:@"DYNAMIC_CHANGE_INFO"])) {
                
                self.notifySuperModel.balanceNoNum = 0;
                
            }else if ([parentMessageType isEqualToString:@"SYSTEM_CHANGE_INFO"]) {
                
                self.notifySuperModel.systemNoNum = 0;
                
            } else if ([parentMessageType isEqualToString:@"INFORM_INFO"]) {
                
                self.notifySuperModel.informNoNum = 0;
            }
            [UGJPushHandle setBageWith:self.notifySuperModel.balanceNoNum + self.notifySuperModel.systemNoNum + self.notifySuperModel.informNoNum];
            [self.tableView reloadData];
            
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return section == 0 && self.dataSource.count > 0 ? 10.0f : 20.0f;
//    return self.dataSource.count > 0 ? 10.0f : CGFLOAT_MIN;
    return CGFLOAT_MIN;
}

-(BOOL)hasFooterRefresh{
    return NO;
}

-(BOOL)hasHeadRefresh{
    return YES;
}

#pragma mark - Getter Method

- (dispatch_source_t)timer {
    NSString *value = [self upDataMessage:@"msgRate" WithMessage:@"30.0"];
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
        uint64_t interval = (uint64_t)([value floatValue] * NSEC_PER_SEC);
        dispatch_source_set_timer(_timer, start, interval, 0);
        @weakify(self);
        dispatch_source_set_event_handler(_timer, ^{
            //重复执行的事件
            @strongify(self);
            if (![self.tableView.mj_header isRefreshing]) {
                [self sendMessageListRequestCompletionHandler:nil];
            }
        });
    }
    
    return _timer;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timer) {
        //停止定时器
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
