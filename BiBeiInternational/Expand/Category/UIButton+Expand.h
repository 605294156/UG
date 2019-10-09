//
//  UIButton+Expand.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/20.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, UGButtonEdgeInsetsStyle) {
    UGButtonEdgeInsetsStyleTop, // image在上，label在下
    UGButtonEdgeInsetsStyleLeft, // image在左，label在右
    UGButtonEdgeInsetsStyleBottom, // image在下，label在上
    UGButtonEdgeInsetsStyleRight // image在右，label在左
};


@interface UIButton (Expand)

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(UGButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


@end

NS_ASSUME_NONNULL_END
