//
//  UGGoogleStepFourCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGGoogleStepFourCell.h"

@implementation UGGoogleStepFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark- 绑定
- (IBAction)bindingClick:(id)sender {
    if(self.bindClick)
        self.bindClick();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
