//
//  OTCCancelledDetailsVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCCancelledDetailsVC.h"
#import "UGPayMethodView.h"

@interface OTCCancelledDetailsVC ()

//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：9999.00 UG
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：已付款
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImage;//订单状态 例如：已付款

//@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 红色圆圈view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouxuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouxuTop;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLabel;


//订单信息
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;//订单金额 例如：100 CNY
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：1.675.03 CNY/BTC
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量 例如：0.87557 BTC
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号 例如：0875456433
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//订单创建时间 例如：2018-10-09 17:21:34
@property (weak, nonatomic) IBOutlet UILabel *orderCompleteTimeLabel;//订单完成时间 例如：2018-10-09 17:21:34
@property (weak, nonatomic) IBOutlet UILabel *orderCompleteL;

@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

//申诉结果
@property (weak, nonatomic) IBOutlet UIView *appealResultView;
//申诉结果高度计算相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appealResultViewHeightLayout;
@property (weak, nonatomic) IBOutlet UILabel *appealResultLabel;


@end

@implementation OTCCancelledDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单详情";
    //控制返回
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"back_icon" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        //打开侧滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (IBAction)onChatCan:(id)sender {
    [self pushToChatViewController];
}

#pragma mark - Request

- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
    [self updateViewsData];
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
    //手续费的处理 根据当前是否返回手续费显示  广告方有手续费
    BOOL show = [self.orderDetailModel.commission doubleValue] > 0;
    self.shouxuHeight.constant = show ? 16.0f : 0.0f;
    self.shouxuTop.constant = show ? 10.0f : 0.0f;
    self.shouxuLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.commission,   self.orderDetailModel.unit];
    self.backViewHeightConstraint.constant = show ?  245.0 : 215.0;
    
    //对方收款方式   
    UGPayInfoModel *payInfos = [UGPayInfoModel new];
    if (self.orderDetailModel.bankInfo) {
        payInfos.bankInfo = self.orderDetailModel.bankInfo;
    }
    if (self.orderDetailModel.alipay) {
        payInfos.alipay = self.orderDetailModel.alipay;
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
    //订单创建时间 例如：2018-10-09 17:21:34
    self.orderTimeLabel.text = self.orderDetailModel.createTime;
    
    if ([[self.orderDetailModel statusConvertToString]  isEqualToString:@"申诉中"]) {
        self.orderCompleteL.hidden = YES;
        self.orderCompleteTimeLabel.hidden = YES;
//        self.chatBtn.hidden = NO;
        self.backViewHeightConstraint.constant = show ?  245.0-30 : 215.0-30;
    }else{
        //订单完成时间 例如：2018-10-09 17:21:34
        self.orderCompleteTimeLabel.text = self.orderDetailModel.cancelTime;
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
//    self.platformBackLabel.hidden = ! [self.orderDetailModel.sysBuy isEqualToString:@"1"];
}


@end
