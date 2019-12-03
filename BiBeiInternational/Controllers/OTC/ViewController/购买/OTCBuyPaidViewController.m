//
//  OTCBuyPaidViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCBuyPaidViewController.h"
#import "OTCComplaintViewController.h"
#import "UIButton+Expand.h"
#import "UGPayMethodView.h"
#import "UGOTCBankInfoView.h"
#import "UGAssetsViewController.h"
#import "MJPhotoBrowser.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGPayCodeView.h"
#import "UGNewGuidStatusManager.h"
#import "UGOrderDetailApi.h"
#import "UGShowQRVC.h"
#import "UGAffirmAppealLimitTimeApi.h"

@interface OTCBuyPaidViewController ()

@property (weak, nonatomic) IBOutlet UIButton *complaintButton;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;
//中间按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonConstraint;
//右边按钮宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightButtonConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatButtonConstraintW;

//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：2.06777 BTC≈ 100.00CNY
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：已付款
@property (weak, nonatomic) IBOutlet UIImageView *orderStatuaImage;

//@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 红色圆圈view
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//等待卖家放币
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY


//支付信息
@property (weak, nonatomic) IBOutlet UIView *orderContainerView;//订单信息容器
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderContainerHeight;//订单容器高度

@property (weak, nonatomic) IBOutlet UIImageView *payWayImageView;//支付方式图标
@property (weak, nonatomic) IBOutlet UILabel *payWayNameLabel;//支付方式 例如：支付宝

@property (weak, nonatomic) IBOutlet UILabel *payeeLabel;//收款人姓名 例如：Mary Chen

@property (weak, nonatomic) IBOutlet UILabel *collectionAccountNameLabel;//收款账号 银行卡要更改为：收款银行
@property (weak, nonatomic) IBOutlet UILabel *collectionAccountLabel;//收款账号 例如：支付宝账号、银行名

@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;//收款码 银行卡要更改为 收款支行
@property (weak, nonatomic) IBOutlet UIButton *codeButton;//收款码 银行卡显示为 支行名称

//订单信息
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;//订单金额 例如：100 CNY
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：1.675.03 CNY/BTC
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量 例如：0.87557 BTC
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号 例如：0875456433
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//订单时间 例如：2018-10-09 17:21:34
@property(nonatomic, strong) UGOTCBankInfoView *bankNoView;//收款银行卡号   卡号 view
@property(nonatomic,strong) UGPayCodeView *payCodeView; //付款验证码  view

//手续费高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonH;
//手续费距离顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonTop;
//手续费
@property (weak, nonatomic) IBOutlet UILabel *commissonLabel;

