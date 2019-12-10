//
//  UGGoogleStepOneCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGGoogleStepOneCell.h"

@implementation UGGoogleStepOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)downLoad:(id)sender {
    if (self.downLoadBlack) {
        self.downLoadBlack();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
