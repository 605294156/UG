//
//  OTCTestViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCWaitingForPayVC.h"
#import "OTCPayPageVC.h"
#import "UGPayWayView.h"
#import "UIButton+Expand.h"
#import "UGPayMethodView.h"
#import "UGWechaPayViewController.h"
#import "UGBankPaySettingViewController.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"
#import "UGOrderDetailApi.h"
#import "QRCodeViewModel.h"
#import "UGImagePopView.h"
#import "UGCreateNewAlipayApi.h"
#import "UGCMImagePopView.h"

@interface OTCWaitingForPayVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerfooterW;
@property (weak, nonatomic) IBOutlet UIButton *goPayBtn;
@property(strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UIView *payWayContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payWayHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;


//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：2.06777 BTC≈ 100.00CNY
//@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：待付款
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusText;

//@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 蓝色圆圈view
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//剩余支付时间 例如：剩余14分18秒
//@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY

//订单信息
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;//订单金额 例如：100 CNY
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：1.675.03 CNY/BTC
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量 例如：0.87557 BTC
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号 例如：0875456433
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//订单时间 例如：2018-10-09 17:21:34

//手续费高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonH;
//手续费距离顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonTop;
//手续费
@property (weak, nonatomic) IBOutlet UILabel *commissonLabel;
@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型

//红色倒计时
@property (weak, nonatomic) IBOutlet UILabel *redTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redBack;
@property (weak, nonatomic) IBOutlet UIImageView *time_icon;

/**
 自己选择的支付的下标，需要去 orderDetailModel的 payModeList中用下标取出对应的值
 */
@property (nonatomic, assign) NSInteger payIndex;

//底部中间按钮 查看资产或取消交易
@property (weak, nonatomic) IBOutlet UIButton *centerButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderHeaderHeight;


/**
 聊天按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (nonatomic,strong)MXRGuideMaskView *maskView;

@property (nonatomic,assign)BOOL isShow;

//回购的时候 需要隐藏
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payLabelH;

//装载支付宝图片
@property(nonatomic,strong)UIImageView *payAccountImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;

@end

@implementation OTCWaitingForPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title = @"待支付";
    self.buttonBottomConstraint.constant += UG_SafeAreaBottomHeight;
    self.payIndex = NSNotFound;
    self.title = @"订单详情";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    self.view.backgroundColor = HEXCOLOR(0xf8f8f8);
    
    if (!IS_IPHONE_X) {
        self.viewBottom.constant = 0.f;
    }else{
        self.orderHeaderHeight.constant = self.headerXXHeight;
    }
    
    if (@available(iOS 11.0, *)) {
        self.containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hidenShowGuideView];
}

#pragma mark - 更新显示数据
- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
    [self updateViewsData];
}

- (void)updateViewsData {
    //倒计时剩余支付时间
    [self secondsCountDown];
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.hisAvatar]];
    //用户名
    self.nameLabel.text = self.orderDetailModel.otherSide;
    //出售BTC
    self.orderNameLabel.text = [NSString stringWithFormat:@"%@%@", [self.orderDetailModel typeConvertToString], self.orderDetailModel.unit];
    //9999.00 UG
    self.amountLabel.text = [NSString stringWithFormat:@"%@ UG",self.orderDetailModel.amount];
    //顶部单价
//    self.topPriceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元",self.orderDetailModel.price];
   
    //对方收款方式
    UGPayInfoModel *payInfos = [UGPayInfoModel new];
    if (self.orderDetailModel.alipay)
    {
        payInfos.alipay = self.orderDetailModel.alipay;
        self.payAccountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 150, 150)];
        //取到二维码图片
        [self.payAccountImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.alipay.qrCodeUrl]];
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
    self.payModeView.payInfoModel = payInfos;

    //订单状态
//    self.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];
//    self.orderStatusImage.image = [UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];
    self.orderStatusText.text = [self.orderDetailModel statusConvertToString];

    //支付方式
    [self setupPayWayView];
    
    //订单详细信息
    //订单金额 例如：100 CNY
    self.orderAmountLabel.text = [NSString stringWithFormat:@"%@ 元", self.orderDetailModel.money] ;
    //单价 例如：1.675.03 CNY/BTC
    self.priceLabel.text = [NSString stringWithFormat:@"%@ 元 / %@",[self.orderDetailModel.price ug_amountFormat], self.orderDetailModel.unit];
    //数量 例如：0.87557 BTC
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.amount, self.orderDetailModel.unit];
    //订单号 例如：0875456433
    self.orderNumberLabel.text = self.orderDetailModel.orderSn;
    //订单时间 例如：2018-10-09 17:21:34
    self.orderTimeLabel.text = self.orderDetailModel.createTime;
    //手续费
    BOOL show = [self.orderDetailModel.commission doubleValue] > 0;
    self.commissonH.constant = show ? 16.0f : 0.0f;
    self.commissonTop.constant = show ? 10.0f : 0.0f;
    self.commissonLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.commission, self.orderDetailModel.unit];

    if (![[NSUserDefaultUtil GetDefaults:@"haveIsBuyGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].OTCBuyStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[OTCWaitingForPayVC class]]) {
            return;
        }
        NSArray *titles = [self.orderDetailModel payModeList];
        @weakify(self);
        self.isShow = YES;
        [self setupWaitingForPayNewGuideView:titles.count WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
        }];
    }
    
    if ([self.orderDetailModel.sysBuy isEqualToString:@"1"]) {
        //系统回购
        self.payLabelH.constant = 0.0;
        self.payLabelHeight.constant = 0.0;
        self.payLabel.hidden = YES;
      
        self.payWayContainerView.hidden = YES;
        self.payWayHeight.constant =0.0;
        
//        self.redTimeLabel.hidden = NO;
//        self.redTimeLabel.text = @"平台交易订单";
//        self.redTimeLabel.textColor = [UIColor colorWithHexString:@"BBBBBB"];
    }
}

#pragma mark - 收到新消息

- (void)receiveNewIMMessage:(BOOL)hasNewMessage {
    UIImage *image = hasNewMessage ? [UIImage imageNamed:@"OTC_message-1"] : [UIImage imageNamed:@"OTC_news"];
    [self.chatButton setImage:image forState:UIControlStateNormal];
}


#pragma mark - 支付方式
- (void)setupPayWayView {
    NSArray *titles = [self.orderDetailModel payModeList];
    @weakify(self);
    UGPayWayView *payWayView = [[UGPayWayView alloc] initWithFrame:CGRectMake(0, 45, self.payWayContainerView.mj_w, 0) titles:titles handle:^(NSString * _Nonnull title, NSInteger index) {
//        NSLog(@"选择了：%@支付方式,是第 %zd个",title,index);
        @strongify(self);
        self.payIndex = index;
    }];
    [self.payWayContainerView addSubview:payWayView];
    self.payWayHeight.constant = payWayView.size.height + 45;
    self.containerfooterW.constant = kWindowW-20;
}

#pragma mark - 倒计时剩余支付时间
- (void)secondsCountDown {
    __block int timeout = [self.orderDetailModel.timeLimit intValue];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout<0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
//                self.goPayBtn.enabled = NO;
            });
        }else {
            NSString *timeStr = [self getMMSSFromSS:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [NSString stringWithFormat:@"%@",timeStr];
                self.redTimeLabel.text = timeStr;
                if ([timeStr isEqualToString:@"00:00:00"]) {
                    self.redTimeLabel.hidden = YES;
                    self.redBack.hidden = YES;
                    self.time_icon.hidden = YES;
                }
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(int)totalTime{
    int seconds = totalTime;
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

- (IBAction)clickCancelDeal:(UIButton *)sender {
    @weakify(self);
    [self cancelOroderWithOrderSn:self.orderSn handle:^{
        @strongify(self);
        [self popToSuperView];
    }];
}

#pragma mark - 已经支付过了 回到OTC首页
-(void)popToSuperView{
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (IBAction)clickMessage:(UIButton *)sender {
    [self pushToChatViewController];
}

//获取当前订单状态
- (void)sendOrderStatusApiComplite:(void(^)(void))complite {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOrderDetailApi *api = [UGOrderDetailApi new];
    api.orderSn = self.orderSn;
    NSString *str =  [NSString stringWithFormat:@"%@的订单号不能为空",NSStringFromClass([self class])];
    NSAssert(self.orderSn.length != 0, str);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            UGOrderDetailModel *model = [UGOrderDetailModel mj_objectWithKeyValues:object];
            self.orderDetailModel.status = model.status;
            //订单状态
            self.orderStatusText.text = [self.orderDetailModel statusConvertToString];
//             self.orderStatusImage.image = [UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];
        }
        complite();
    }];
}

//去支付
-(void)doPay{
    if (self.payIndex == NSNotFound) {
        [self.view ug_showToastWithToast:@"请选择一种支付方式"];
        return;
    }
    
    if (![self checkPayModeMatch]) {
        return;
    }
    UGUserInfoModel *infoModel = [UGManager shareInstance].hostInfo.userInfoModel;
    NSString *tips = nil;
    
    if ([self isBankPay] && infoModel.hasBankBinding) {
//        tips = [NSString stringWithFormat:@"为保障您的交易顺利，请您务必使用已绑定账号 %@ 进行支付",[UGManager shareInstance].hostInfo.userInfoModel.member.cardNo];
        OTCPayPageVC *vc = [OTCPayPageVC new];
        vc.orderSn = self.orderSn;
        vc.payIndex = self.payIndex;
        vc.cmBlock = ^(NSString * _Nonnull cmMoney) {
            if (!UG_CheckStrIsEmpty(cmMoney))
            {
                 self.orderAmountLabel.text = [NSString stringWithFormat:@"%@ 元", cmMoney] ;
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    
    if ([self isWechaPay] && infoModel.hasWechatPay) {
        tips = [NSString stringWithFormat:@"为保障您的交易顺利，请您务必使用已绑定账号 %@ 进行支付",[UGManager shareInstance].hostInfo.userInfoModel.member.wechat];
        [[UGAlertPopView shareInstance] showAlertPopViewWithTitle:@"支付提醒" andMessage:tips andCancelButtonTittle:@"取消" andConfirmlButtonTittle:@"确定" cancelBlock:^{
            
        } confirmBlock:^{
            
            OTCPayPageVC *vc = [OTCPayPageVC new];
            vc.orderSn = self.orderSn;
            vc.payIndex = self.payIndex;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    if ([self isUnionPay] && infoModel.hasUnionPay) {
        tips = [NSString stringWithFormat:@"为保障您的交易顺利，请您务必使用已绑定账号 %@ 进行支付",[UGManager shareInstance].hostInfo.userInfoModel.member.unionPay];
        [[UGAlertPopView shareInstance] showAlertPopViewWithTitle:@"支付提醒" andMessage:tips andCancelButtonTittle:@"取消" andConfirmlButtonTittle:@"确定" cancelBlock:^{
            
        } confirmBlock:^{
            
            OTCPayPageVC *vc = [OTCPayPageVC new];
            vc.orderSn = self.orderSn;
            vc.payIndex = self.payIndex;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    if ([self isAliPay] && infoModel.hasAliPay) {
//        tips = [NSString stringWithFormat:@"    为保障交易顺利，请使用已绑定账号%@，按照指定金额支付，否则订单将会延迟处理！",[UGManager shareInstance].hostInfo.userInfoModel.member.aliNo];
//        [[UGImagePopView shareInstance]showAlertPopViewWithDes:tips andType:0 andCancelButtonTittle:@"取消" andConfirmlButtonTittle:@"确认"cancelBlock:^{
//        } confirmBlock:^{
//            [self aliPayPushToPersonalTransfer];
////            [self cmAliPayPushToPersonalTransfer];
//        }];
        
        
        [[UGCMImagePopView shareInstance]showAlertPopViewWithTittle:@"支付提醒" andCancelButtonTittle:@"取消" andConfirmlButtonTittle:@"确定" cancelBlock:^{
        } confirmBlock:^{
            [self aliPayPushToPersonalTransfer];
        }];
    }
}


#pragma mark - 彩盟支付宝相关弹窗
-(void)cmAliPayPushToPersonalTransfer
{
    NSURL * alipay_app_url = [NSURL URLWithString:@"alipay://"];
    BOOL alipay = [[UIApplication sharedApplication] canOpenURL:alipay_app_url];
    if (alipay)
    {
        UGCreateNewAlipayApi *api = [UGCreateNewAlipayApi new];
        api.payType = @"1";
        api.merOrderNo = self.orderSn;
        api.appId = @"123456";
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        
            NSLog(@"object = %@",object);
            if (apiError.errorNumber==0)
            {
                NSLog(@"object = %@",object);
                NSDictionary *dic = object;
                NSString *urlString = dic[@"url"];
                OTCPayPageVC *vc = [OTCPayPageVC new];
                vc.orderSn = self.orderSn;
                vc.payIndex = self.payIndex;
                vc.cmPersonalTransferStr = urlString;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"对方收款码无法识别，请您使用已绑定账号 %@ 自行转账到对方支付宝或重新选择转账方式！",[UGManager shareInstance].hostInfo.userInfoModel.member.aliNo] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    OTCPayPageVC *vc = [OTCPayPageVC new];
                    vc.orderSn = self.orderSn;
                    vc.payIndex = self.payIndex;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                [alerCtl addAction:cancelAction];
                [self presentViewController:alerCtl animated:YES completion:nil];
            }
        
        }];
    }
    else
    {
        UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"您的设备未安装支付宝！请您使用已绑定账号 %@ 自行转账到对方支付宝！",[UGManager shareInstance].hostInfo.userInfoModel.member.aliNo] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            OTCPayPageVC *vc = [OTCPayPageVC new];
            vc.orderSn = self.orderSn;
            vc.payIndex = self.payIndex;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alerCtl addAction:cancelAction];
        [self presentViewController:alerCtl animated:YES completion:nil];
    }
}

#pragma mark - 支付宝相关弹窗
-(void)aliPayPushToPersonalTransfer
{
    NSURL * alipay_app_url = [NSURL URLWithString:@"alipay://"];
    BOOL alipay = [[UIApplication sharedApplication] canOpenURL:alipay_app_url];
    if (alipay)
    {
        NSString *qrcodeString = [QRCodeViewModel readQRCodeFromImage:self.payAccountImageView.image];
        if (UG_CheckStrIsEmpty(qrcodeString))
        {
            UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"对方收款码无法识别，请您使用已绑定账号 %@ 自行转账到对方支付宝或重新选择转账方式！",[UGManager shareInstance].hostInfo.userInfoModel.member.aliNo] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                OTCPayPageVC *vc = [OTCPayPageVC new];
                vc.orderSn = self.orderSn;
                vc.payIndex = self.payIndex;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [alerCtl addAction:cancelAction];
            [self presentViewController:alerCtl animated:YES completion:nil];
        }
        else
        {
            OTCPayPageVC *vc = [OTCPayPageVC new];
            vc.orderSn = self.orderSn;
            vc.payIndex = self.payIndex;
            vc.QRCodeImage = self.payAccountImageView.image;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else
    {
        UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"您的设备未安装支付宝！请您使用已绑定账号 %@ 自行转账到对方支付宝！",[UGManager shareInstance].hostInfo.userInfoModel.member.aliNo] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            OTCPayPageVC *vc = [OTCPayPageVC new];
            vc.orderSn = self.orderSn;
            vc.payIndex = self.payIndex;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alerCtl addAction:cancelAction];
        [self presentViewController:alerCtl animated:YES completion:nil];
    }
}



- (IBAction)clickGoPay:(UIButton *)sender {
    [self sendOrderStatusApiComplite:^{
        //已经被取消
        if ([self.orderDetailModel.status isEqualToString:@"0"]) {
            [self.view ug_showSpeialToastWithToast:@"您的订单已被取消,请前往订单详情查看"];
            [self popToSuperView];
        //已经被支付
        }else  if ([self.orderDetailModel.status isEqualToString:@"2"]){
            [self.view ug_showSpeialToastWithToast:@"您的订单已支付,请前往订单详情查看"];
            [self popToSuperView];
            //已经被支付
        }else if([self.orderDetailModel.status isEqualToString:@"1"]){
            [self doPay];
        }
    }];
}

//检查当前用户的支付方式是否和卖家的匹配
- (BOOL)checkPayModeMatch {
    
    UGUserInfoModel *infoModel = [UGManager shareInstance].hostInfo.userInfoModel;
    NSString *tips = nil;
    
    if ([self isBankPay] && !infoModel.hasBankBinding) {
        tips = @"您的支付方式与卖家不匹配，请前往绑定银行卡！";
    }
    
    if ([self isWechaPay] && !infoModel.hasWechatPay) {
        tips = @"您的支付方式与卖家不匹配，请前往绑定微信支付！";
    }
    
    if ([self isAliPay] && !infoModel.hasAliPay) {
        tips = @"您的支付方式与卖家不匹配，请前往绑定支付宝！";
    }
    
    if ([self isUnionPay] && !infoModel.hasUnionPay) {
        tips = @"您的支付方式与卖家不匹配，请前往绑定云闪付！";
    }
    
    if (tips != nil) {
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"绑定支付方式" message:tips cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                if ([tips containsString:@"银"]) { //银行卡
                    [self.navigationController pushViewController:[UGBankPaySettingViewController new] animated:YES];
                } else  { //绑定微信、支付宝、云闪付
                    UGWechaPayViewController *wechatPayVC = [UGWechaPayViewController new];
                    wechatPayVC.payType = [tips containsString:@"支付宝"] ? UGPayTypeAliPay : ( [tips containsString:@"微信"] ? UGPayTypeWeChatPay : UGPayTypeUnionPay);
                    [self.navigationController pushViewController:wechatPayVC animated:YES];
                }
            }
        }];
        return NO;
    }
    return YES;
}


#pragma mark - 是否为银行支付
- (BOOL)isBankPay {
    if ([[self selectPayWayModel] isKindOfClass:[UGBankInfoModel class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - 是否微信支付

- (BOOL)isWechaPay {
    if ([[self selectPayWayModel] isKindOfClass:[UGWechatPayModel class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - 支付宝支付

- (BOOL)isAliPay {
    if ([[self selectPayWayModel] isKindOfClass:[UGAlipayModel class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - 云闪付支付

- (BOOL)isUnionPay {
    if ([[self selectPayWayModel] isKindOfClass:[UGUnionModel class]]) {
        return YES;
    }
    return NO;
}


//上个页面选择的支付方式模型
- (id)selectPayWayModel {
    NSArray *paylist = [self.orderDetailModel payModeList];
    if (self.payIndex < paylist.count) {
        return paylist[self.payIndex];
    }
    return nil;
}


- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}



@end
