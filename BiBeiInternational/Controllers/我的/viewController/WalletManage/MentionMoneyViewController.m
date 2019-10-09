//
//  MentionMoneyViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/7.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MentionMoneyViewController.h"
#import "MineNetManager.h"
#import "MentionCoinInfoModel.h"
#import "AddMentionCoinAddressViewController.h"
#import "UITextView+Placeholder.h"

@interface MentionMoneyViewController ()<UITextFieldDelegate,AddMentionCoinAddressViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *availableCoinNum; //可用货币数量
@property (weak, nonatomic) IBOutlet UILabel *availableCoinType;//可用货币类型
@property (weak, nonatomic) IBOutlet UITextView *mentionMoneyAddress;//提币地址
@property (weak, nonatomic) IBOutlet UIButton *QrCodeButton;//二维码按钮
@property (weak, nonatomic) IBOutlet UITextField *numTextField;//数量中的货币数
@property (weak, nonatomic) IBOutlet UILabel *numCoinType;//数量中的货币类型
@property (weak, nonatomic) IBOutlet UIButton *allButton;//全部按钮
@property (weak, nonatomic) IBOutlet UITextField *poundageNum;//手续费
@property (weak, nonatomic) IBOutlet UITextField *accountNum;//到账数量
@property (weak, nonatomic) IBOutlet UILabel *accountNumCoinType;//到账数量货币的类型
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;//资金密码
@property(nonatomic,strong)NSMutableArray *mentionCoinArr;
@property(nonatomic,strong)MentionCoinInfoModel *model;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UILabel *mentionCoinAdddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *mentionButton;

@end

@implementation MentionMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"mentionMoney");
    self.availableCoinType.text = self.unit;
    self.accountNumCoinType.text = self.unit;
    self.numCoinType.text = self.unit;
    self.mentionMoneyAddress.placeholder = LocalizationKey(@"inputAddAdress");
    self.numTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyPassword.secureTextEntry = YES;
    [self mentionCoinInfo];
    
    self.availableLabel.text = LocalizationKey(@"availableCoin");
    self.mentionCoinAdddressLabel.text = LocalizationKey(@"mentionMoneyAddress");
    self.amountLabel.text = LocalizationKey(@"amount");
    self.feeLabel.text = LocalizationKey(@"poundage");
    self.amountNumLabel.text = LocalizationKey(@"mentionMoneyAmount");
    self.moneyPasswordLabel.text = LocalizationKey(@"moneyPassword");
    [self.mentionButton setTitle:LocalizationKey(@"mentionMoney") forState:UIControlStateNormal];
     [self.allButton setTitle:LocalizationKey(@"total") forState:UIControlStateNormal];
    [self.QrCodeButton setTitle:LocalizationKey(@"addAddress") forState:UIControlStateNormal];
    self.accountNum.placeholder = LocalizationKey(@"inputMentionMonneyAmount");
    self.moneyPassword.placeholder = LocalizationKey(@"inputMoneyPassword");
    
}
//MARK:--整理数据
-(void)arrageData{
    for (MentionCoinInfoModel *mentionModel in self.mentionCoinArr) {
        NSLog(@"--%@",mentionModel.unit);
        if ([mentionModel.unit isEqualToString:self.unit]) {
            self.model = mentionModel;
            self.availableCoinNum.text = self.model.balance;
            self.numTextField.placeholder = [NSString stringWithFormat:@"%@<=%@",LocalizationKey(@"mentionMoneyAmount"),self.model.balance];

            self.poundageNum.text = [ToolUtil formartScientificNotationWithString:self.model.maxTxFee];
            self.poundageNum.enabled = NO;
            
            self.numTextField.delegate = self;
            self.poundageNum.delegate = self;
        }
    }
}
//MARK:--获取提币信息
-(void)mentionCoinInfo{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager mentionCoinInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSLog(@"--%@",resPonseObj);
                //[self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                NSArray *dataArr = [MentionCoinInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.mentionCoinArr addObjectsFromArray:dataArr];
                
                [self arrageData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
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
- (NSMutableArray *)mentionCoinArr {
    if (!_mentionCoinArr) {
        _mentionCoinArr = [NSMutableArray array];
    }
    return _mentionCoinArr;
}
/*
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.numTextField == textField) {
        //提币数量
        if (![textField.text isEqualToString:@""]){
            if (![self.poundageNum.text isEqualToString:@""]){
                self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];
            }
        }else{
            self.accountNum.text = @"";
        }
    }else if (self.poundageNum == textField){
        if (![textField.text isEqualToString:@""]){
            if (![self.numTextField.text isEqualToString:@""]){
                self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];
            }
        }else{
           self.accountNum.text = @"";
        }
    }
}
 */

- (IBAction)changeTF:(UITextField *)sender {
    if (self.numTextField == sender) {
        //提币数量
        if (![sender.text isEqualToString:@""]){
            if (![self.poundageNum.text isEqualToString:@""]){
                self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];
            }
        }else{
            self.accountNum.text = @"";
        }
    }else if (self.poundageNum == sender){
        if (![sender.text isEqualToString:@""]){
            if (![self.numTextField.text isEqualToString:@""]){
                self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];
            }
        }else{
            self.accountNum.text = @"";
        }
    }
}


//MARK:--按钮的点击事件
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1){
        AddMentionCoinAddressViewController *addressVC = [[AddMentionCoinAddressViewController alloc] init];
        addressVC.delegate = self;
        addressVC.addressInfoArr = self.model.addresses;
        [self.navigationController pushViewController:addressVC animated:YES];

    }else if (sender.tag == 2){
        //点击全部按钮
        self.numTextField.text = self.model.balance;
        self.accountNum.text = [NSString stringWithFormat:@"%f",[self.numTextField.text floatValue]-[self.poundageNum.text floatValue]];        
    }else if (sender.tag == 3){
        //点击提币
        NSLog(@"点击提币");
        [self submitInfo];
    }
}
//MARK:--添加地址的回调方法
-(void)AddAdressString:(NSString *)addAdressString{
    self.mentionMoneyAddress.text = addAdressString;
}
//MARK:--提币点击事件
-(void)submitInfo{
    if ([self.mentionMoneyAddress.text isEqualToString:@""]) {
         [self.view ug_showToastWithToast:LocalizationKey(@"inputMentionAddress")];
        return;
    }
    if ([self.numTextField.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMentionAmount")];
        return;
    }
    if ([self.numTextField.text floatValue] > [self.model.balance floatValue]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"mentionMoneyTip3")];
        return;
    }
    if ([self.poundageNum.text isEqualToString:@""]){
        [self.view ug_showToastWithToast:LocalizationKey(@"inputFee")];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]){
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMoneyPassword")];
        return;
    }
    NSString *remark = @"";
    for (AddressInfo *address in self.model.addresses) {
        if ([self.mentionMoneyAddress.text isEqualToString:address.address]) {
            remark = address.remark;
        }
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager mentionCoinApplyForUnit:self.model.unit withAddress:self.mentionMoneyAddress.text withAmount:self.numTextField.text withFee:self.poundageNum.text withRemark:remark withJyPassword:self.moneyPassword.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSLog(@"--%@",resPonseObj);
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
               [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
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