/**
 订单完成时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderReleaseTimeLabel;

/**
 订单完成时间高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderReleaseTimeH;

/**
 聊天按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chatButton;


@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型

@property (nonatomic,strong)MXRGuideMaskView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payTypeWithd;

@property (nonatomic,assign)BOOL isShow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountH;

//申诉结果
@property (weak, nonatomic) IBOutlet UIView *appealResultView;
//申诉结果高度计算相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appealResultViewHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *appealResultLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *orderDetailScrolllView;

//新增支付宝账号显示完全与复制的需求相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCoudeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBeforebanckCoude;
@property (weak, nonatomic) IBOutlet UIImageView *tsLine;

//订单返还
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backConsH;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@end

@implementation OTCBuyPaidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"等待放币";
    self.buttonBottomConstraint.constant += UG_SafeAreaBottomHeight;
    [self drawLineOfDashByCAShapeLayer:self.tsLine lineLength:5 lineSpacing:3 lineColor:HEXCOLOR(0xefefef) lineDirection:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    
    if (@available(iOS 11.0, *)) {
        self.orderDetailScrolllView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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

//获取信息详情
- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
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
    self.accountNameLabel.text = isBankPay ? @"收款支行" : @"收款码";
    //更改订单详情容器高度
    if (isBankPay) { //银行卡
        self.orderContainerHeight.constant += 54;
        self.bankNoView = [UGOTCBankInfoView fromXib];
        [self.orderContainerView addSubview:self.bankNoView];
        [self.bankNoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.collectionAccountNameLabel.mas_leading);
            make.top.equalTo(self.collectionAccountLabel.mas_bottom).mas_offset(26);
            make.height.mas_equalTo(54);//height = 15
            make.trailing.equalTo(self.collectionAccountLabel.mas_trailing);
        }];
        
        self.payCodeView = [UGPayCodeView fromXib];
        [self.orderContainerView addSubview:self.payCodeView];
        [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.collectionAccountNameLabel.mas_leading);
            make.top.equalTo(self.bankNoView.mas_bottom).mas_offset(26);
            make.height.equalTo(@14);//height = 15
            make.trailing.equalTo(self.collectionAccountLabel.mas_trailing);
        }];
        
    }else{
        self.orderContainerHeight.constant +=15*2;
        self.payCodeView = [UGPayCodeView fromXib];
        [self.orderContainerView addSubview:self.payCodeView];
        [self.payCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.accountNameLabel.mas_leading);
            make.top.equalTo(self.accountNameLabel.mas_bottom).mas_offset(26);
            make.height.mas_equalTo(self.accountNameLabel.mas_height);//height = 15
            make.trailing.equalTo(self.codeButton.mas_trailing);
        }];
    }
    
    //已完成状态
    if ([self.orderDetailModel.status isEqualToString:@"3"]) {
        self.tipLabel.hidden = YES;//隐藏 等待卖家放币显示
        self.cancleButton.backgroundColor = [UIColor colorWithHexString:@"66AEF9"];
        [self.cancleButton setTitle:@"查看我的资产" forState:UIControlStateNormal];
        [self.centerButtonConstraint ug_changeMultiplier:1];
        self.complaintButton.superview.hidden = YES;
        
        //新修改 隐藏查看我的资产
        self.cancleButton.hidden = YES;
        [self.chatButtonConstraintW ug_changeMultiplier:1];
        
    }else if ([self.orderDetailModel.status containsString:@"2"]) {
        //已付款 只有申诉按钮
        CGFloat multiplier = (kWindowW-20) / kWindowW;
        [self.rightButtonConstraintW ug_changeMultiplier:multiplier];
        self.cancleButton.hidden = YES;
    }
    
    if ([self.orderDetailModel.status containsString:@"2"] && ![[NSUserDefaultUtil GetDefaults:@"haveIsBuyGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].OTCBuyStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[OTCBuyPaidViewController class]]) {
            return;
        }
        @weakify(self);
        self.isShow = YES;
        [self setupHavePayNewGuideViewWithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
        }];
    }
}

#pragma mark - 更新view上的数据
- (void)updateViewsData {
    //顶部信息
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
    //对方收款方式
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
    self.orderStatuaImage.image =[UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];

    //订单信息
    [self updatePayInfoViewsData];
    
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
    self.commissonTop.constant = show ? 14.0f : 0.0f;
    self.commissonLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.commission, self.orderDetailModel.unit];

    //订单完成时间
    self.orderReleaseTimeLabel.text = self.orderDetailModel.releaseTime;
    //已完成才显示订单完成时间、其它状态隐藏
    self.orderReleaseTimeH.constant = [self.orderDetailModel.status isEqualToString:@"3"] ? 16.0f : 0.0f;
    
    if ([self.orderDetailModel.sysBuy isEqualToString:@"1"]) {
        //系统回购
        self.accountConstraint.constant = 0.0f;
        self.collectionAccountNameLabel.hidden = YES;
        self.collectionAccountLabel.hidden = YES;
        self.accountH.constant = 0.0f;
        self.bankNoView.banckCyL.hidden = YES;
        self.bankNoView.bankCityLabel.hidden = YES;
//        self. orderContainerHeight.constant = 0.0;
//        self.orderContainerView.hidden = YES;
        [self.bankNoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.collectionAccountNameLabel.mas_leading);
            make.top.equalTo(self.collectionAccountLabel.mas_bottom).mas_offset(15);
            make.height.mas_equalTo(20);//height = 15
            make.trailing.equalTo(self.collectionAccountLabel.mas_trailing);
        }];
        
    }
    
    //判断当前订单是否申诉成功 0失败 1 成功
    if ([self.orderDetailModel.isAppealSuccess isEqualToString:@"0"] || [self.orderDetailModel.isAppealSuccess isEqualToString:@"1"]) {
        self.appealResultViewHeightLayout.constant = [UG_MethodsTool heightWithWidth:[UIScreen mainScreen].bounds.size.width-44 font:13 str:self.orderDetailModel.appealResult]+50;
        if (self.orderDetailModel.appealResult) {
            self.appealResultLabel.text = self.orderDetailModel.appealResult;
        }else
        {
            self.appealResultLabel.text = @"";
        }
        self.appealResultView.hidden = NO;
    }
    else
    {
        self.appealResultView.hidden = YES;
    }
    
    if ([self.orderDetailModel.appeal.status isEqualToString:@"2"]) {
        [self.complaintButton setTitle:@"重新申诉" forState:UIControlStateNormal];
    }else{
        [self.complaintButton setTitle:@"申诉" forState:UIControlStateNormal];
    }
    
    //订单返还
    if ([self.orderDetailModel.status isEqualToString:@"3"]) {
        BOOL showDealRestitution  = ! UG_CheckStrIsEmpty(self.orderDetailModel.dealRestitution);
        self.backConsH.constant = showDealRestitution ? 16.0f : 0.0f;
        self.backConsTop.constant = showDealRestitution ? 14.0f : 0.0f;
        self.backLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.dealRestitution, self.orderDetailModel.unit];
    }else{
        self.backConsH.constant = 0.0f;
        self.backConsTop.constant = 0.0f;
    }
}

//更新支付view的数据
- (void)updatePayInfoViewsData {
    //支付方式名
    NSString *payName = [self isUnionPay] ? @"云闪付" : @"微信";
    //收款账号 例如：支付宝账号、银行名
    NSString *account = [UG_MethodsTool encryptionWord:[self isUnionPay] ? self.orderDetailModel.payInfo.unionPay.unionNo : self.orderDetailModel.payInfo.wechatPay.wechat];
    //收款码 银行卡显示为 支行名称
    NSString *code = @"";
    //收款方式图标 默认微信图标
    UIImage *payicon =[self isUnionPay] ?  [UIImage imageNamed:@"pay_union"] : [UIImage imageNamed:@"pay_wechat"];
    
    if ([self isAliPay]) {
        payName = @"支付宝";
        if ([self isCardVip]) {
             account = self.orderDetailModel.payInfo.alipay.aliNo;
        }else{
            //新需求：支付宝账号需要显示完全
            account = self.orderDetailModel.payInfo.alipay.aliNo;
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

    } else if ([self isBankPay]) {
        payName = @"银行卡";
        account = self.orderDetailModel.payInfo.bankInfo.bank;
        code = self.orderDetailModel.payInfo.bankInfo.branch;
        //银行卡图标
        payicon = [UIImage imageNamed:@"pay_bank"];
    }
    
    //支付方式图标
    self.payWayImageView.image = payicon;
    //支付方式 例如：支付宝
    self.payWayNameLabel.text = payName;
    //收款人姓名 例如：张三
    self.payeeLabel.text = self.orderDetailModel.payInfo.realName;
    //收款码 银行卡显示为 银行名称
    self.collectionAccountLabel.text = account;
    //支行名 or 放大显示二维码图标
    [self.codeButton setImage:[self isBankPay] ? nil : [UIImage imageNamed:@"code_code"] forState:UIControlStateNormal];
    if (![self isBankPay]) {
//        [self.codeButton setImageEdgeInsets:UIEdgeInsetsMake(0, UG_SCREEN_WIDTH - 14*2 - 36 - 40 - 10, 0, 0)];
        //[self.codeButton setTitle: code forState:UIControlStateNormal];
        //self.codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
//    else {
//        [self.codeButton setImageEdgeInsets:UIEdgeInsetsMake(0, UG_SCREEN_WIDTH - 14*2 - 36 - 40 - 10, 0, 0)];
//    }
    
    //银行卡号
    if ([self isBankPay]) {
        [self.bankNoView.bankNoBtn setTitle:self.orderDetailModel.payInfo.bankInfo.cardNo forState:UIControlStateNormal];
        @weakify(self);
        self.bankNoView.copClickBlock = ^{
            @strongify(self);
            if (UG_CheckStrIsEmpty(self.bankNoView.bankNoBtn.titleLabel.text))
                return;
            [UIPasteboard generalPasteboard].string =self.bankNoView.bankNoBtn.titleLabel.text;
            [self.view ug_showToastWithToast:@"复制成功！"];
        };
        self.bankNoView.bankCityLabel.text = [NSString stringWithFormat:@"%@  %@",!UG_CheckStrIsEmpty(self.orderDetailModel.payInfo.bankInfo.bankProvince) ?  self.orderDetailModel.payInfo.bankInfo.bankProvince : @"", !UG_CheckStrIsEmpty(self.orderDetailModel.payInfo.bankInfo.bankCity) ? self.orderDetailModel.payInfo.bankInfo.bankCity : @""];
        self.payTypeWithd.constant = 30;
    }
    
    if (self.payCodeView) {
        [self.payCodeView.codeLabel setTitle:self.orderDetailModel.referenceNumber forState:UIControlStateNormal];
        @weakify(self);
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


#pragma mark - 收到新消息

- (void)receiveNewIMMessage:(BOOL)hasNewMessage {
    UIImage *image = hasNewMessage ? [UIImage imageNamed:@"OTC_message-1"] : [UIImage imageNamed:@"OTC_news"];
    [self.chatButton setImage:image forState:UIControlStateNormal];
}

- (IBAction)clickComplaint:(UIButton *)sender {
    OTCComplaintViewController *complaintVC = [OTCComplaintViewController new];
    complaintVC.orderSn = self.orderSn;
    if ([self.orderDetailModel.appeal.status isEqualToString:@"2"]) {
        complaintVC.reSubmit = YES;
    }else{
        complaintVC.reSubmit = NO;
    }
    [self.navigationController pushViewController:complaintVC animated:YES];
    return;
    [self sendOrderStatusApiComplite:^{
        //已申诉中
        if ([self.orderDetailModel.status isEqualToString:@"4"]) {
            [self doOpration:@"您的订单已被申诉,请前往订单详情查看"];
        }else if([self.orderDetailModel.status isEqualToString:@"0"]){
            [self doOpration:@"您的订单已被取消,请前往订单详情查看"];
        }else{
            UGAffirmAppealLimitTimeApi *api = [UGAffirmAppealLimitTimeApi new];
            api.orderSn = self.orderSn;
            @weakify(self);
            [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
                @strongify(self);
                if (object) {
                    OTCComplaintViewController *complaintVC = [OTCComplaintViewController new];
                    complaintVC.orderSn = self.orderSn;
                    if ([self.orderDetailModel.appeal.status isEqualToString:@"2"]) {
                        complaintVC.reSubmit = YES;
                    }else{
                        complaintVC.reSubmit = NO;
                    }
                    [self.navigationController pushViewController:complaintVC animated:YES];
                }else{
                    [self.view ug_showToastWithToast:apiError.desc];
                }
            }];
        }
    }];
}

-(void)doOpration:(NSString *)str{
    [self.view ug_showSpeialToastWithToast:str];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
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
             self.orderStatuaImage.image =[UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];
        }
        complite();
    }];
}

- (IBAction)clickMessage:(UIButton *)sender {
    [self pushToChatViewController];
}

- (IBAction)clickCancle:(UIButton *)sender {
    
    //已完成订单状态，查看资产
    if ([self.orderDetailModel.status isEqualToString:@"3"]) {
        [self.navigationController pushViewController:[UGAssetsViewController new] animated:YES];
    } else { //取消订单
        [self cancelOroderWithOrderSn:self.orderSn handle:^{
            
        }];
    }
}

//收款码
- (IBAction)clickVerificationCode:(UIButton *)sender {
    if ([self isWechaPay] || [self isAliPay] || [self isUnionPay]) {
        //二维码
        NSString *qrCodeUrl = [self isWechaPay] ? self.orderDetailModel.payInfo.wechatPay.qrWeCodeUrl : ([self isAliPay] ? self.orderDetailModel.payInfo.alipay.qrCodeUrl : self.orderDetailModel.payInfo.unionPay.qrUnionCodeUrl) ;
        //放大显示收款码
        if (qrCodeUrl != nil) {
            UGShowQRVC *vc = [[UGShowQRVC alloc] init];
            vc.qrCodeUrl = qrCodeUrl;
            [self.navigationController pushViewController:vc animated:YES];
//            [MJPhotoBrowser showOnlineImages:@[qrCodeUrl] currentItem:qrCodeUrl];
        }
    }
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

- (BOOL)isUnionPay {
    if ([[self selectPayWayModel] isKindOfClass:[UGUnionModel class]]) {
        return YES;
    }
    return NO;
}

//上个页面选择的支付方式模型
- (id)selectPayWayModel {
    //买家选择的支付方式
    NSString *selectedPay = self.orderDetailModel.orderPayMode;

    if (selectedPay != nil) {
        
        if ([selectedPay isEqualToString:@"银行卡"]) {
            
            return self.orderDetailModel.payInfo.bankInfo;
            
        } else if ([selectedPay isEqualToString:@"微信"]) {
            
            return self.orderDetailModel.payInfo.wechatPay;
            
        } else if ([selectedPay isEqualToString:@"支付宝"]) {
            
            return self.orderDetailModel.payInfo.alipay;
            
        }else if ([selectedPay isEqualToString:@"云闪付"]) {
            
            return self.orderDetailModel.payInfo.unionPay;
        }
    }
    NSArray *paylist = [self.orderDetailModel payModeList];

    if (self.payIndex < paylist.count) {
        return paylist[self.payIndex];
    }
    return nil;
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
    if ([self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"]) {
        NSString *qrstring = self.orderDetailModel.alipay.aliNo;
        if (UG_CheckStrIsEmpty(qrstring))
            return;
        [UIPasteboard generalPasteboard].string = qrstring;
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}


@end
