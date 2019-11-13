//
//  OTCPayPageVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCPayPageVC.h"
#import "UGButton.h"
#import "OTCBuyPaidViewController.h"
#import "UGOTCPayApi.h"
#import "UGOTCBankInfoView.h"
#import "UGOrderDetailModel.h"
#import "MJPhotoBrowser.h"
#import "NSString+CNYCapital.h"
#import "UIButton+Expand.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGPayCodeView.h"
#import "UGNewGuidStatusManager.h"
#import "UGOTCCanelOrderApi.h"
#import "UGShowQRVC.h"
#import "QRCodeViewModel.h"
#import "UGCreateAlipayApi.h"
//#import "UGImagePopView.h"
#import "UGCreateNewAlipayApi.h"
#import "UGOrderDetailApi.h"
#import "UGCMImagePopView.h"
#import "UGCMCopyBankInfoPopView.h"
#import "CMActualPaymentAmountPopView.h"


@interface OTCPayPageVC ()

@property (weak, nonatomic) IBOutlet UGButton *confirmBtn;
@property(strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmConstraint;

//顶部信息
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;//订单多少RMB 例如：100CNY
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;//多少数字货币 例如：≈ 100.00 BTC
@property (weak, nonatomic) IBOutlet UILabel *capitalLabel;//人民币大写 例如：壹佰元整
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：待付款
@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 蓝色圆圈view

//订单信息
@property (weak, nonatomic) IBOutlet UIView *orderContainerView;//订单信息容器
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderContainerHeight;//订单容器高度
@property (weak, nonatomic) IBOutlet UIImageView *payWayImageView;//支付方式图标
@property (weak, nonatomic) IBOutlet UILabel *payWayNameLabel;//支付方式 例如：支付宝
@property (weak, nonatomic) IBOutlet UILabel *payeeLabel;//收款人姓名 例如：Mary Chen
@property (weak, nonatomic) IBOutlet UILabel *collectionAccountNameLabel;//收款账号 银行卡要更改为：收款银行
@property (weak, nonatomic) IBOutlet UILabel *collectionAccountLabel;//收款账号 例如：支付宝账号、银行名
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;//收款码 银行卡要更改为 收款支行
@property (weak, nonatomic) IBOutlet UIButton *codeButton;//收款码 银行卡显示为 支行名称
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;//同意协议按钮
@property(nonatomic, strong) UGOTCBankInfoView *bankNoView;//收款银行卡号   卡号 view
@property(nonatomic,strong) UGPayCodeView *payCodeView; //付款验证码 view

//底部信息倒计时
@property (weak, nonatomic) IBOutlet UILabel *bottomTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redBack;
@property (weak, nonatomic) IBOutlet UIImageView *time_icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewWith;
@property (nonatomic, strong) NSString *messageID;
@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型
@property (nonatomic,strong) MXRGuideMaskView *maskView;
@property (nonatomic,assign)BOOL isShow;
//新增支付宝账号显示完全与复制的需求相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCoudeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBeforebanckCoude;

@property(nonatomic,strong)UIImageView *payAccountImageView;
//获取银行编号
@property(nonatomic,copy)NSString *bankCode;
@property(nonatomic,assign)NSInteger count;
@property (weak, nonatomic) IBOutlet UILabel *cmRealPayMoneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmRealPayMoneyLabelHeight;


@end

@implementation OTCPayPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置新手指引
    [self setGuideView];
    self.title = @"购买UG";
    self.count = 0;
    self.confirmBtn.buttonStyle = UGButtonStyleBlue;
    self.confirmConstraint.constant += UG_SafeAreaBottomHeight;
    if ([UG_MethodsTool is4InchesScreen]) {
        self.confirmConstraint.constant = 10;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderFromUGNotifyListViewController:) name:@"通知消息列表进入订单详情操作" object:nil];
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:nil message:@"您确认要放弃本次交易吗 ？" cancle:@"取消订单" others:@[@"更换支付方式"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if(buttonIndex == 0){
                if (self.orderSn) {
                    [self cancelOroderWithOrderSn:self.orderSn handle:^{
                        [self popToSuperView];
                    }];
                }
            }else if (buttonIndex == 1) {
                
                if (self.cmBlock) {
                    self.cmBlock(self.orderDetailModel.money);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    
    [self setupBarButtonItemWithImageName:@"back_icon" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }

}
#pragma mark - 设置新手指引
-(void)setGuideView
{
    if (![[NSUserDefaultUtil GetDefaults:@"haveIsBuyGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].OTCBuyStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[OTCPayPageVC class]]) {
            return;
        }
        @weakify(self);
        self.isShow = YES;
        [self setupPayNewGuideViewWithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
            self.maskView.notSeeBlock = ^(BOOL isSee) {
                @strongify(self);
                if ([self isBankPay]) {
                    [self showBankAlertPopView];
                }
                
                if ([self isAliPay]){
                    //取到二维码图片
                    [self.payAccountImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.alipay.qrCodeUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                         [self alipayPersonalTransferWithQRcodeImage:image];
                    }];
//                    [self cmAlipayPersonalTransferUrlString:self.cmPersonalTransferStr];
                }
            };
            
        }];
    }
}



#pragma mark - 已经支付过了 回到OTC首页
-(void)popToSuperView{
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void) viewWillAppear:(BOOL)animated{[super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self hidenShowGuideView];
}

- (void)orderFromUGNotifyListViewController:(NSNotification *)notificaion {
    self.messageID = notificaion.object;
}

#pragma mark - Request

- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
    if ([self isBankPay]) {
        [self getBankCodeWithCardNo:self.orderDetailModel.bankInfo.cardNo];
    }
    [self updateViews];
    [self updateViewsData];
}

