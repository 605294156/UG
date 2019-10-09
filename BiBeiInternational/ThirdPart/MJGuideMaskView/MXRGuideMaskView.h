//
//  MXRGuideMaskView.h
//  MJGuideMaskView
//
//  Created by MinJing_Lin on 2018/7/30.
//  Copyright © 2018年 MinJing_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXRGuideMaskView : UIView

@property (nonatomic,copy) void(^goOutBlock)(void);//跳过新手指引
@property (nonatomic,copy) void(^notSeeBlock)(BOOL isSee);//下次不再显示

/**
 初始化数据 一个个显示
 
 @param images 图片字符串
 @param imageframeArr 图片位置
 @param rectArr 矩形透明区位置
 */
- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr WithTitle:(NSArray *)titles titleFrame:(NSArray *)titleFrameArr WithNext:(NSArray *)nexts WithNextFrame:(NSArray *)nextFrame TransparentRect:(NSArray *)rectArr goOutRect:(NSArray *)goOutFrameArr notSeeRect:(NSArray *)notSeeFrameArr;

/**
 初始化数据 不规则显示
 
 @param images 图片字符串
 @param imageframeArr 图片位置 @[[NSValue valueWithCGRect:CGRectMake(20, 205, 170, 50)]]
 @param rectArr 矩形透明区位置
 @param orderArr 顺序 例：@[@2,@1,@3]
 */
- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr WithTitle:(NSArray *)titles titleFrame:(NSArray *)titleFrameArr WithNext:(NSArray *)nexts WithNextFrame:(NSArray *)nextFrame TransparentRect:(NSArray *)rectArr orderArr:(NSArray *)orderArr goOutRect:(NSArray *)goOutFrameArr notSeeRect:(NSArray *)notSeeFrameArr;

/**
 在指定view上显示蒙版（过渡动画） 不调用用此方法可使用 addSubview:自己添加展示
 */
- (void)showMaskViewInView:(UIView *)view;

/**
 *  销毁蒙版view(默认点击空白区自动销毁)
 */
- (void)dismissMaskView;

@end
