//
//  bannerDesktopShortcutCell.m
//  BiBeiInternational
//
//  Created by keniu on 2019/5/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "bannerDesktopShortcutCell.h"

@implementation bannerDesktopShortcutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([UG_MethodsTool is4InchesScreen]) {
        self.messageLabel.font = UG_AutoFont(self.messageLabel.font.pointSize);
    }
}

@end
