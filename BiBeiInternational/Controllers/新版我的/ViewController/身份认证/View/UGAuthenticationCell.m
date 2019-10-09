//
//  UGAuthenticationCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAuthenticationCell.h"

@interface UGAuthenticationCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UGAuthenticationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//需要修改传入model
-(void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}



@end
