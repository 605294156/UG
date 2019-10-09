//
//  ChangePhoneViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/3/21.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "ChangePhoneDetailViewController.h"

@interface ChangePhoneViewController ()
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *receivePhoneCode;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *unReceivePhoneCode;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"changeBindPhoneNum");
    self.receivePhoneCode.text = LocalizationKey(@"receivePhoneCode");
    self.tips.text = LocalizationKey(@"changeBindPhoneNumTip");
    self.unReceivePhoneCode.text = LocalizationKey(@"unReceivePhoneCode");
    // Do any additional setup after loading the view from its nib.
}
//MARK:--按钮的点击事件
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //可以接收验证码
        ChangePhoneDetailViewController *changeVC = [[ChangePhoneDetailViewController alloc] init];
        changeVC.phoneNum = self.phoneNum;
        [self.navigationController pushViewController:changeVC animated:YES];
    }else if (sender.tag == 2){
        //不可以接收验证码
        [self.view ug_showToastWithToast:LocalizationKey(@"unReceivePhoneCodeTip")];
        return;
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
