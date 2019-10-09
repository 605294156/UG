//
//  MyEntrustDetail2TableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/4/23.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyEntrustDetail2TableViewCell.h"

@implementation MyEntrustDetail2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftLabelTitleWidth.constant = (kWindowW-20)/4;
    self.timeLabel.text = LocalizationKey(@"time");
    self.dealPriceLabel.text = LocalizationKey(@"dealPrice");
    self.dealNum.text = LocalizationKey(@"dealNum");
    self.feeLabel.text = LocalizationKey(@"poundage");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
