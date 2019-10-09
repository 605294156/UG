//
//  UGButton.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, UGButtonStyle) {
    UGButtonStyleNone = 0,//默认从0开始
    UGButtonStyleBlue,//蓝色背景
    UGButtonStyleWhite,//白色背景
    UGButtonStyleLightblue//淡蓝色背景
};

NS_ASSUME_NONNULL_BEGIN

@interface UGButton : UIButton

/**
 设置按钮风格
 UGButtonStyleNone,//无风格
 UGButtonStyleBlue,//蓝色背景
 UGButtonStyleWhite,//白色背景
 UGButtonStyleLightblue//淡蓝色背景
 */
@property(nonatomic, assign) UGButtonStyle buttonStyle;


/**
 创建按钮

 @param style 按钮风格
 UGButtonStyleNone,//无风格
 UGButtonStyleBlue,//蓝色背景
 UGButtonStyleWhite,//白色背景
 UGButtonStyleLightblue//淡蓝色背景
 */
- (instancetype)initWithUGStyle:(UGButtonStyle)style;


@end

NS_ASSUME_NONNULL_END
