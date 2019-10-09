//
//  UGHomeCreateWalletVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/17.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGHomeCreateWalletVC : UGBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *serverBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

NS_ASSUME_NONNULL_END
