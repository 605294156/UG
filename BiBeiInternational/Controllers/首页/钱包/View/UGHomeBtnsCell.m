//
//  UGHomeBtnsCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeBtnsCell.h"

@implementation UGHomeBtnsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (IBAction)btnsClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(clickWithIndex:)]) {
        [self.delegate clickWithIndex:(int)btn.tag - 100];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
