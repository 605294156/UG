//
//  UGPlaceholderTextView.h
//  ug-wallet
//
//  Created by keniu on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UGPlaceholderTextView : UITextView

/** 占位文字 默认:请输入内容*/
@property (nonatomic,copy) IBInspectable NSString *placeholder;
/** 占位文字颜色 默认:lightGrayColor*/
@property (nonatomic,strong) IBInspectable UIColor *placeholderColor;
/** 占位文字字体 默认:和字体一样大 */
@property (nonatomic,strong)  UIFont *placeholderFont;

@end

NS_ASSUME_NONNULL_END
