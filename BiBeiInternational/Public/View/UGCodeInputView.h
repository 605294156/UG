//
//  TestView.h
//  GLDemo
//
//  Created by keniu on 2018/11/15.
//  Copyright © 2018 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class UGCodeInputView;

@protocol  GLCodeInputViewDelegate<NSObject>

@optional
/**
 *  监听输入的改变
 */
- (void)codeDidChange:(UGCodeInputView *)code;

/**
 *  监听输入的完成时
 */
- (void)codeCompleteInput:(UGCodeInputView *)code;

/**
 *  监听开始输入
 */
- (void)codeBeginInput:(UGCodeInputView *)code;


@end

@interface UGCodeInputView : UIView

@property (assign, nonatomic) IBInspectable NSUInteger codeNum;//密码的位数
@property (assign, nonatomic) IBInspectable CGFloat padding;//间距大小
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;//边框线大小
@property (assign, nonatomic) IBInspectable CGFloat squareWidth;//正方形的大小
@property (strong, nonatomic) IBInspectable UIColor *noRectColor;//未输入边框的颜色
@property (strong, nonatomic) IBInspectable UIColor *inputRectColor;//已输入边框的颜色
@property (assign, nonatomic) IBInspectable CGFloat pointRadius;//密文输入的黑点x大小
@property (assign, nonatomic) IBInspectable BOOL secureText;//是否明文，非明文 输入就是小黑点 默认NO
@property (assign, nonatomic) IBInspectable BOOL showKeyBoard;//是否创建就弹出键盘 默认NO
@property (strong, nonatomic, readonly) NSString *textStore;//输入的字符串

@property (weak, nonatomic) IBOutlet id<GLCodeInputViewDelegate> delegate;


/**
 验证码颜色
 */
@property(nonatomic, strong) IBInspectable UIColor *codeColor;

/**
 验证码字号
 */
@property(nonatomic, strong) IBInspectable UIFont *codeFont;

@end

NS_ASSUME_NONNULL_END
