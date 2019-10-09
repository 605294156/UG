//
//  UGInputSecretAlterView.h
//  ug-wallet
//
//  Created by conew on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGInputSecretAlterView : UGBaseView
@property(nonatomic,copy)void (^doneBlock)(NSString *password);
/**
 *  初始化调用
 */
-(instancetype)initWithController:(UIView *)controller WithTitle:(NSString *)title;


/**
 *  初始化调用
 */
-(instancetype)initWithTitle:(NSString *)title;


/**
 *  显示弹框
 */
- (void)show;

/**
 *  隐藏弹框
 */
-(void)hide;

@end

NS_ASSUME_NONNULL_END
