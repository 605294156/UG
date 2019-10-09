//
//  UGPassWordInputView.h
//  ug-wallet
//
//  Created by keniu on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UGPassWordInputView;

@protocol  UGPassWordInputViewDelegate<NSObject>

@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(UGPassWordInputView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(UGPassWordInputView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(UGPassWordInputView *)passWord;


@end

IB_DESIGNABLE

@interface UGPassWordInputView : UIView<UIKeyInput>

@property (assign, nonatomic) IBInspectable NSUInteger passWordNum;//密码的位数
@property (assign, nonatomic) IBInspectable CGFloat squareWidth;//正方形的大小
@property (assign, nonatomic) IBInspectable CGFloat pointRadius;//黑点的半径
@property (strong, nonatomic) IBInspectable UIColor *pointColor;//黑点的颜色
@property (strong, nonatomic) IBInspectable UIColor *rectColor;//边框的颜色
@property (weak, nonatomic) IBOutlet id<UGPassWordInputViewDelegate> delegate;
@property (strong, nonatomic, readonly) NSMutableString *textStore;//保存密码的字符串


@end

NS_ASSUME_NONNULL_END
