//
//  MyAdvertisingAlterView.h
//  CoinWorld
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdvertisingAlterView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *limitNum;//限额
@property (weak, nonatomic) IBOutlet UILabel *totalNum;//总额
@property (weak, nonatomic) IBOutlet UIButton *changeButton;//修改
@property (weak, nonatomic) IBOutlet UIButton *backOnButton;//重新上架
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;//取消
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIView *advertisingBGView; //交易的View，主要设置外边框

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *myAdvertiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainNumLabel;

@end
