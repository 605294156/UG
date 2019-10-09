//
//  Adversiting3TableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/2/24.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "Adversiting3TableViewCell.h"

@implementation Adversiting3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([UG_MethodsTool is4InchesScreen]) {
        self.leftLabel.font = UG_AutoFont(self.leftLabel.font.pointSize);
        self.centerLabel.font = UG_AutoFont(self.centerLabel.font.pointSize);
        self.rightLabel.font = UG_AutoFont(self.rightLabel.font.pointSize);
        self.leftSpaceLayout.constant = 8;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