#pragma mark - 更新显示的View
//根据支付方式更改UI
- (void)updateViews {
    //是否为银行卡支付
    BOOL isBankPay = [self isBankPay];
    //更改U显示
    self.collectionAccountNameLabel.text = isBankPay ? @"收款银行" : @"收款账号" ;
//    self.accountNameLabel.text = isBankPay ? @"收款支行" : @"收款码";
    //更改订单详情容器高度
//    self.orderContainerHeight.constant += isBankPay ? 15*2 : 0;
    //加上银行卡号
    if (isBankPay) { //银行卡
        self.accountNameLabel.hidden = YES;
        self.codeButton.hidden = YES;
        self.orderContainerHeight.constant += 17*2+26*3;
        self.bankNoView = [UGOTCBankInfoView fromXib];
        [self.orderContainerView addSubview:self.bankNoView];
        [self.bankNoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.collectionAccountNameLabel.mas_leading);
            make.top.equalTo(self.collectionAccountLabel.mas_bottom).mas_offset(26);
            make.height.mas_equalTo(@(34+26));//height = 15
            make.trailing.equalTo(self.collectionAccountLabel.mas_trailing);
        }];
    
        self.payCodeView = [UGPayCodeView fromXib];
        [self.orderContainerView addSubview:self.payCodeView];
        [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.collectionAccountNameLabel.mas_leading);
            make.top.equalTo(self.bankNoView.mas_bottom).mas_offset(26);
            make.height.mas_equalTo(self.collectionAccountLabel.mas_height);//height = 15
            make.trailing.equalTo(self.collectionAccountLabel.mas_trailing);
        }];
    }else{
        self.orderContainerHeight.constant += 26*2;
        self.payCodeView = [UGPayCodeView fromXib];
        [self.orderContainerView addSubview:self.payCodeView];
        [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.accountNameLabel.mas_leading);
            make.top.equalTo(self.accountNameLabel.mas_bottom).mas_offset(26);
            make.height.mas_equalTo(self.accountNameLabel.mas_height);//height = 15
            make.trailing.equalTo(self.codeButton.mas_trailing);
        }];
    }
}

#pragma mark - 更新view上的数据
- (void)updateViewsData {
    //倒计时
    [self secondsCountDown];
    //顶部信息
    self.cnyLabel.text = [NSString stringWithFormat:@"%@ 元",self.orderDetailModel.money];//订单多少RMB 例如：100 CNY
    self.coinLabel.text = [NSString stringWithFormat:@"= %@ %@",self.orderDetailModel.amount, self.orderDetailModel.unit];//多少数字货币 例如：= 100.00 BTC
    self.capitalLabel.text = [self.orderDetailModel.money changetochinese];//人民币大写 例如：壹佰元整
    //订单状态
    self.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];

    //订单信息
    [self updatePayInfoViewsData];
}

