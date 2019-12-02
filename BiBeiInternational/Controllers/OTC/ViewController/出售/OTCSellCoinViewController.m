//
//  OTCSellCoinViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCSellCoinViewController.h"
#import "OTCBuyViewController.h"
#import "UGPayMethodView.h"
#import "OTCInputJYPasswordVC.h"
#import "UGOrderDetailApi.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "MJPhotoBrowser.h"
#import "UGNewGuidStatusManager.h"

@interface OTCSellCoinViewController ()

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBottomConstraint;


//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：9999.00 UG
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：待付款
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImage;

//@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 蓝色圆圈view
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//剩余支付时间 例如：剩余14分18秒
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY


//订单信息
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;//订单金额 例如：100 CNY
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：1.675.03 CNY/BTC
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量 例如：0.87557 BTC
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号 例如：0875456433
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//订单时间 例如：2018-10-09 17:21:34

@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型
@property(strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时

//红色倒计时
@property (weak, nonatomic) IBOutlet UILabel *redTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redBack;
@property (weak, nonatomic) IBOutlet UIImageView *time_icon;


//手续费高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonH;
//手续费距离顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonTop;
//手续费
@property (weak, nonatomic) IBOutlet UILabel *commissonLabel;

//消息按钮宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageWidth;


/**
 消息按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (nonatomic,strong)MXRGuideMaskView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payImageViewW;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIButton *payCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewCons;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (nonatomic,assign)BOOL isShow;

@property (weak, nonatomic) IBOutlet UIButton *payCodeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCoudeWidth;
@property (weak, nonatomic) IBOutlet UIButton *apealBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;
@end

@implementation OTCSellCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.confirmBottomConstraint.constant += UG_SafeAreaBottomHeight;
    self.title = @"出售";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    
    if (IS_IPHONE_X) {
        self.viewTop.constant = 0.f;
        self.viewBottom.constant = SafeAreaBottomHeight;
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

#pragma mark - Request
- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
    [self updateViewsData];
}

#pragma mark - 更新显示数据
- (void)updateViewsData {
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.hisAvatar]];
    //用户名
    self.nameLabel.text = self.orderDetailModel.otherSide;
    //出售BTC
    self.orderNameLabel.text = [NSString stringWithFormat:@"%@%@", [self.orderDetailModel typeConvertToString], self.orderDetailModel.unit];
    //9999.00 UG
    self.amountLabel.text = [NSString stringWithFormat:@"%@ UG",self.orderDetailModel.amount];
    //顶部单价
    self.topPriceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元",self.orderDetailModel.price];
    
    ////对方收款方式 出售取 reveiveInfo
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
    self.payModeView.payInfoModel = payInfos;

    //订单状态
    self.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];
    self.orderStatusImage.image = [UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];
    
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
    
    //已付款 ： 消息、申诉、去放币  未付款：消息
    BOOL paid = [[self.orderDetailModel statusConvertToString] isEqualToString:@"已付款"];
    [self.messageWidth ug_changeMultiplier:!paid ? 1.0f : 0.18f];
    //手续费
    BOOL show = [self.orderDetailModel.commission doubleValue] > 0;
    self.commissonH.constant = show ? 16.0f : 0.0f;
    self.commissonTop.constant = show ? 10.0f : 0.0f;
    self.commissonLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.commission,   self.orderDetailModel.unit];
    
    //只有在已付款 显示中间信息
    if (![[self.orderDetailModel statusConvertToString] isEqualToString:@"已付款"]){
        self.centerViewHeight.constant = 0.0f;
        self.bottomViewCons.constant = 14;
        self.centerView.hidden = YES;
    }
    
//    //倒计时剩余支付时间
//    if ([[self.orderDetailModel statusConvertToString] isEqualToString:@"已付款"]){
//        self.redTimeLabel.hidden = NO;
//        self.timeLabel.text = @"等待卖家放币";
//        self.redBack.hidden = NO;
//        self.time_icon.hidden = NO;
//        [self secondsCountDown];
//    }else{
//        self.timeLabel.text = @"等待买家付款";
//        self.redTimeLabel.hidden = YES;
//        self.redBack.hidden = YES;
//        self.time_icon.hidden = YES;
//    }
    
    //付款验证码  已付款 出售 取reveiveInfo 里的付款信息
    if ([[self.orderDetailModel statusConvertToString] isEqualToString:@"已付款"]){
        self.centerView.hidden = NO;
        self.centerViewHeight.constant = 140.0f;
        self.bottomViewCons.constant = 10;
        self.payImageView.image = [self.orderDetailModel.orderPayMode isEqualToString:@"微信"] ?  [UIImage imageNamed:@"pay_wechat"] : ([self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"] ? [UIImage imageNamed:@"pay_ali"] :  ([self.orderDetailModel.orderPayMode isEqualToString:@"云闪付"] ? [UIImage imageNamed:@"pay_union"] : [UIImage imageNamed:@"pay_bank"]));//对方支付方式
        self.payType.text = self.orderDetailModel.orderPayMode;
        self.payName.text = self.orderDetailModel.reveiveInfo.realName;
        [self.payCode setTitle:self.orderDetailModel.referenceNumber forState:UIControlStateNormal];//对方参考码
        NSString *count = @"";
        if ([self.orderDetailModel.orderPayMode isEqualToString:@"微信"]) {
            count = [UG_MethodsTool encryptionWord:self.orderDetailModel.reveiveInfo.wechatPay.wechat];
        }else if ([self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"]){
            //新需求：支付宝账号需要显示完全
            count = self.orderDetailModel.reveiveInfo.alipay.aliNo;
        }else if ([self.orderDetailModel.orderPayMode isEqualToString:@"云闪付"]){
            count = [UG_MethodsTool encryptionWord:self.orderDetailModel.reveiveInfo.unionPay.unionNo];
        }else{
            count = [UG_MethodsTool encryptionWord:self.orderDetailModel.reveiveInfo.bankInfo.cardNo];
        }
        
        [self.payCodeBtn setTitle:count forState:UIControlStateNormal];
        
        if ([self.orderDetailModel.orderPayMode isEqualToString:@"银行卡"]||[self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"]) {
            self.payImageViewW.constant = 24.0f;
        }else{
            self.payCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            self.bankCoudeWidth.constant = 0;
        }
    }
    
    if ([[self.orderDetailModel statusConvertToString] isEqualToString:@"未付款"] && ![[NSUserDefaultUtil GetDefaults:@"haveIsSellGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].OTCSellStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[OTCSellCoinViewController class]]) {
            return;
        }
        @weakify(self);
        self.isShow = YES;
        [self setupDoNotPayNewGuideViewWithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
        }];
    }
    
    if ([self.orderDetailModel.sysBuy isEqualToString:@"1"]) {
        //系统回购
//        self.centerViewHeight.constant = 0.0f;
//        self.centerView.hidden = YES;
        if (UG_CheckStrIsEmpty(self.orderDetailModel.reveiveInfo.bankInfo.cardNo)) {
           [self.payCodeBtn setTitle:@"*******************" forState:UIControlStateNormal];
        }
        if (UG_CheckStrIsEmpty(self.orderDetailModel.reveiveInfo.realName)) {
            self.payName.text = @"***";
        }
//        self.redTimeLabel.hidden = NO;
//        self.redTimeLabel.text = @"平台交易订单";
//        self.redTimeLabel.textColor = [UIColor colorWithHexString:@"BBBBBB"];
    }
    
    if ([self.orderDetailModel.appeal.status isEqualToString:@"2"]) {
        [self.apealBtn setTitle:@"重新申诉" forState:UIControlStateNormal];
    }else{
        [self.apealBtn setTitle:@"申诉" forState:UIControlStateNormal];
    }
}

- (IBAction)quesetionClick:(id)sender {
    NSString *message = @"付款验证码是买方的支付凭证，为保证双方交易顺利无纠纷，请您查收付款时核对付款备注中的验证码！";
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"什么是付款验证码？" message:message cancle:@"确定" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
    }];
}

- (IBAction)copyClick:(id)sender {
    if (UG_CheckStrIsEmpty(self.payCode.titleLabel.text))
        return;
    [UIPasteboard generalPasteboard].string =self.payCode.titleLabel.text;
    [self.view ug_showToastWithToast:@"复制成功！"];
}

- (IBAction)bankCopy:(id)sender {
    if ([self.orderDetailModel.orderPayMode isEqualToString:@"银行卡"]||[self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"]) {
        if (UG_CheckStrIsEmpty(self.payCodeBtn.titleLabel.text))
            return;
        [UIPasteboard generalPasteboard].string =self.payCodeBtn.titleLabel.text;
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}


#pragma mark - 收到新消息

- (void)receiveNewIMMessage:(BOOL)hasNewMessage {
    UIImage *image = hasNewMessage ? [UIImage imageNamed:@"OTC_message-1"] : [UIImage imageNamed:@"OTC_news"];
    [self.chatButton setImage:image forState:UIControlStateNormal];
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
//                self.confirmButton.enabled = NO;
            });
        }else {
            NSString *timeStr = [self getMMSSFromSS:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [[self.orderDetailModel statusConvertToString] isEqualToString:@"已付款"] ? @"等待卖家放币" : [NSString stringWithFormat:@"请在%@内放币",timeStr];
                self.redTimeLabel.text =timeStr;
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

//聊天
- (IBAction)clickMessage:(UIButton *)sender {
    [self pushToChatViewController];
}

//申诉
- (IBAction)clickAppeal:(UIButton *)sender {
    [self sendOrderStatusApiComplite:^{
         //已付款状态
        if ([self.orderDetailModel.status isEqualToString:@"2"]) {
            if ([self.orderDetailModel.appeal.status isEqualToString:@"2"]) {
                [self pushToOrderAppealWithOrderSn:self.orderSn WithReSubmit:YES];
            }else{
               [self pushToOrderAppealWithOrderSn:self.orderSn WithReSubmit:NO];
            }
        }else{
            //别的状态
              [self doOpration];
        }
    }];
}


//放币
- (IBAction)clickConfirm:(UIButton *)sender {
    //再次获取订单详情更新状态
    [self sendOrderStatusApiComplite:^{
        //已付款状态
        if ([self.orderDetailModel.status isEqualToString:@"2"]) {
            //检查是否绑定谷歌验证码
//            if ([self hasBindingGoogleValidator]) {//2.0换手机号
                __weak typeof(self) weakSelf = self;
                [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"确认放币" message:@"请您确认已收到对方付款再进行放币，确认放币后将无法撤回！" cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                    if (buttonIndex == 1) {
                        //输入交易密码
                        OTCInputJYPasswordVC *inputJYPasswordVC = [OTCInputJYPasswordVC new];
                        inputJYPasswordVC.orderSn = weakSelf.orderSn;
                        inputJYPasswordVC.orderModel= weakSelf.orderDetailModel;
                        [weakSelf.navigationController pushViewController:inputJYPasswordVC animated:YES];
                    }
                }];
//            }
        }else{
            [self doOpration];
        }
    }];
}

-(void)doOpration{
    NSString *str = @"";
    if([self.orderDetailModel.status isEqualToString:@"4"])
    {
        str =@"您的订单已被申诉,请前往订单详情查看";
    }else if([self.orderDetailModel.status isEqualToString:@"3"]){
        str =@"您的订单已完成,请前往订单详情查看";
    }
    [self.view ug_showSpeialToastWithToast:str];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    });
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
            self.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];
            self.orderStatusImage.image = [UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];
        }
        complite();
    }];
}


- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end
