//
//  UIView+Xib.h
//  ug-wallet
//
//  Created by keniu on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Xib)



/**
 圆角度数
 */
@property (nonatomic) IBInspectable CGFloat kCornerRadius;

/**
 边框粗细
 */
@property (nonatomic) IBInspectable CGFloat kBorderWidth;

/**
 边框颜色
 */
@property (nonatomic, copy) IBInspectable UIColor *gBorderColor;



@end

NS_ASSUME_NONNULL_END
