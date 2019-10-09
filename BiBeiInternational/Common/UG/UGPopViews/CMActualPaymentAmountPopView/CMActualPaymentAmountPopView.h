//
//  CMActualPaymentAmountPopView.h
//  BiBeiInternational
//
//  Created by 孙锟 on 2019/10/4.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOrderDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface CMActualPaymentAmountPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *actualAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineWidthLayout;


+(instancetype)shareInstance;


-(void)showCMActualPaymentAmountPopViewWithUGOrderDetailModel:(UGOrderDetailModel *)model   andConfirmlButtonTittle:(NSString *)confirmlButtonTittle;

@end

NS_ASSUME_NONNULL_END