//更新支付view的数据
- (void)updatePayInfoViewsData {
    //支付方式名
    NSString *payName =[self isUnionPay] ? @"云闪付" : @"微信";
    //收款账号 例如：支付宝账号、银行名
    NSString *account =[self isUnionPay] ? self.orderDetailModel.unionPay != nil ? [UG_MethodsTool encryptionWord:self.orderDetailModel.unionPay.unionNo] : @"" : self.orderDetailModel.wechatPay != nil ? [UG_MethodsTool encryptionWord:self.orderDetailModel.wechatPay.wechat] : @"";
    //收款码 银行卡显示为 支行名称
    NSString *code = @"";
    //收款方式图标 默认微信图标
    UIImage *payicon =[self isUnionPay] ? [UIImage imageNamed:@"pay_union"] : [UIImage imageNamed:@"pay_wechat"];
    if ([self isAliPay]) {
        payName = @"支付宝";
        if ([self isCardVip]) {
            //承兑商  购买时 对方支付宝账号可以看到
            account = self.orderDetailModel.alipay != nil ? self.orderDetailModel.alipay.aliNo : @"";
        }else{
            //新需求：支付宝账号需要显示完全
            account = self.orderDetailModel.alipay != nil ? self.orderDetailModel.alipay.aliNo : @"";
        }
        //支付宝图标
        payicon = [UIImage imageNamed:@"pay_ali"];
        //支付宝新增可复制
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longGes.minimumPressDuration = 0.5;//2秒（默认0.5秒）
        [longGes setNumberOfTouchesRequired:1];
        self.collectionAccountLabel.userInteractionEnabled = YES;
        [self.collectionAccountLabel addGestureRecognizer:longGes];
        //支付宝显示可复制的图片
        self.bankCoudeWidth.constant = 18;
        self.spaceBeforebanckCoude.constant = 8;
        self.payAccountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 150, 150)];
        self.payAccountImageView.image = self.QRCodeImage;
        //取到二维码图片
        [self.payAccountImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.alipay.qrCodeUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

            [self alipayPersonalTransferWithQRcodeImage:image];

        }];
//        [self cmAlipayPersonalTransferUrlString:self.cmPersonalTransferStr];
        
    } else if ([self isBankPay]) {
        payName = @"银行卡";
        if (self.orderDetailModel.bankInfo) {
            account = self.orderDetailModel.bankInfo.bank;
            code = self.orderDetailModel.bankInfo.branch;
        }
        //银行卡图标
        payicon = [UIImage imageNamed:@"pay_bank"];
        
        if (!self.isShow) {
            [self showBankAlertPopView];
        }
        
    }
    
    //支付方式图标
    self.payWayImageView.image = payicon;
    //支付方式 例如：支付宝
    self.payWayNameLabel.text = payName;
    //收款人姓名 例如：张三
    self.payeeLabel.text =self.orderDetailModel.payInfo.realName;
    //收款码 银行卡显示为 银行名称
    self.collectionAccountLabel.text = account;
    //支行名 or 放大显示二维码图标
    [self.codeButton setImage:[self isBankPay] ? nil : [UIImage imageNamed:@"code_code"] forState:UIControlStateNormal];
    if (![self isBankPay]) {
//        [self.codeButton setImageEdgeInsets:UIEdgeInsetsMake(0, UG_SCREEN_WIDTH - 14*2 - 36 - 40 - 10, 0, 0)];
       // [self.codeButton setTitle: code forState:UIControlStateNormal];
       // self.codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
//    else {
//        [self.codeButton setImageEdgeInsets:UIEdgeInsetsMake(0, UG_SCREEN_WIDTH - 14*2 - 36 - 40 - 10, 0, 0)];
//    }
    
    //银行卡号
    if ([self isBankPay]) {
        [self.bankNoView.bankNoBtn setTitle:self.orderDetailModel.bankInfo.cardNo forState:UIControlStateNormal];
        @weakify(self);
        self.bankNoView.copClickBlock = ^{
            @strongify(self);
            if (UG_CheckStrIsEmpty(self.bankNoView.bankNoBtn.titleLabel.text))
                return;
            [UIPasteboard generalPasteboard].string =self.bankNoView.bankNoBtn.titleLabel.text;
            [self.view ug_showToastWithToast:@"复制成功！"];
        };
        self.bankNoView.bankCityLabel.text = [NSString stringWithFormat:@"%@  %@",!UG_CheckStrIsEmpty(self.orderDetailModel.bankInfo.bankProvince) ?  self.orderDetailModel.bankInfo.bankProvince : @"", !UG_CheckStrIsEmpty(self.orderDetailModel.bankInfo.bankCity) ? self.orderDetailModel.bankInfo.bankCity : @""];
        self.payViewWith.constant = 30;
    }
    
    if (self.payCodeView) {
          @weakify(self);
        [self.payCodeView.codeLabel setTitle:self.orderDetailModel.referenceNumber forState:UIControlStateNormal];
        self.payCodeView.copyClickBlock = ^{
             @strongify(self);
            if (UG_CheckStrIsEmpty(self.payCodeView.codeLabel.titleLabel.text))
                return;
            [UIPasteboard generalPasteboard].string =self.payCodeView.codeLabel.titleLabel.text;
            [self.view ug_showToastWithToast:@"复制成功！"];
        };
        self.payCodeView.quesetionClickBlock = ^{
            NSString *message = @"付款验证码是您的支付凭证，为保证您的交易顺利无纠纷，请您在付款时，填写于付款备注中！";
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"什么是付款验证码？" message:message cancle:@"确定" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            }];
        };
    }
}




