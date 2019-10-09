//
//  UGHomeRightPopViewCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/17.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeRightPopViewCell.h"

@implementation UGHomeRightPopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.font =UG_AutoFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
