//
//  CALayer+UGLayerColor.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "CALayer+UGLayerColor.h"

@implementation CALayer (UGLayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

-(void)setShadowUIColor:(UIColor *)shadowUIColor{
    self.shadowColor = shadowUIColor.CGColor;
}
@end
