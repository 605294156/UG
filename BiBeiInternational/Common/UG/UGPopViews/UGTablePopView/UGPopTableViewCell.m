//
//  UGPopTableViewCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGPopTableViewCell.h"

@implementation UGPopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 选择按钮
- (IBAction)selectedClick:(id)sender {
}

-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
