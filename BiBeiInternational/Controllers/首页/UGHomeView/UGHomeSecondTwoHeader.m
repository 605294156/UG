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
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line_centerx;

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
                self.line_centerx.constant = btn.centerX-15-self.line.mj_w/2;
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
    
    UIImage *normalImg = [UIImage imageNamed:@"home_none"];
    UIImage *downImg = [UIImage imageNamed:@"home_down"];
    UIImage *upImg = [UIImage imageNamed:@"home_up"];
    
    [[self.upDown rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        UIImage *img = self.upImageView.image;
        if ([UIImagePNGRepresentation(img) isEqual:UIImagePNGRepresentation(normalImg)]) {
            [self.upImageView setImage:downImg];
            self.btnClickBlock(3);
        }else if ([UIImagePNGRepresentation(img) isEqual:UIImagePNGRepresentation(downImg)]){
            [self.upImageView setImage:upImg];self.btnClickBlock(4);
        }else if ([UIImagePNGRepresentation(img) isEqual:UIImagePNGRepresentation(upImg)]){
            [self.upImageView setImage:normalImg];self.btnClickBlock(5);
        }
    }];

    [[self.price rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        UIImage *img = self.priceImageView.image;
        if ([UIImagePNGRepresentation(img) isEqual:UIImagePNGRepresentation(normalImg)]) {
            [self.priceImageView setImage:downImg];self.btnClickBlock(6);
        }else if ([UIImagePNGRepresentation(img) isEqual:UIImagePNGRepresentation(downImg)]){
            [self.priceImageView setImage:upImg];self.btnClickBlock(7);
        }else if ([UIImagePNGRepresentation(img) isEqual:UIImagePNGRepresentation(upImg)]){
            [self.priceImageView setImage:normalImg];self.btnClickBlock(8);
        }
    }];
}

@end
