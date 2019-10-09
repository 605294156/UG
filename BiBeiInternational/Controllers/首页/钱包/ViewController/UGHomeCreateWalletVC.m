//
//  UGHomeCreateWalletVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/17.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeCreateWalletVC.h"
#import "UGInputSecretAlterView.h"

@interface UGHomeCreateWalletVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agreeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverCnstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnsConstraint;

@end

@implementation UGHomeCreateWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI{
    [self languageChange];
    self.topConstraint.constant = UG_AutoSize(35);
    self.backViewConstraint.constant = UG_AutoSize(29);
    self.agreeConstraint.constant = UG_AutoSize(15);
    self.selectedConstraint.constant = UG_AutoSize(19);
    self.serverCnstraint.constant = UG_AutoSize(15);
    self.btnsConstraint.constant = UG_AutoSize(150);
    self.backView.layer.cornerRadius = 4;
    self.backView.layer.shadowColor = [UIColor colorWithString:@"000000"].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.backView.layer.shadowOpacity = 0.2;
    self.backView.layer.shadowRadius = 3;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBord)];
    [self.view addGestureRecognizer:recognizer];
}

-(void)languageChange{
    self.title=@"创建UG钱包";
}

-(void)hideKeyBord{
    [self.nameInputTextField resignFirstResponder];
}

#pragma mark -勾选
- (IBAction)seletedBtn:(id)sender {
    self.selectedBtn.selected = ! self.selectedBtn.selected;
    if ( self.selectedBtn.selected) {
        //选中
    }else{
        //未选中
    }
}
#pragma mark -隐私条款
- (IBAction)serverClick:(id)sender {
}

#pragma mark - 创建UG钱包
- (IBAction)createWallet:(id)sender {
    UGInputSecretAlterView *alterView = [[UGInputSecretAlterView alloc] initWithController:self.navigationController WithTitle:@"请输入UG钱包支付密码"];
    
    
    __weak typeof(alterView)_alterView = alterView;
    alterView.doneBlock  = ^(NSString * _Nonnull password) {
        NSLog(@"密码：%@",password);
//        if(![password isEqualToString:self.acountModel.passWord])
//        {
//            [_alterView ug_showToastWithToast:@"您输入的密码错误"];
//            return;
//        }
        [_alterView hide];
//        UGBackUpMnemonicWordsVC *mnemonicWord = [[UGBackUpMnemonicWordsVC alloc] init];
//        mnemonicWord.accountModel = self.acountModel;
        [NSThread sleepForTimeInterval:1.0f]; //模拟延迟状态
       [self.navigationController popToRootViewControllerAnimated:YES];
    };
    [alterView show];
}


@end
