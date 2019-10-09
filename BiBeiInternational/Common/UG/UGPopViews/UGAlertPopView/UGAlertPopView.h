//
//  UGAlertPopView.h
//  BiBeiInternational
//
//  Created by keniu on 2019/5/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^confirmBlock)(void);
//网络请求失败,带回错误
typedef void(^cancelBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface UGAlertPopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertTittleLabel;
@property (weak, nonatomic) IBOutlet UITextView *alertMessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *alertCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *alertConfirmButton;
@property (copy, nonatomic) void(^confirmBlock)(void);
@property (copy, nonatomic) void(^cancelBlock)(void);
+ (instancetype)shareInstance;
//+(void)showAlertPopViewWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle showsOnView:(UIView *)view confirmBlock:(confirmOut)confirmOut cancelBlock:(cancelOut)cancelOut;
-(void)showAlertPopViewWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle cancelBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock;
+(void)hidePopView;

@end

NS_ASSUME_NONNULL_END
