//
//  UGHelpCenterCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGHelpCenterCell.h"

@interface UGHelpCenterCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UGHelpCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
