//
//  UGImagePopView.h
//  BiBeiInternational
//
//  Created by conew on 2019/9/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGImagePopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *alertCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *alertConfirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;

@property (copy, nonatomic) void(^confirmBlock)(void);
@property (copy, nonatomic) void(^cancelBlock)(void);
+ (instancetype)shareInstance;
// type 0 支付宝转账支付宝  1 支付宝转账到银行卡
-(void)showAlertPopViewWithDes:(NSString *)des andType:(NSInteger)type andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle cancelBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock;
+(void)hidePopView;
@end

NS_ASSUME_NONNULL_END
