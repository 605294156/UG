//
//  UGImagePopView.m
//  BiBeiInternational
//
//  Created by conew on 2019/9/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGImagePopView.h"
#import "PopView.h"

@interface UGImagePopView()
@property(nonatomic,strong)UGImagePopView *alertPopView;
@end

@implementation UGImagePopView
+(instancetype)shareInstance
{
    static UGImagePopView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        alertView = [[UGImagePopView alloc]init];
    });
    return alertView;
}

-(void)showAlertPopViewWithDes:(NSString *)des andType:(NSInteger)type andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle cancelBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGImagePopView"owner:self options:nil];
    _alertPopView = [nibView objectAtIndex:0];
    _alertPopView.confirmBlock = confirmBlock;
    _alertPopView.cancelBlock = cancelBlock;
    _alertPopView.desLabel.text = des;
    _alertPopView.layer.cornerRadius = 4;
    _alertPopView.layer.masksToBounds  = YES;
    if (type) {
        [_alertPopView.alertImageView setImage:[UIImage imageNamed:@"messageImg2"]];
    }
    else
    {
         [_alertPopView.alertImageView setImage:[UIImage imageNamed:@"messageImg"]];
    }
    [_alertPopView.alertCancelButton setTitle:cancelButtonTittle forState:UIControlStateNormal];
    [_alertPopView.alertConfirmButton setTitle:confirmlButtonTittle forState:UIControlStateNormal];
    CGFloat width = kWindowW - 62;
    CGFloat height = 330;
    CGRect frame = CGRectMake(0,0,width,height);
    [_alertPopView setFrame:frame];
    PopView *popView =[PopView popSideContentView:_alertPopView direct:PopViewDirection_SlideInCenter];
    popView.clickOutHidden = NO;
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
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
