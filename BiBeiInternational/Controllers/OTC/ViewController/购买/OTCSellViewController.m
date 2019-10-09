//
//  OTCSellViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCSellViewController.h"
#import "OTCWaitingForPayVC.h"
#import "UIButton+Expand.h"
#import "UGPayMethodView.h"

@interface OTCSellViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelDealBtn;//取消交易
@property (weak, nonatomic) IBOutlet UIButton *sendCurrencyBtn;//去放币
@property(strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;

//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：9999.00 UG
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：待付款
@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 蓝色圆圈view
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//剩余支付时间 例如：剩余14分18秒
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY

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

//红色倒计时
@property (weak, nonatomic) IBOutlet UILabel *redTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redBack;
@property (weak, nonatomic) IBOutlet UIImageView *time_icon;

/**
 聊天按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型


@end

@implementation OTCSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"等待支付";
    self.buttonBottomConstraint.constant += UG_SafeAreaBottomHeight;
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
    self.topPriceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元",self.orderDetailModel.price];
    //对方收款方式
    self.payModeView.payInfoModel = self.orderDetailModel.payInfo;
    //订单状态
    self.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];
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
                //                self.goPayBtn.enabled = NO;
            });
        }else {
             NSString *timeStr = [self getMMSSFromSS:timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLabel.text = [NSString stringWithFormat:@"剩余时间  %@",timeStr];
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

//取消交易
- (IBAction)clickCancel:(UIButton *)sender {
    [self cancelOroderWithOrderSn:self.orderSn handle:^{
        
    }];
}

//私信
- (IBAction)clickMeessage:(UIButton *)sender {
    [self pushToChatViewController];
}

//去支付
- (IBAction)clickSendCurrency:(UIButton *)sender {
    [self.navigationController pushViewController:[OTCWaitingForPayVC new] animated:YES];
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}


@end
