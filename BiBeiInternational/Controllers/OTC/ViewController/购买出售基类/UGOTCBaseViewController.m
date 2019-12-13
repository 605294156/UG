//
//  UGOTCBaseViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCBaseViewController.h"
#import "UGOrderDetailApi.h"
#import "TransactionRecordViewController.h"
#import "OTCViewController.h"
#import "OTCPayPageVC.h"
#import "OTCComplaintViewController.h"
#import "UGAccountMessageVC.h"
#import "UGBaseNotifyListVC.h"
#import "OTCJpushViewController.h"
#import "UGBillViewController.h"
#import "UGAdDetailVC.h"

//网易七鱼
#import "QYPOPSDK.h"
#import "UGNavController.h"
#import "UGChatTopView.h"
#import "UGQYSDKManager.h"

@interface UGOTCBaseViewController ()<UIGestureRecognizerDelegate,QYSessionViewDelegate,QYConversationManagerDelegate>

@property (nonatomic,strong)UGOrderDetailModel *orderDetailModel;

@property (nonatomic,strong)UGChatTopView *chatPopView;

@end

@implementation UGOTCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.headerXXHeight = 195.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanUnreadIdentification) name:@"清空OTC未读消息标识" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOrderDetailRequest) name:@"收到新的详情消息" object:nil];
    
    //因为把继承UGOTCBaseViewController的子类addChildViewController到OTCJpushViewController里面了 而OTCJpushViewController也继承UGOTCBaseViewController，所以需要加判断。不然viewDidLoad的代码会执行2次
    if (![self.parentViewController isKindOfClass:[OTCJpushViewController class]]) {
        //显示遮挡view
        [self showEmptyView];
        //拉取数据
        [self sendOrderDetailRequest];
        //控制返回
        @weakify(self);
        [self setupBarButtonItemWithImageName:@"back_icon" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
            @strongify(self);
            //打开侧滑返回
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            UIViewController *controller = [self findPageViewController];
            if (controller) {
                //确认付款、申诉、聊天页面  可以返回上一级
                if ([self isKindOfClass:[OTCPayPageVC class]] || [self  isKindOfClass:[OTCComplaintViewController class]] ) {
                    NSLog(@"确认付款、申诉、聊天页面  可以返回上一级 %@", self);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"查找的PageViewController控制器:%@", controller);
                    [self.navigationController popToViewController:controller animated:YES];
                }
            } else {
                NSLog(@"查找不到PageViewController控制器....");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)findPageViewController {
    //需要把navigationController.viewControllers反向排序后查找，不然会导致从TransactionRecordViewController进入后优先查找到OTCViewController。
    for (UIViewController *temp in [self.navigationController.viewControllers reverseObjectEnumerator]) {
        //交易记录、OTC购买出售列表 、动账消息列表、消息列表的OTC消息 、UG钱包记录  返回 TransactionRecordViewController 、OTCViewController、UGBaseNotifyListVC、UGBaseNotifyListVC 、UGBillViewController即UGBillContentVC
        //OTCJpushViewController会 addChildViewController OTC交易流程的控制器进去所以判断不是OTCJpushViewController
        BOOL pop = [temp isKindOfClass:[TransactionRecordViewController class]] || [temp isKindOfClass:[OTCViewController class]] || [temp isKindOfClass:[UGBaseNotifyListVC class]] || [temp isKindOfClass:[UGBillViewController class]] || [temp isKindOfClass:[UGAdDetailVC class]];
        if ( pop  && ![temp isKindOfClass:[OTCJpushViewController class]] ) {
            return temp;
        }
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //关闭侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x333333), NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

- (void)viewWillAppear:(BOOL)animated{[super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

#pragma mark - NSNotification

//收到清空新消息标识
- (void)cleanUnreadIdentification {
    [self receiveNewIMMessage:NO];
}

#pragma mark - Public Method

//子类实现
- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
}

//子类实现
- (void)receiveNewIMMessage:(BOOL)hasNewMessage {
    
}

/**
 跳转到聊天页面
 */
- (void)pushToChatViewController {
    //网易七鱼
    
    //1.信息设置  用户信息设置
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"UG钱包";
    
    [[UGQYSDKManager shareInstance] updateDateQYUserInfo:self.orderSn isLogin:NO];
   
    //2.发送信息设置
    QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
    commodityInfo.title = [NSString stringWithFormat:@"%@%@", [self.orderDetailModel typeConvertToString], self.orderDetailModel.unit];
    commodityInfo.desc = self.orderSn;
    commodityInfo.pictureUrlString = [UGURLConfig serverHeaderApi];
    commodityInfo.note = [NSString stringWithFormat:@"%@ UG",self.orderDetailModel.amount];
    commodityInfo.show = YES;
    

    //2.悬浮窗口设置
    self.chatPopView = [UGChatTopView fromXib];
    [self.chatPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(150);
        make.width.mas_offset(UG_SCREEN_WIDTH);
    }];
    [self updateViewsWithDetailData];
    
    //获取会话聊天
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.delegate = self;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"]  style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
//    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
    sessionViewController.sessionTitle = @"在线客服";
    sessionViewController.source = source;
    sessionViewController.commodityInfo = commodityInfo;
    [sessionViewController registerTopHoverView:self.chatPopView height:150 marginInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UGNavController* navi = [[UGNavController alloc]initWithRootViewController:sessionViewController];
    [sessionViewController setNavigation];
    [self presentViewController:navi animated:YES completion:nil];
    [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
}

#pragma mark - 更新view上的数据
- (void)updateViewsWithDetailData {
    //顶部信息
    //头像
    [self.chatPopView.headImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.hisAvatar]];
    //用户名
    self.chatPopView.nameLabel.text = self.orderDetailModel.otherSide;
    //出售BTC
    self.chatPopView.orderNameLabel.text = [NSString stringWithFormat:@"%@%@", [self.orderDetailModel typeConvertToString], self.orderDetailModel.unit];
    //9999.00 UG
    self.chatPopView.amountLabel.text = [NSString stringWithFormat:@"%@ UG",self.orderDetailModel.amount];
    //顶部单价
    self.chatPopView.topPriceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元",self.orderDetailModel.price];
    //订单状态
    self.chatPopView.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];
    
    UGPayInfoModel *payInfos = [UGPayInfoModel new];
    if (self.orderDetailModel.alipay) {
        payInfos.alipay = self.orderDetailModel.alipay;
    }
    if (self.orderDetailModel.bankInfo) {
        payInfos.bankInfo = self.orderDetailModel.bankInfo;
    }
    if (self.orderDetailModel.wechatPay) {
        payInfos.wechatPay = self.orderDetailModel.wechatPay;
    }
    if (self.orderDetailModel.unionPay) {
        payInfos.unionPay = self.orderDetailModel.unionPay;
    }
    payInfos.username = [self.orderDetailModel.type isEqualToString:@"0"] ?  self.orderDetailModel.payInfo.username : self.orderDetailModel.reveiveInfo.username;
    payInfos.memberId = [self.orderDetailModel.type isEqualToString:@"0"] ? self.orderDetailModel.payInfo.memberId : self.orderDetailModel.reveiveInfo.memberId;
    payInfos.realName = [self.orderDetailModel.type isEqualToString:@"0"] ? self.orderDetailModel.payInfo.realName : self.orderDetailModel.reveiveInfo.realName;
    payInfos.avatar = [self.orderDetailModel.type isEqualToString:@"0"] ? self.orderDetailModel.payInfo.avatar : self.orderDetailModel.reveiveInfo.avatar;
    payInfos.commission = self.orderDetailModel.commission;
    self.chatPopView.payModeView.payInfoModel = payInfos;
    
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
}

#pragma mark - Request
//获取信息详情
- (void)sendOrderDetailRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOrderDetailApi *api = [UGOrderDetailApi new];
    api.orderSn = self.orderSn;
    
    NSString *str =  [NSString stringWithFormat:@"%@的订单号不能为空",NSStringFromClass([self class])];
    NSAssert(self.orderSn.length != 0, str);
    
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object) {
            UGOrderDetailModel *detailModel = [UGOrderDetailModel mj_objectWithKeyValues:object]; 
            //            把detailModel传递给子类
            [self.view ly_hideEmptyView];
            [self updateViewsData:detailModel];
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                创建单聊会话
//                [self chatViewUpData];
            });
        } else {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            [self showErrorEmptyView:apiError.desc clickRelodRequestHandle:^{
                @strongify(self);
                [self sendOrderDetailRequest];
            }];
        }
    }];
}

