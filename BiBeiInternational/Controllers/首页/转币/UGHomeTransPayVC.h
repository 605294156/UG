//
//  UGHomeTransPayVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGCodeInputView.h"

@interface UGHomeTransPayVC : UGBaseViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *acceptUser;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (weak, nonatomic) IBOutlet UGCodeInputView *passWordInputView;
@property (weak, nonatomic) IBOutlet UILabel *serverchangeLabel;

@property (nonatomic, copy) NSString *aloginName;//接收用户登录名
@property (nonatomic, copy) NSString *apayCardNo;//接收UG钱包地址
@property (nonatomic, copy) NSString *tradeAmount;//交易金额,单位UG
@property (nonatomic, copy) NSString *tradeUgNumber;//交易数量, ==交易金额
@property (nonatomic, copy) NSString *remark;//备注
@property (nonatomic, copy) NSString *chengePay;//手续费
@property(nonatomic,copy)NSString *orderType;//类型
@property(nonatomic,copy)NSString *merchNo;//商户号
@property(nonatomic,copy)NSString *orderSn;//订单号
@property(nonatomic,copy)NSString *extra;//其他信息
@end