//倒计时剩余支付时间
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
            NSMutableAttributedString *timeStr = [self getMMSSFromSS:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.bottomTimeLabel.attributedText = timeStr;
//                if ([timeStr isEqualToString:@"00:00:00"]) {
//                    self.bottomTimeLabel.hidden = YES;
//                    self.redBack.hidden = YES;
//                    self.time_icon.hidden = YES;
//                }
            });
            timeout--;
            }
    });
    dispatch_resume(self.timer);
}

//传入 秒  得到 xx:xx:xx
-(NSMutableAttributedString *)getMMSSFromSS:(int)totalTime{
    int seconds = totalTime;
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",seconds%60];
    //format of time
    NSString *format_time;
    if ([str_second isEqualToString:@"00"]) {
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }else{
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    
    NSString *inFront = @"请在";
    NSString *inBack = @"内付款给商家";

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",inFront,format_time,inBack]];
    [attString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(255, 255, 255, .9) range:NSMakeRange(0, attString.length)];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, inFront.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:17] range:NSMakeRange(inFront.length, format_time.length)];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(attString.length-inBack.length, inBack.length)];
    
    return attString;
}

//- (void)updateBottomTimelabel:(NSString *)text timeString:(NSString *)timeString{
//    UIColor *strColor = [UIColor whiteColor];
//    NSDictionary * norAttris = @{NSForegroundColorAttributeName:strColor,NSFontAttributeName:[UIFont systemFontOfSize:12]};
//    NSMutableAttributedString * mutableAttriStr = [[NSMutableAttributedString alloc]initWithString:text attributes:norAttris];
//    NSDictionary * attris = @{NSForegroundColorAttributeName:strColor, NSFontAttributeName: [UIFont systemFontOfSize:14]};
//    NSRange range = [text rangeOfString:timeString];
//    [mutableAttriStr setAttributes:attris range:range];
//    self.bottomTimeLabel.attributedText = mutableAttriStr;
//}

#pragma mark - 确认付款
- (IBAction)clickConfirm:(UGButton *)sender {
    if (!self.checkBoxButton.selected) {
        [self.view ug_showToastWithToast:@"请同意我已了解"];
        return;
    }
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"转账确认" message:@"请您确认已向卖方转账， 恶意操作将会冻结账户！本系统只做转账记录，无任何扣款行为！" cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        if (buttonIndex == 1) {
            @strongify(self);
            [self sendPayRequest];
        }
    }];
}

#pragma mark - 支付接口
- (void)sendPayRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCPayApi *api = [UGOTCPayApi new];
    api.orderSn = self.orderSn;
    api.payMode = [[self selectPayWayModel] isKindOfClass:[UGAlipayModel class]] ? @"支付宝" : [[self selectPayWayModel] isKindOfClass:[UGWechatPayModel class]] ? @"微信" :  ( [[self selectPayWayModel] isKindOfClass:[UGUnionModel class]] ? @"云闪付" : @"银行卡");
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            //发送订单完成更改消息列表中的数据状态消息
            if (self.messageID.length > 0) {[[NSNotificationCenter defaultCenter] postNotificationName:@"订单完成更改消息列表中的数据状态" object:self.messageID];}
            //订单详情
            OTCBuyPaidViewController *vc = [OTCBuyPaidViewController new];
            vc.payIndex = self.payIndex;
            vc.orderSn = self.orderSn;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        //已经支付或者被取消了 就返回OTC 首页
        if (apiError.errorNumber == 508) {
            [self popToSuperView];
        }
    }];
}

