//
//  UGSettingPayPassWordVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "TXLimitedTextField.h"

@interface UGSettingPayPassWordVC : UGBaseViewController
@property (weak, nonatomic) IBOutlet TXLimitedTextField *passWord;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *rePassWord;
@property (weak, nonatomic) IBOutlet UIButton *haveReadBtn;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (nonatomic,assign)BOOL isRegister;
@property (nonatomic,assign)BOOL isHome;
@property (nonatomic,assign)BOOL isUserName;
@end
