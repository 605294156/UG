//
//  OTCBuyViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCBuyViewController.h"
#import "UGAssetsViewController.h"
#import "UIButton+Expand.h"
#import "UGPayMethodView.h"
#import "MJPhotoBrowser.h"

@interface OTCBuyViewController ()

@property (weak, nonatomic) IBOutlet UIButton *checkAssetsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;
//中间按钮宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatButtonConstrainW;

//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：9999.00 UG
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：待付款
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImage;

//@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 蓝色圆圈view
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY


//订单信息
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;//订单金额 例如：100 CNY
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：1.675.03 CNY/BTC
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量 例如：0.87557 BTC
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号 例如：0875456433
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//订单时间 例如：2018-10-09 17:21:34
/**
 订单完成时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderReleaseTimeLabel;

/**
 订单完成时间高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderReleaseTimeH;


//手续费高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonH;
//手续费距离顶部高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commissonTop;
//手续费
@property (weak, nonatomic) IBOutlet UILabel *commissonLabel;

@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型

/**
 聊天按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payImageViewW;
@property (weak, nonatomic) IBOutlet UILabel *payType;
@property (weak, nonatomic) IBOutlet UILabel *payName;
@property (weak, nonatomic) IBOutlet UIButton *payCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewHeight;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@property (weak, nonatomic) IBOutlet UIButton *payCodeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankCoudeWidth;

//申诉结果
@property (weak, nonatomic) IBOutlet UIView *appealResultView;
//申诉结果高度计算相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appealResultViewHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *appealResultLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *orderDetailScrolllView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderDetailInfoHeightLayout;

//订单返还
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backConsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backConsH;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tsLine;

@end

@implementation OTCBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttonBottomConstraint.constant += UG_SafeAreaBottomHeight;

    self.title = @"订单详情";
    
    [self drawLineOfDashByCAShapeLayer:self.tsLine lineLength:5 lineSpacing:3 lineColor:HEXCOLOR(0xefefef) lineDirection:YES];
}

#pragma mark - Request
- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
    [self updateViewsData];
}

- (IBAction)copyName:(id)sender {
    [UIPasteboard generalPasteboard].string =self.payName.text;
    [self.view ug_showToastWithToast:@"复制成功！"];
}
#pragma mark - 更新显示数据
- (void)updateViewsData {
    //只有在已完成 显示中间信息
    if (![self.orderDetailModel.status isEqualToString:@"3"]){
        self.centerViewHeight.constant = 0.0f;
        self.centerView.hidden = YES;
    }
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
    //对方收款方式 出售取 reveiveInfo
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
    //订单完成时间
    self.orderReleaseTimeLabel.text = self.orderDetailModel.releaseTime;
    //已完成才显示订单完成时间、其它状态隐藏
    self.orderReleaseTimeH.constant = [self.orderDetailModel.status isEqualToString:@"3"] ? 16.0f : 0.0f;
    //手续费
    BOOL show = [self.orderDetailModel.commission doubleValue] > 0;
    self.commissonH.constant = show ? 16.0f : 0.0f;
    self.commissonTop.constant = show ? 14.0f : 0.0f;
    self.orderDetailInfoHeightLayout.constant = show ? 250.0f : 224.0f;
    self.commissonLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.commission, self.orderDetailModel.unit];

    //已完成状态只有查看资产
    if ([self.orderDetailModel.status isEqualToString:@"3"]) {
        [self.centerButtonConstraint ug_changeMultiplier:1];
        self.checkAssetsBtn.backgroundColor = [UIColor colorWithHexString:@"66AEF9"];
        
        //新修改 隐藏查看我的资产
        self.checkAssetsBtn.hidden = YES;
        [self.chatButtonConstrainW ug_changeMultiplier:1];
    }
    
    //付款验证码
    if ([self.orderDetailModel.status isEqualToString:@"3"]){
        self.centerView.hidden = NO;
        self.centerViewHeight.constant = 140.0f;
        self.payImageView.image = [self.orderDetailModel.orderPayMode isEqualToString:@"微信"] ?  [UIImage imageNamed:@"pay_wechat"] : ([self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"] ? [UIImage imageNamed:@"pay_ali"] : ([self.orderDetailModel.orderPayMode isEqualToString:@"云闪付"] ? [UIImage imageNamed:@"pay_union"] : [UIImage imageNamed:@"pay_bank"]));//对方支付方式
        self.payType.text = self.orderDetailModel.orderPayMode ;
        self.payName.text = self.orderDetailModel.reveiveInfo.realName;
        [self.payCode setTitle:self.orderDetailModel.referenceNumber forState:UIControlStateNormal];//对方参考码
        NSString *count = @"";
        if ([self.orderDetailModel.orderPayMode isEqualToString:@"微信"]) {
            count = [UG_MethodsTool encryptionWord:self.orderDetailModel.reveiveInfo.wechatPay.wechat];
        }else if([self.orderDetailModel.orderPayMode  isEqualToString:@"支付宝"]){
            //新需求：支付宝账号需要显示完全
            count = self.orderDetailModel.reveiveInfo.alipay.aliNo;
        }else if ([self.orderDetailModel.orderPayMode  isEqualToString:@"云闪付"]){
            count = [UG_MethodsTool encryptionWord:self.orderDetailModel.reveiveInfo.unionPay.unionNo];
        }else{
            count =[UG_MethodsTool encryptionWord:self.orderDetailModel.reveiveInfo.bankInfo.cardNo];
        }
        
        [self.payCodeBtn setTitle:count forState:UIControlStateNormal];
        
        if ([self.orderDetailModel.orderPayMode isEqualToString:@"银行卡"]||[self.orderDetailModel.orderPayMode isEqualToString:@"支付宝"]) {
            self.payImageViewW.constant = 24.0f;
        }else{
            self.payCodeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            self.bankCoudeWidth.constant = 0;
        }
    }
    
    if ([self.orderDetailModel.sysBuy isEqualToString:@"1"]) {
        //系统回购
//        self. centerViewHeight.constant = 0.0;
//        self.centerView.hidden = YES;
        if (UG_CheckStrIsEmpty(self.orderDetailModel.reveiveInfo.bankInfo.cardNo)) {
            [self.payCodeBtn setTitle:@"*******************" forState:UIControlStateNormal];
        }
        if (UG_CheckStrIsEmpty(self.orderDetailModel.reveiveInfo.realName)) {
            self.payName.text = @"***";
        }
    }
    
    //     判断当前订单是否申诉成功 0失败 1 成功
    if ([self.orderDetailModel.isAppealSuccess isEqualToString:@"0"]||[self.orderDetailModel.isAppealSuccess isEqualToString:@"1"]) {
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
    
    //订单返还
    BOOL showDealRestitution  = ! UG_CheckStrIsEmpty(self.orderDetailModel.dealRestitution);
    self.backConsH.constant = showDealRestitution ? 16.0f : 0.0f;
    self.backConsTop.constant = showDealRestitution ? 14.0f : 0.0f;
    self.orderDetailInfoHeightLayout.constant = show ?   (showDealRestitution ? 250 : 233) :  (showDealRestitution ? 224 : 207);
    self.backLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.dealRestitution, self.orderDetailModel.unit];
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



- (IBAction)clickMessage:(UIButton *)sender {
    [self pushToChatViewController];
}

- (IBAction)clickCheckAssets:(UIButton *)sender {
    [self pushToAssetsViewController];
}

- (IBAction)clickAppeal:(UIButton *)sender {
    
    [self pushToOrderAppealWithOrderSn:self.orderSn WithReSubmit:NO];
}

@end