//收款码放大显示
- (IBAction)clickVerificationCode:(UIButton *)sender {
    if ([self isWechaPay] || [self isAliPay] || [self isUnionPay]) {
        //二维码
        NSString *qrCodeUrl = [self isWechaPay] ? self.orderDetailModel.wechatPay.qrWeCodeUrl : ([self isUnionPay] ? self.orderDetailModel.unionPay.qrUnionCodeUrl : self.orderDetailModel.alipay.qrCodeUrl) ;
        //放大显示收款码
        if (qrCodeUrl != nil) {
            UGShowQRVC *vc = [[UGShowQRVC alloc] init];
            vc.qrCodeUrl = qrCodeUrl;
            [self.navigationController pushViewController:vc animated:YES];
//            [MJPhotoBrowser showOnlineImages:@[qrCodeUrl] currentItem:qrCodeUrl];
        }
    }
}

//点击协议
- (IBAction)clickProtocol:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)tapProtocol:(UITapGestureRecognizer *)sender {
    self.checkBoxButton.selected = !self.checkBoxButton.selected;
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

#pragma mark - 云闪付

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//支付宝新增可复制
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSString *qrstring = self.orderDetailModel.alipay.aliNo;
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}

- (IBAction)accountCopy:(id)sender {
    NSString *qrstring = self.orderDetailModel.alipay.aliNo;
    if (UG_CheckStrIsEmpty(qrstring))
        return;
    [UIPasteboard generalPasteboard].string = qrstring;
    [self.view ug_showToastWithToast:@"复制成功！"];
}

#pragma mark - 获取银行代码
-(void)getBankCodeWithCardNo:(NSString*)cardNo
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=%@&cardBinCheck=true",cardNo]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"bank dic = %@",dict);
            self.bankCode = dict[@"bank"];
        }
        else
        {
            self.count++;
            if (self.count <3)
            {
                [self getBankCodeWithCardNo:self.orderDetailModel.bankInfo.cardNo];
            }
            
        }
    }];
    //5.执行任务
    [dataTask resume];
    
}

#pragma mark - 自动放币相关-彩盟接口返回后刷新订单数据
//获取信息详情
- (void)cmRefreshOrderDetailRequest {
    UGOrderDetailApi *api = [UGOrderDetailApi new];
    api.orderSn = self.orderSn;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        NSLog(@"object = %@",object);
        if (object) {
            UGOrderDetailModel *detailModel = [UGOrderDetailModel mj_objectWithKeyValues:object];
            self.orderDetailModel = detailModel;
            //顶部信息
            self.cnyLabel.text = [NSString stringWithFormat:@"%@ 元",self.orderDetailModel.money];//订单多少RMB 例如：100 CNY
            self.coinLabel.text = [NSString stringWithFormat:@"= %@ %@",self.orderDetailModel.amount, self.orderDetailModel.unit];//多少数字货币 例如：= 100.00 BTC
            self.capitalLabel.text = [self.orderDetailModel.money changetochinese];//人民币大写 例如：壹佰元整
            self.cmRealPayMoneyLabel.hidden = NO;
            self.cmRealPayMoneyLabelHeight.constant = 17;
            self.cnyLabel.textColor = [UIColor redColor];
            self.cnyLabel.font = [UIFont boldSystemFontOfSize:21];
            
            [self showCMActualPaymentAmountPopView];
//          [self showUGCMCopyBankInfoPopView];

        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark -自动放币相关-实际支付确认弹窗
-(void)showCMActualPaymentAmountPopView
{
    [[CMActualPaymentAmountPopView shareInstance]showCMActualPaymentAmountPopViewWithUGOrderDetailModel:self.orderDetailModel andConfirmlButtonTittle:@"我知道了"];
    
}
#pragma mark -自动放币相关-订单金额变动提醒  ！！！！！！弃用
-(void)showUGCMCopyBankInfoPopView
{
    [[UGCMCopyBankInfoPopView shareInstance] showUGCMCopyBankInfoPopViewWithUGOrderDetailModel:self.orderDetailModel andConfirmlButtonTittle:@"确认" confirmBlock:^(NSInteger type) {
        NSLog(@"Type = %zd",type);
       NSString *qrstring = @"";
        switch (type) {
            case 1:
            {
                qrstring = self.orderDetailModel.money;
            }
            break;
            case 2:
            {
                qrstring = self.orderDetailModel.payInfo.realName;
            }
            break;
            case 3:
            {
                qrstring = self.orderDetailModel.bankInfo.cardNo;
            }
            break;
            case 4:
            {
                qrstring = self.orderDetailModel.bankInfo.bank;
            }
            break;
            default:
                break;
        }
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
    }];
}

#pragma mark - 自动放币相关-彩盟接口对接
-(void)createCmAlipayStringRequest
{
    UGCreateNewAlipayApi *api = [UGCreateNewAlipayApi new];
    api.merOrderNo = self.orderSn;
    api.amount = self.orderDetailModel.money;
    api.payType = @"0";
    api.cardNo = self.orderDetailModel.bankInfo.cardNo;
    api.appId = @"09999988";
    api.bankName = self.orderDetailModel.bankInfo.bank;
    api.bankAccount = [self.orderDetailModel.type integerValue]==0 ? self.orderDetailModel.payInfo.realName : self.orderDetailModel.reveiveInfo.realName;
    api.remarks = @"";
    api.bankMark = self.bankCode;
    api.money =self.orderDetailModel.money;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (apiError.errorNumber==0) {
            NSLog(@"object = %@",object);
            NSDictionary *dic = object;
            NSString *htmlString = dic[@"url"];
            [self alipayBankCardTransferWithHTMLString:htmlString];
        }
        else
        {
            UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"支付宝跳转失败，请您使用已绑定银行卡 %@ 自行转账到对方银行卡！",[UGManager shareInstance].hostInfo.userInfoModel.member.cardNo] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [alerCtl addAction:cancelAction];
            [self presentViewController:alerCtl animated:YES completion:nil];
        }
    }];
}


