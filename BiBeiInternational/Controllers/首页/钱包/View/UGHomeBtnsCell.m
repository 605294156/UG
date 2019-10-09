//
//  UGHomeBtnsCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeBtnsCell.h"

@implementation UGHomeBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)reloadTitle{
    self.sanLabel.text =@"扫一扫";
    self.changeLabel.text =@"转币";
    self.receiptLabel.text =@"收币";
    self.walletrecordLabel.text =@"钱包记录";
    self.bTobLabel.text =@"币币兑换";
    self.billLabel.text =@"交易订单";
}

-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)btnsClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(clickWithIndex:)]) {
        [self.delegate clickWithIndex:(int)btn.tag - 100];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
