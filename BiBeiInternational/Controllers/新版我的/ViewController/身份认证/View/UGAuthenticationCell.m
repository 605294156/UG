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
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusTrailing;

@end

@implementation UGAuthenticationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (BOOL)useCustomStyle{
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//需要修改传入model
-(void)updateTitle:(NSInteger )title {
    self.titleLabel.textType = title;
}

#define color_1  HEXCOLOR(0xff7d37)//去认证
#define color_2  HEXCOLOR(0xcccccc)//未认证
#define color_3  HEXCOLOR(0xa3b5dd)//认证完成
- (void) setIconType:(NSInteger)iconType{
    self.statusLabel.textColor = color_1;
    if (iconType==1) {
        self.authenticationIcon.image = [UIImage imageNamed:@"mine_shimingrenzheng"];
        self.arrow.hidden = NO;
        self.statusTrailing.constant = 34;
    }else if (iconType==2){
       self.authenticationIcon.image = [UIImage imageNamed:@"mine_authentication_zhong"];
        self.arrow.hidden = NO;
        self.statusTrailing.constant = 34;
    }else if (iconType==3){
        self.authenticationIcon.image = [UIImage imageNamed:@"mine_authentication_shibai"];
        self.arrow.hidden = NO;
        self.statusTrailing.constant = 34;
    }else if (iconType==4){
        self.authenticationIcon.image = [UIImage imageNamed:@"mine_authentication_wancheng"];
        self.arrow.hidden = YES;
        self.statusTrailing.constant = 20;
        self.statusLabel.textColor = color_3;
    }else if (iconType==0){
        self.authenticationIcon.image = nil;
        self.arrow.hidden = YES;
        self.statusTrailing.constant = 20;
        self.statusLabel.text = @"未认证";
        self.statusLabel.textColor = color_2;
    }
}



@end
