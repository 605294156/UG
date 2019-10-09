//
//  WalletManageDetailTableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "WalletManageDetailTableViewCell.h"

@implementation WalletManageDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tradeTimeWidth.constant = (kWindowW - 29)/4;
    
    self.tradTimeLabel.text = LocalizationKey(@"tradTime");
    self.typeLabel.text = LocalizationKey(@"type");
    self.amountLabel.text = LocalizationKey(@"amount");
    self.poundage.text = LocalizationKey(@"poundage");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
