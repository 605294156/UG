//
//  OTCOrderCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCOrderCell.h"
#import "UGPayMethodView.h"

@interface OTCOrderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//UG兑换CNY比例
@property (weak, nonatomic) IBOutlet UILabel *limitedLabel;//最低交易- 最高交易量 max_limit    min_limit
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//出售的总价
@property (weak, nonatomic) IBOutlet UGPayMethodView *payMethodView;//支付方式

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *card_vBtn;

@end

@implementation OTCOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buyButton.buttonStyle = UGButtonStyleBlue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)bugClick:(UGButton *)sender {
    if (self.buyClickHandle) {
        self.buyClickHandle(sender);
    }
}


- (void)setIsBuy:(BOOL)isBuy {
    _isBuy = isBuy;
    [self.buyButton setTitle:isBuy ? @"购买" : @"出售" forState:UIControlStateNormal];

}

- (void)setModel:(UGOTCAdModel *)model {
    _model = model;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    self.nameLabel.text = model.username;
    //成交量：| 成功率
    self.tradingNumLabel.text = [NSString stringWithFormat:@"交易量 %@ | 成功率 %@", model.achieve, model.successRate];
    //兑换比例
    self.priceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元", model.price];
    //限量
    self.limitedLabel.text = [NSString stringWithFormat:@"限量：%@ - %@ 元",model.minLimit, model.maxLimit];
    //出售总价
    self.totalLabel.text = [NSString stringWithFormat:@"%@ UG",model.remainAmount];
    //支付方式
    self.payMethodView.payWays = [model.payMode componentsSeparatedByString:@","];

    //更新支付方式的View总宽度
    self.payViewWidth.constant = self.payMethodView.viewWidth;
    //1 承兑商发布的交易 显示V  0 普通用户发布的交易
    self.card_vBtn.hidden = [model.cardMember isEqualToString:@"0"];
}

- (void)dealloc {

}

@end
