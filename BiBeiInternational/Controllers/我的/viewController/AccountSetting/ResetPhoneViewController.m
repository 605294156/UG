//
//  ResetPhoneViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/3/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "ResetPhoneViewController.h"
#import "ChangePhoneViewController.h"

@interface ResetPhoneViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *certainButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;

@end

@implementation ResetPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"changePhoneNum");
    [self.certainButton setTitle:LocalizationKey(@"changePhoneNum") forState:UIControlStateNormal];
    self.phoneTitle.text = LocalizationKey(@"phoneNum");
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    
    NSString *beforeStr = [self.phoneNum substringToIndex:3];
    NSString *backStr = [self.phoneNum substringFromIndex:self.phoneNum.length- 4 ];
    self.phoneNumLabel.text = [NSString stringWithFormat:@"%@****%@",beforeStr,backStr];;
    // Do any additional setup after loading the view from its nib.
}
//MARK:--修改手机号的点击事件
- (IBAction)certainBtnClick:(UIButton *)sender {

    ChangePhoneViewController *changeVC = [[ChangePhoneViewController alloc] init];
    changeVC.phoneNum = self.phoneNum;
    [self.navigationController pushViewController:changeVC animated:YES];    
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