//-(void)chatViewUpData{
//    if (!self.conversation) {
//        //        [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",[UGManager shareInstance].hostInfo.userInfoModel.chatPrefix, detailModel.otherSide] completionHandler:^(id resultObject, NSError *error) {
//        //    此版本创建“在线客服聊天”
//        @weakify(self);
//        [JMSGConversation createSingleConversationWithUsername:[UGManager shareInstance].hostInfo.userInfoModel.customerMemberAccount completionHandler:^(id resultObject, NSError *error) {
//            @strongify(self);
//            if (!error) {
//                self.conversation = (JMSGConversation *)resultObject;
//            }else if (error.code == kJMSGErrorSDKUserNotLogin ) {//未登录
//                [JMSGUser loginWithUsername:[UGManager shareInstance].hostInfo.userInfoModel.member.messageAccount password:[UGManager shareInstance].hostInfo.userInfoModel.member.messagePassword completionHandler:^(id resultObject, NSError *error) {
//                    //未注册
//                    if (error.code == kJMSGErrorTcpUserNotRegistered) {
//                        //调用后台注册j接口
//                        [[UGRegisterIMApi new] ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
//                            
//                            if (!apiError) {
//                                
//                                [self chatViewUpData];
//                            } else {
//                                //                                        [self.view ug_showToastWithToast:apiError.desc];
//                            }
//                        }];
//                    } else if (error) {
//                        
//                        //                                [self.view ug_showToastWithToast:error.localizedDescription];
//                        
//                    }
//                    else {
//                        [self chatViewUpData];
//                    }
//                }];
//            }else {
//                [MBProgressHUD ug_hideHUDFromKeyWindow];
//                [self chatViewUpData];
//                //                [self showErrorEmptyView:error.description clickRelodRequestHandle:^{
//                //                    @strongify(self);
//                //                    [self sendOrderDetailRequest];
//                //                }];
//            }
//        }];
//    }
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",[self class]);
}

/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal {

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];

    [shapeLayer setBounds:lineView.bounds];

    if (isHorizonal) {

        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];

    } else{
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame)/2)];
    }

    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    if (isHorizonal) {
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    } else {

        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);

    if (isHorizonal) {
        CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame)+150, 0);
    } else {
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
    }

    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
