//
//  UGPaymentCompletedView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPaymentCompletedView.h"


@interface UGPaymentCompletedView ()

/**
 商品名
 */
@property (weak, nonatomic) IBOutlet UILabel *commdityLabel;
/**
 订单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
/**
 支付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;

@end

@implementation UGPaymentCompletedView

+(instancetype)fromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"UGPaymentCompletedView" owner:nil options:nil].firstObject;
}

-(void)setOrderModel:(UGOrder *)orderModel{
    self.commdityLabel.text = [NSString stringWithFormat:@"商品名称 ：%@", orderModel.goodsName];
    
    self.orderSnLabel.text = [NSString stringWithFormat:@"订单号     ：%@", orderModel.orderSn];
    
    self.payNumLabel.text = [NSString stringWithFormat:@"支付金额 ：%@", [orderModel.tradeUgNumber ug_amountFormat]];
}

- (IBAction)clickComplete:(UIButton *)sender {
    if (self.completeHanlde) {
        self.completeHanlde();
    }
}


@end
