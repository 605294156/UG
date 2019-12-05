//
//  OTCJpushViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCJpushViewController.h"

#import "OTCCancelledDetailsVC.h"
#import "OTCSellCoinViewController.h"
#import "OTCWaitingForPayVC.h"
#import "OTCComplaintingViewController.h"
#import "OTCBuyViewController.h"
#import "OTCBuyPaidViewController.h"


@interface OTCJpushViewController ()

@property (nonatomic, strong) UGOTCBaseViewController *vc;

@property(nonatomic, strong) UIButton *rightChatButton;//右上角聊天按钮

@end

@implementation OTCJpushViewController

- (void)viewDidLoad {@weakify(self)
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    [self setupRightButton];
    
    [self setupBarButtonItemWithImageName:@"back_icon" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    
    if (self.vc != nil) {
        return;
    }
    //出售数字货币
    BOOL orderSell = [orderDetailModel.type isEqualToString:@"1"];
//    orderDetailModel.status = @"4";
    switch ([orderDetailModel.status intValue]) {
        case 0://已取消
        {
            self.vc = [OTCCancelledDetailsVC new];
        }
            break;
        case 1://未付款
        {
            if (orderSell) { //出售数字货币
                self.vc = [OTCSellCoinViewController new];
                
            } else { //买入数字货币
                self.vc = [OTCWaitingForPayVC new];
            }
        }
            break;
        case 2://已付款
        {
            if (orderSell) { //出售数字货币
                self.vc = [OTCSellCoinViewController new];
                
            } else { //买入数字货币
                self.vc = [OTCBuyPaidViewController new];
            }
        }
            break;
        case 3://已完成
        {
            if (orderSell) {//出售数字货币
                self.vc = [OTCBuyViewController new];
            } else {//买入数字货币
                self.vc = [OTCBuyPaidViewController new];
            }
        }
            break;
        default:
        {
            //申诉方是当前用户，则进去申诉详情
            if (orderDetailModel.appeal != nil && [orderDetailModel.appeal.initiatorId isEqualToString:[UGManager shareInstance].hostInfo.userInfoModel.member.ID]) {
                self.vc = [OTCComplaintingViewController new];
                //右上角聊天入口
//                [self setupRightButton];
            } else {
                //申诉方是对方，则进去订单详情
                self.vc = [OTCCancelledDetailsVC new];
            }
        }
            break;
    }
    
    if (self.vc != nil && ![self.childViewControllers containsObject:self.vc]) {
        self.vc.orderSn = orderDetailModel.orderSn;
//        self.vc.conversation = self.conversation;
        [self addChildViewController:self.vc];
        [self.view addSubview:self.vc.view];
        [self.vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
//        UGAlipayModel *am = UGAlipayModel.new;
//        am.aliNo = @"1212";
//        am.qrCodeUrl = @"http://pic27.nipic.com/20130313/9252150_092049419327_2.jpg";
//        UGWechatPayModel *wm = UGWechatPayModel.new;
//        wm.wechat = @"232";
//        wm.qrWeCodeUrl = @"232";
//        UGUnionModel *um = UGUnionModel.new;
//        um.unionNo = @"232";
//        um.qrUnionCodeUrl = @"232";
        
        
        
        UGOrderDetailModel *model11 = orderDetailModel;
//        model11.alipay = am;
//        model11.wechatPay = wm;
//        model11.unionPay = um;
//        model11.bankInfo = nil;
        [self.vc updateViewsData:model11];
    }
}

- (void)setupRightButton {
    @weakify(self);
  self.rightChatButton = [self setupBarButtonItemWithTitle:@"客服" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self.vc pushToChatViewController];
    }];
}


#pragma mark - 收到新消息

- (void)receiveNewIMMessage:(BOOL)hasNewMessage {
    
    if (self.vc) {
        [self.vc receiveNewIMMessage:hasNewMessage];
    }
    
    if (self.rightChatButton) {
        UIImage *image = hasNewMessage ? [UIImage imageNamed:@"OTC_message-1"] : [UIImage imageNamed:@"OTC_news"];
        [self.rightChatButton setImage:image forState:UIControlStateNormal];
    }
}


- (void)dealloc {
    NSLog(@"OTCJpushViewController dealloc");
}


@end
