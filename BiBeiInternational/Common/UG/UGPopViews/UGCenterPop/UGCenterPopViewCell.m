//
//  UGCenterPopViewCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/24.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGCenterPopViewCell.h"

@implementation UGCenterPopViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnClick:(id)sender {
    if (self.cellClick) {
        self.cellClick(self);
    }
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

- (void)cellClick:(void(^)(UGCenterPopViewCell *viewCell))block{
    self.cellClick = _cellClick;
}

@end
