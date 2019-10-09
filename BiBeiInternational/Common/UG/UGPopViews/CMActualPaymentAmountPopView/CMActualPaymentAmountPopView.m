//
//  UGCMCopyBankInfoPopView.m
//  BiBeiInternational
//
//  Created by 孙锟 on 2019/10/4.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "CMActualPaymentAmountPopView.h"
#import "PopView.h"

@interface CMActualPaymentAmountPopView()
@property(nonatomic,strong)CMActualPaymentAmountPopView *alertPopView;
@end

@implementation CMActualPaymentAmountPopView

+(instancetype)shareInstance
{
    static CMActualPaymentAmountPopView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        alertView = [[CMActualPaymentAmountPopView alloc]init];
    });
    return alertView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showCMActualPaymentAmountPopViewWithUGOrderDetailModel:(UGOrderDetailModel *)model   andConfirmlButtonTittle:(NSString *)confirmlButtonTittle
{
  
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"CMActualPaymentAmountPopView"owner:self options:nil];
    _alertPopView = [nibView objectAtIndex:0];
    _alertPopView.layer.cornerRadius = 4;
    _alertPopView.layer.masksToBounds  = YES;

    _alertPopView.actualAmountLabel.text = model.money;
    //原始金额
    NSString *ugNumberStr = [NSString stringWithFormat:@"￥%@",model.amount];
    _alertPopView.originalAmountLabel.text = ugNumberStr;
    CGSize size = [_alertPopView.originalAmountLabel.text  sizeWithAttributes:@{NSFontAttributeName:_alertPopView.originalAmountLabel.font}];
    _alertPopView.lineWidthLayout.constant = size.width+4;


    
    NSString *strTemp = [NSString stringWithFormat:@"请按照指定的金额：%@ 元进行付款，即可快速放币！否则将会延迟放币！",model.money];
    _alertPopView.descriptionLabel.text = strTemp;
    NSUInteger StrTemp = model.money.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTemp];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor systemRedColor] range:NSMakeRange(9,StrTemp)];//颜色
    _alertPopView.descriptionLabel.attributedText = str;
    
    [_alertPopView.confirmButton setTitle:confirmlButtonTittle forState:UIControlStateNormal];
    CGFloat width = kWindowW - 50;
    CGFloat height = 210;
    CGRect frame = CGRectMake(0,0,width,height);
    [_alertPopView setFrame:frame];
    PopView *popView =[PopView popSideContentView:_alertPopView direct:PopViewDirection_SlideInCenter];
    popView.clickOutHidden = NO;
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    popView.didRemovedFromeSuperView = ^{
        [self.alertPopView removeFromSuperview];
    };
    
    
}


- (IBAction)confirmDissmissAction:(id)sender {
    
    NSLog(@"confirmDissmissAction");
    [PopView hidenPopView];
}

+(void)hidePopView{
    [PopView hidenPopView];
}


@end
