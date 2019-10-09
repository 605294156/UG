//
//  BindBankViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BindBankViewController.h"
#import "SelectBankNameView.h"
#import "SelectBankNameModel.h"
#import "MineNetManager.h"

@interface BindBankViewController ()<SelectBankNameViewDelegate>{
    SelectBankNameView *_selectBankNameView;
}
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *branchName;
@property (weak, nonatomic) IBOutlet UITextField *bankNum;
@property (weak, nonatomic) IBOutlet UITextField *certainBankNum;
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *certainBankNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPasswordLabel;

@end

@implementation BindBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.realName.text = self.model.realName;
    if ([self.model.bankVerified isEqualToString:@"1"]) {
        //已绑定 ，可修改
        self.title = LocalizationKey(@"modifyBankNum");
        self.bankName.text = self.model.bankInfo.bank;
        self.branchName.text = self.model.bankInfo.branch;
        self.bankNum.text = self.model.bankInfo.cardNo;
        [self.saveButton setTitle:LocalizationKey(@"modify") forState:UIControlStateNormal];
    }else{
        self.title = LocalizationKey(@"setBankNum");
        [self.saveButton setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    }
    
    self.name.text = LocalizationKey(@"name");
    self.bankLabel.text = LocalizationKey(@"bankName");
    self.branchLabel.text = LocalizationKey(@"branchName");
    self.bankNumLabel.text = LocalizationKey(@"bankNum");
    self.certainBankNumLabel.text = LocalizationKey(@"certainBankNum");
    self.moneyPasswordLabel.text = LocalizationKey(@"moneyPassword");
    self.branchName.placeholder = LocalizationKey(@"inputBranchInfo");
    self.bankNum.placeholder = LocalizationKey(@"inputBankNum");
    self.certainBankNum.placeholder = LocalizationKey(@"inputCertainBankNum");
     self.moneyPassword.placeholder = LocalizationKey(@"inputMoneyPassword");
    self.moneyPassword.secureTextEntry = YES;
    
}
//MARK:--选择开户银行的点击事件
- (IBAction)selectBankName:(id)sender {
    [self selectCoinTypeView];
}
//MARK:--点击购买弹出的提示框
-(void)selectCoinTypeView{
    if (!_selectBankNameView) {
        _selectBankNameView = [[NSBundle mainBundle] loadNibNamed:@"SelectBankNameView" owner:nil options:nil].firstObject;
        _selectBankNameView.frame=[UIScreen mainScreen].bounds;
        _selectBankNameView.modelArr = [self selectBankName];
        _selectBankNameView.delegate = self;
    }
    [UIApplication.sharedApplication.keyWindow addSubview:_selectBankNameView];

}
-(void)selectBankNameModel:(SelectBankNameModel *)model{
    self.bankName.text = model.zhBankName;
}
-(NSMutableArray*)selectBankName{
    
    NSArray *zhBankName = @[@""];
     NSArray *enBankName = @[@""];
    
    NSMutableArray *bankArr = [[NSMutableArray alloc] init];
    for (int i = 0; i< zhBankName.count; i++) {
        SelectBankNameModel *bankName =[[SelectBankNameModel alloc] init];
        bankName.zhBankName = zhBankName[i];
        bankName.enBankName = enBankName[i];
        [bankArr addObject:bankName];
    }
    return bankArr;
   
}
//MARK:--保存按钮的点击事件
- (IBAction)saveBtnClick:(id)sender {
    if ([self.bankName.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputBankName")];
        return;
    }
    if ([self.branchName.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputBranchInfo")];
        return;
    }
    if ([self.bankNum.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputBankNum")];
        return;
    }
    if ([self.certainBankNum.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputCertainBankNum")];
        return;
    }
    if (![self.certainBankNum.text isEqualToString:self.bankNum.text]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"judgeBankNumAndCertainBankNum")];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMoneyPassword")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    NSString *urlStr = @"";
    if ([self.model.bankVerified isEqualToString:@"1"]) {
        //已绑定，可修改
        urlStr = @"uc/approve/update/bank";
    }else{
      urlStr = @"uc/approve/bind/bank";
    }
    [MineNetManager setBankNumForUrlString:urlStr withBank:self.bankName.text withBranch:self.branchName.text withJyPassword:self.moneyPassword.text withRealName:self.realName.text withCardNo:self.bankNum.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
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
