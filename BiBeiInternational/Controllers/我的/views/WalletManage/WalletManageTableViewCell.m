//
//  WalletManageTableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "WalletManageTableViewCell.h"

@implementation WalletManageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.availableTitleWidth.constant = (kWindowW-170)/2;
    self.chargeMoneyButtonWidth.constant = (kWindowW-1-40)/2;

    self.availableLabel.text = LocalizationKey(@"availableCoin");
    self.freezeLabel.text = LocalizationKey(@"freezeCoin");
}
- (IBAction)btnClick:(UIButton *)sender {
    if ([_model.clickIndex isEqualToString:@"1"]) {
        _model.clickIndex = @"0";
    }else{
       _model.clickIndex = @"1";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonIndex:withModel:)]) {
        [self.delegate buttonIndex:_index withModel:_model];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
