//
//  UGHomeSecondTwoHeader.m
//  BiBeiInternational
//
//  Created by XiaoCheng on 11/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGHomeSecondTwoHeader.h"

@interface UGHomeSecondTwoHeader ()
@property (weak, nonatomic) IBOutlet UIButton *ug;
@property (weak, nonatomic) IBOutlet UIButton *eth;
@property (weak, nonatomic) IBOutlet UIButton *usdt;
@property (weak, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIButton *upDown;
@property (weak, nonatomic) IBOutlet UIButton *price;

@end

@implementation UGHomeSecondTwoHeader

+(UGHomeSecondTwoHeader *)instanceUGHomeSecondTwoHeaderWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGHomeSecondTwoHeader" owner:nil options:nil];
    UGHomeSecondTwoHeader*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    return headerView;
}

- (void)awakeFromNib {@weakify(self)
    [super awakeFromNib];
    // Initialization code
    
    void (^moveAnimation)(UIButton *btn) = ^(UIButton *btn){
        [UIView animateWithDuration:.2 animations:^{
            if (!btn.selected) {@strongify(self)
                self.ug.selected = NO;
                self.eth.selected = NO;
                self.usdt.selected = NO;
                btn.selected = YES;
                self.line.centerX = btn.centerX;
                if (self.btnClickBlock) {
                    self.btnClickBlock(btn.tag-1000);
                }
            }
        }];
    };
    
    [[self.ug rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        moveAnimation(self.ug);
    }];

    [[self.eth rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        moveAnimation(self.eth);
    }];

    [[self.usdt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        moveAnimation(self.usdt);
    }];

    [[self.upDown rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)

    }];

    [[self.price rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)

    }];
}

@end
