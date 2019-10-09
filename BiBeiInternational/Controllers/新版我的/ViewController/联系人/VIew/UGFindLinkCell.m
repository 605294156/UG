//
//  UGFindLinkCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGFindLinkCell.h"

@implementation UGFindLinkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 点击头像
- (IBAction)clickHeader:(id)sender {
    if (self.headClick) {
        self.headClick();
    }
}

#pragma mark - 添加
- (IBAction)addLinkMan:(id)sender {
    if (self.addClick) {
        self.addClick();
    }
}

@end
