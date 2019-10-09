//
//  UGHomeConinToCoinVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/19.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface UGHomeConinToCoinVC : UGBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *UGCBtn;
@property (weak, nonatomic) IBOutlet UILabel *SellLabel;
@property (weak, nonatomic) IBOutlet UITextField *sellNumField;
@property (weak, nonatomic) IBOutlet UIButton *BTCBtn;
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
@property (weak, nonatomic) IBOutlet UITextField *exchangeNumField;
@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceChargeLabel;
@property (weak, nonatomic) IBOutlet UIButton *tureExchangeBtn;

@end
