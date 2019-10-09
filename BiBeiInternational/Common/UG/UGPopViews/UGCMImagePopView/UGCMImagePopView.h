//
//  UGCMImagePopView.h
//  BiBeiInternational
//
//  Created by 孙锟 on 2019/10/4.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCMImagePopView : UIView

@property (weak, nonatomic) IBOutlet UIButton *alertCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *alertConfirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UILabel *alertTittleLabel;


@property (copy, nonatomic) void(^confirmBlock)(void);
@property (copy, nonatomic) void(^cancelBlock)(void);
+ (instancetype)shareInstance;
-(void)showAlertPopViewWithTittle:(NSString *)tittle  andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle cancelBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock;
+(void)hidePopView;

@end

NS_ASSUME_NONNULL_END
