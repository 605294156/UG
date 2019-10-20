//
//  UGSafeCenterCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/12.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSafeCenterCell.h"

@implementation UGSafeCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)isOpen:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) {
        UISwitch *sw = (UISwitch *)sender;
        if (self.isOpenSwitchBlock) {
            if (sw.isOn) {
                self.isOpenSwitchBlock(YES);
            }else{
                self.isOpenSwitchBlock(NO);
            }
        }
    }
}

- (BOOL)useCustomStyle{
    return NO;
}

@end
