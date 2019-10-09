//
//  UIDevice+UGExpand.h
//  ug-wallet
//
//  Created by keniu on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (UGExpand)



/**
 判断当前设备是否是X系列
 目前包括iPhone X、iPhone XS、iPhone XS Max、iPhone XR
 此方法需要发布新机后更新,不适合模拟器！
 */
+ (BOOL)isIphoneXSeries;

@end

NS_ASSUME_NONNULL_END
