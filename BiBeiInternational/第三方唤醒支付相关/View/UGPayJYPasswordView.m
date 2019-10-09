//
//  UGPayJYPasswordView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayJYPasswordView.h"
#import "UGCodeInputView.h"

@interface UGPayJYPasswordView ()<GLCodeInputViewDelegate>

@property (weak, nonatomic) IBOutlet UGCodeInputView *passwordView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@end

@implementation UGPayJYPasswordView

+(instancetype)fromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"UGPayJYPasswordView" owner:nil options:nil].firstObject;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setOrderModel:(UGOrder *)orderModel {
    _orderModel = orderModel;
    self.amountLabel.text = [NSString stringWithFormat:@"%@ UG", orderModel.tradeUgNumber];
    self.productNameLabel.text = [NSString stringWithFormat:@"商品名称（%@）", orderModel.goodsName];
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self clickNextStep:nil];
}

- (IBAction)clickNextStep:(UIButton *)sender {
    if (UG_CheckStrIsEmpty(self.passwordView.textStore) || self.passwordView.textStore.length != 6) {
        [self.superview ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
        return;
    }
    if (self.clickNextSetpHandle) {
        self.clickNextSetpHandle(self.passwordView.textStore);
    }
}


- (IBAction)clickCose:(UIButton *)sender {
    if (self.clickCloseHandle) {
        self.clickCloseHandle();
    }
}

- (void)keyBoardFrameChanged:(NSNotification* )notification {
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyBorardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    BOOL hidden = [notification.name isEqualToString:UIKeyboardWillHideNotification];
    
    [UIView animateWithDuration:duration delay:0 options:[self animationOptionsForCurve:curve] animations:^{
        //输入框的位置
        self.bottomConstraint.constant =  hidden  ? 0 : keyBorardHeight;
        
    } completion:nil];
}

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
