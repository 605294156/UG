//
//  UGTipsView.m
//  BiBeiInternational
//
//  Created by XiaoCheng on 21/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGTipsView.h"

@implementation UGTipsView

- (instancetype) initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, kWindowW, kWindowH);
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UGTipsView" owner:nil options:nil] objectAtIndex:0];
        self.mj_h = frame.size.height;
        self.mj_w = frame.size.width;
        self.mj_x = frame.origin.x;
        self.mj_y = frame.origin.y;
    }
    return self;
}

@end