#pragma mark -自动放币相关：彩盟银行卡转账到银行卡
-(void)cmBankcardToBanckcard
{
    UGCreateNewAlipayApi *api = [UGCreateNewAlipayApi new];
    api.merOrderNo = self.orderSn;
    api.payType = @"4";
    api.appId = @"09999988";
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (apiError.errorNumber == 0) {
            NSLog(@"object = %@",object);
            NSDictionary *dic = object;
            NSInteger type = [dic[@"type"] integerValue];
            if (type == 1)
            {
              [self cmRefreshOrderDetailRequest];
            }
        }
        else
        {
            if (apiError.errorNumber != 10)
            {
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }
    }];
}

#pragma mark - 自动放币相关-彩盟银行卡到银行卡跳转Safari信息展示
-(void)cmToShowBankInfoInSafariWithHTMLString:(NSString *)htmlString
{
    if (!UG_CheckStrIsEmpty(htmlString))
    {
        //检查银行卡信息链接是否可以访问
        NSURL *url = [NSURL URLWithString:htmlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 10;
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            //Code 200 链接可以正常访问，其他情况将无法跳转支付宝，提示用户自行转账
            if (httpResponse.statusCode == 200)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 打开链接
                    if (@available(iOS 10.0, *))
                    {
                        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
                    }
                    else
                    {
                    [[UIApplication sharedApplication] openURL:url];
                    }
                });
            }
            else
            {

            }
        }];
        //5.执行任务
        [dataTask resume];
    }
}


#pragma mark - 自动放币相关：彩盟支付宝个人转账
-(void)cmAlipayPersonalTransferUrlString:(NSString *)urlString
{
    if (!UG_CheckStrIsEmpty(urlString))
    {
        NSURL * alipay_app_url = [NSURL URLWithString:@"alipay://"];
        BOOL alipay = [[UIApplication sharedApplication] canOpenURL:alipay_app_url];
        if (alipay) {
            // 向个人转账
            NSString *url = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",urlString];
            // 打开链接
            if (@available(iOS 10.0, *))
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
    }
    else
    {
         //不需要处理，前一个界面已经有弹窗提示。
    }
}

#pragma mark - 请求转账到银行卡的二维码信息
-(void)getAlipayBankInfoHtmlRequest
{
    UGCreateAlipayApi *api = [[UGCreateAlipayApi alloc]init];
    api.appId = @"09999988";
    api.cardNo = self.orderDetailModel.bankInfo.cardNo;
    api.bankAccount = [self.orderDetailModel.type integerValue]==0 ? self.orderDetailModel.payInfo.realName : self.orderDetailModel.reveiveInfo.realName;
    api.bankMark = self.bankCode;
    api.bankName = self.orderDetailModel.bankInfo.bank;
    api.money = self.orderDetailModel.money;
    api.amount = self.orderDetailModel.money;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (apiError.errorNumber==0) {
            NSString *htmlString = object;
            [self alipayBankCardTransferWithHTMLString:htmlString];
        }
        else
        {
            UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付宝跳转失败" message:apiError.desc preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"银行卡转账" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"再试一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getAlipayBankInfoHtmlRequest];
            }];
            [alerCtl addAction:cancelAction];
            [alerCtl addAction:confirmAction];
            [self presentViewController:alerCtl animated:YES completion:nil];
        }
    }];
}


