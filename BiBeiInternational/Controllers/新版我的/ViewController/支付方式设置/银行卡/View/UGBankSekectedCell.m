//
//  UGBankSekectedCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBankSekectedCell.h"

@implementation UGBankSekectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
     self.layer.cornerRadius = 0;
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setFrame:(CGRect)frame {
    if ([self useCustomStyle]) {
        static CGFloat margin = 8;
        frame.origin.x = margin;
        frame.size.width -= 2 * frame.origin.x;
    }
    [super setFrame:frame];
}

@end
