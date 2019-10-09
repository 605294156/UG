//
//  AccountImageTableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AccountImageTableViewCell.h"

@implementation AccountImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];   
    self.headTitle.text = LocalizationKey(@"HeadPortrait");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
