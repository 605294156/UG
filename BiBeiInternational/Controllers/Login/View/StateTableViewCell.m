//
//  StateTableViewCell.m
//  BiBeiInternational
//
//  Created by XiaoCheng on 26/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "StateTableViewCell.h"

@interface StateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *s_title;
@property (weak, nonatomic) IBOutlet UILabel *s_phone;

@end

@implementation StateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UGAreaModel *)model{
    self.s_title.text = model.zhName;
    self.s_phone.text = model.areaCode;
}
@end
