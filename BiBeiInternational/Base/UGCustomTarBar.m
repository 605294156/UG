//
//  UGCustomTarBar.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGCustomTarBar.h"

@interface UGCustomTarBar () {
    UIEdgeInsets _oldSafeAreaInsets;
}

@end


@implementation UGCustomTarBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _oldSafeAreaInsets = UIEdgeInsetsZero;
        //不设置会导致iPhone X上面tabbar错乱
        [self setTranslucent:NO];
        
        //改变tabbar 线条颜色
//              if (@available(iOS 13, *)) {
//                  UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
//                  appearance.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
//                  appearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
//                       // 官方文档写的是 重置背景和阴影为透明
//                  [appearance configureWithTransparentBackground];
//                  self.standardAppearance = appearance;
//              } else {
//                  self.backgroundImage = [UIImage new];
//                  self.shadowImage = [UIImage new];
//              }
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -14.0, [UIScreen mainScreen].bounds.size.width, 63.0)];
        imgView.image = [UIImage imageNamed:@"tabarBg"];
        [[UITabBar appearance] insertSubview:imgView atIndex:0];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -13.0, [UIScreen mainScreen].bounds.size.width, 63.0)];
//        lineView.backgroundColor = [UIColor yellowColor];
//        [[UITabBar appearance] insertSubview:lineView atIndex:0];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _oldSafeAreaInsets = UIEdgeInsetsZero;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];

    if (!UIEdgeInsetsEqualToEdgeInsets(_oldSafeAreaInsets, self.safeAreaInsets)) {
        [self invalidateIntrinsicContentSize];

        if (self.superview) {
            [self.superview setNeedsLayout];
            [self.superview layoutSubviews];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];

    if (@available(iOS 11.0, *)) {
        float bottomInset = self.safeAreaInsets.bottom;
        if (bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90)) {
            size.height += bottomInset;
        }
    }

    return size;
}


- (void)setFrame:(CGRect)frame {
    if (self.superview) {
        if (frame.origin.y + frame.size.height != self.superview.frame.size.height) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height;
        }
    }
    [super setFrame:frame];
}

@end
