//
//  MyEntrustTableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/4/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyEntrustTableViewCell.h"

@implementation MyEntrustTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeTitleWidth.constant = (kWindowW-20)/3;
    self.statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    // Initialization code
    self.timeTitle.text = LocalizationKey(@"time");
    
     
}
- (IBAction)completeBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(completeButtonIndex:)]) {
        [self.delegate completeButtonIndex:self.index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
