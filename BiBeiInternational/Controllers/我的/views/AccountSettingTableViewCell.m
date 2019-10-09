//
//  AccountSettingTableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AccountSettingTableViewCell.h"

@implementation AccountSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //4英寸适配
    if ([UG_MethodsTool is4InchesScreen]) {
        self.leftLabel.font = UG_AutoFont(self.leftLabel.font.pointSize);
        self.rightLabel.font = UG_AutoFont(self.rightLabel.font.pointSize);
        self.leftSpaceLayout.constant = 8;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
