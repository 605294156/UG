//
//  UIView+Xib.m
//  ug-wallet
//
//  Created by keniu on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UIView+Xib.h"

@implementation UIView (Xib)

- (CGFloat)kCornerRadius {
    return self.layer.cornerRadius;
}
- (void)setKCornerRadius:(CGFloat)kCornerRadius {
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = (kCornerRadius > 0);
}

- (CGFloat )kBorderWidth {
    return self.layer.borderWidth;
}
- (void)setKBorderWidth:(CGFloat)kBorderWidth {
    self.layer.borderWidth = kBorderWidth;
}

- (UIColor *)gBorderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setGBorderColor:(UIColor *)gBorderColor {
    self.layer.borderColor = [gBorderColor CGColor];
}

@end