#pragma mark - 支付宝银行卡转账弹窗
-(void)showBankAlertPopView{
//    [[UGImagePopView shareInstance]showAlertPopViewWithDes:@"请使用支付宝或银行卡，转帐至对方银行卡。请按照指定金额支付，否则订单将会延迟处理！" andType:1  andCancelButtonTittle:@"银行卡转账" andConfirmlButtonTittle:@"支付宝支付" cancelBlock:^{
//        NSLog(@"自行使用银行卡转账");
//        [self cmBankcardToBanckcard];
//    } confirmBlock:^{
////        [self getAlipayBankInfoHtmlRequest];
//          [self createCmAlipayStringRequest];
//    }];
    
    [[UGCMImagePopView shareInstance]showAlertPopViewWithTittle:@"支付提醒" andCancelButtonTittle:@"银行卡转账" andConfirmlButtonTittle:@"支付宝支付" cancelBlock:^{
        NSLog(@"自行使用银行卡转账");
       [self cmBankcardToBanckcard];
    } confirmBlock:^{
        // [self getAlipayBankInfoHtmlRequest];
        [self createCmAlipayStringRequest];
    }];
}



#pragma mark - 支付宝银行卡快捷转账
-(void)alipayBankCardTransferWithHTMLString:(NSString *)htmlString
{
    if (!UG_CheckStrIsEmpty(htmlString))
    {
        //检查银行卡信息链接是否可以访问
        NSURL *url = [NSURL URLWithString:htmlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 10;
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            //Code 200 链接可以正常访问，其他情况将无法跳转支付宝，提示用户自行转账
            if (httpResponse.statusCode == 200)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSURL * alipay_app_url = [NSURL URLWithString:@"alipay://"];
                    //判断是否安装支付宝
                    BOOL alipay = [[UIApplication sharedApplication] canOpenURL:alipay_app_url];
                    if (alipay) {
                        // 向银行卡转账
                        NSString *url = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",htmlString];
                        // 打开链接
                        if (@available(iOS 10.0, *))
                        {
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
                        }
                        else
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                    }
                    else
                    {
                        UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"您的设备未安装支付宝！请您使用已绑定银行卡 %@ 自行转账到对方银行卡！",[UGManager shareInstance].hostInfo.userInfoModel.member.cardNo] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                        [alerCtl addAction:cancelAction];
                        [self presentViewController:alerCtl animated:YES completion:nil];
                        
                    }
                });

            }
            else
            {
                UIAlertController *alerCtl = [UIAlertController alertControllerWithTitle:@"支付提醒" message:[NSString stringWithFormat:@"支付宝跳转失败，请您使用已绑定银行卡 %@ 自行转账到对方银行卡！",[UGManager shareInstance].hostInfo.userInfoModel.member.cardNo] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                [alerCtl addAction:cancelAction];
                [self presentViewController:alerCtl animated:YES completion:nil];
            }
        }];
        //5.执行任务
        [dataTask resume];
    }

}


#pragma mark - 支付宝个人转账
-(void)alipayPersonalTransferWithQRcodeImage:(UIImage *)qrcodeImage
{
    //从二维码图片中获取转账信息
    NSString *alipayString = [QRCodeViewModel readQRCodeFromImage:qrcodeImage];
    if (!UG_CheckStrIsEmpty(alipayString)) {
        NSURL * alipay_app_url = [NSURL URLWithString:@"alipay://"];
        BOOL alipay = [[UIApplication sharedApplication] canOpenURL:alipay_app_url];
        if (alipay) {
            // 向个人转账
            NSString *url = [NSString stringWithFormat:@"alipayqr://platformapi/startapp?saId=10000007&qrcode=%@",alipayString];
            // 打开链接
            if (@available(iOS 10.0, *))
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }

    }
}

@end
