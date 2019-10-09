//
//  PaymentAccountViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PaymentAccountViewController.h"
#import "BindBankViewController.h"
#import "MineNetManager.h"
#import "PayAccountInfoModel.h"
#import "BindAliPayViewController.h"
#import "BindWeChatViewController.h"
@interface PaymentAccountViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bankStatus;
@property (weak, nonatomic) IBOutlet UILabel *alipayStatus;
@property (weak, nonatomic) IBOutlet UILabel *weChatStatus;
@property(nonatomic,strong)PayAccountInfoModel *infoModel;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliPayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNameLabel;

@end

@implementation PaymentAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"paymentAccount");
    self.bankNameLabel.text = LocalizationKey(@"bankCardAccount");
    self.aliPayNameLabel.text = LocalizationKey(@"alipayAccount");
    self.weChatNameLabel.text = LocalizationKey(@"WeChatAccount");
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
//MARK:--获取收款账户信息
-(void)getData{
     [EasyShowLodingView showLodingText:LocalizationKey(@"hardLoading")];
    [MineNetManager getPayAccountInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.infoModel = [PayAccountInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                //整理数据
                [self arrageData];
            
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//MARK:--整理获取的数据
-(void)arrageData{
    if ([self.infoModel.bankVerified isEqualToString:@"1"]) {
        //已绑定
        self.bankStatus.text = LocalizationKey(@"toModify");
        self.bankStatus.textColor = [UIColor darkGrayColor];
    }else{
        self.bankStatus.text = LocalizationKey(@"unbounded");
        self.bankStatus.textColor = baseColor;
    }
    if ([self.infoModel.aliVerified isEqualToString:@"1"]) {
        self.alipayStatus.text = LocalizationKey(@"toModify");
        self.alipayStatus.textColor = [UIColor darkGrayColor];
    }else{
        self.alipayStatus.text = LocalizationKey(@"unbounded");
        self.alipayStatus.textColor = baseColor;
    }
    if ([self.infoModel.wechatVerified isEqualToString:@"1"]) {
        self.weChatStatus.text = LocalizationKey(@"toModify");
        self.weChatStatus.textColor = [UIColor darkGrayColor];
    }else{
        self.weChatStatus.text = LocalizationKey(@"unbounded");
        self.weChatStatus.textColor = baseColor;
    }
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //银行卡账号
        NSLog(@"银行卡账号");
        BindBankViewController *bankVC = [[BindBankViewController alloc] init];
        bankVC.model = self.infoModel;
        [self.navigationController pushViewController:bankVC animated:YES];
    }else if (sender.tag == 2){
        //支付宝账号
        NSLog(@"支付宝账号");
        BindAliPayViewController *aliPayVC = [[BindAliPayViewController alloc] init];
        aliPayVC.model = self.infoModel;
        [self.navigationController pushViewController:aliPayVC animated:YES];
    }else if (sender.tag == 3){
        //微信账号
        NSLog(@"微信账号");
        BindWeChatViewController *chatVC = [[BindWeChatViewController alloc] init];
        chatVC.model = self.infoModel;
        [self.navigationController pushViewController:chatVC animated:YES];
    }else{
        //其他
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
