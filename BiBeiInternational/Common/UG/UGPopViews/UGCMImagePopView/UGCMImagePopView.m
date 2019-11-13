//
//  UGCMImagePopView.m
//  BiBeiInternational
//
//  Created by 孙锟 on 2019/10/4.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCMImagePopView.h"
#import "PopView.h"

@interface UGCMImagePopView()
@property(nonatomic,strong)UGCMImagePopView *alertPopView;
@end

@implementation UGCMImagePopView
+(instancetype)shareInstance
{
    static UGCMImagePopView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        alertView = [[UGCMImagePopView alloc]init];
    });
    return alertView;
}

-(void)showAlertPopViewWithTittle:(NSString *)tittle  andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle cancelBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGCMImagePopView"owner:self options:nil];
    _alertPopView = [nibView objectAtIndex:0];
    _alertPopView.confirmBlock = confirmBlock;
    _alertPopView.cancelBlock = cancelBlock;
    _alertPopView.alertTittleLabel.text = tittle;
    _alertPopView.layer.cornerRadius = 4;
    _alertPopView.layer.masksToBounds  = YES;
    [_alertPopView.alertCancelButton setTitle:cancelButtonTittle forState:UIControlStateNormal];
    [_alertPopView.alertConfirmButton setTitle:confirmlButtonTittle forState:UIControlStateNormal];
    CGFloat width = kWindowW - 50;
    CGFloat height = 265;
    if (kWindowW > 375)
    {
        height = 285;
    }
    CGRect frame = CGRectMake(0,0,width,height);
    [_alertPopView setFrame:frame];
    PopView *popView =[PopView popSideContentView:_alertPopView direct:PopViewDirection_SlideInCenter];
    popView.clickOutHidden = NO;
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    popView.didRemovedFromeSuperView = ^{
        [self.alertPopView removeFromSuperview];
    };
}

+(void)hidePopView{
    [PopView hidenPopView];
}

- (IBAction)cancelButtonAction:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
    [PopView hidenPopView];
}

- (IBAction)confirmButtonAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
    [PopView hidenPopView];
}

@end
