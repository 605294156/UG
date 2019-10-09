//
//  CALayer+UGLayerColor.h
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (UGLayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color;

-(void)setShadowUIColor:(UIColor *)shadowUIColor;

@end

NS_ASSUME_NONNULL_END
