//
//  UGCMCopyBankInfoPopView.m
//  BiBeiInternational
//
//  Created by 孙锟 on 2019/10/4.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGCMCopyBankInfoPopView.h"
#import "PopView.h"

@interface UGCMCopyBankInfoPopView()
@property(nonatomic,strong)UGCMCopyBankInfoPopView *alertPopView;
@end

@implementation UGCMCopyBankInfoPopView

+(instancetype)shareInstance
{
    static UGCMCopyBankInfoPopView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        alertView = [[UGCMCopyBankInfoPopView alloc]init];
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

-(void)showUGCMCopyBankInfoPopViewWithUGOrderDetailModel:(UGOrderDetailModel *)model   andConfirmlButtonTittle:(NSString *)confirmlButtonTittle confirmBlock:(CopyInfoType)copyBlock
{
  
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGCMCopyBankInfoPopView"owner:self options:nil];
    _alertPopView = [nibView objectAtIndex:0];
   
    _alertPopView.layer.cornerRadius = 4;
    _alertPopView.layer.masksToBounds  = YES;
    _alertPopView.moneyAmount.text = [NSString stringWithFormat:@"%@元",model.money];
    _alertPopView.accountName.text = model.payInfo.realName;
    _alertPopView.bankCardNumber.text = model.bankInfo.cardNo;
    _alertPopView.bankName.text = model.bankInfo.bank;
    
    NSString *strTemp = @"为了及时放币，您实际支付金额与订单金额有细微差距，请以实际金额为准。如，购买100UG，则支付金额≤100元";
    _alertPopView.descriptionLabel.text = strTemp;
    
    NSUInteger iStrTemp = strTemp.length;
                
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strTemp];
                
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(iStrTemp - 18,18)];//颜色
                
     _alertPopView.descriptionLabel.attributedText = str;

     _alertPopView.copyBlock = copyBlock;
    
    CGFloat width = kWindowW - 40;
    CGFloat height = 350;
    CGRect frame = CGRectMake(0,0,width,height);
    [_alertPopView setFrame:frame];
    PopView *popView =[PopView popSideContentView:_alertPopView direct:PopViewDirection_SlideInCenter];
    popView.clickOutHidden = NO;
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    popView.didRemovedFromeSuperView = ^{
        [self.alertPopView removeFromSuperview];
    };
    
    
}

- (IBAction)moneyCopyAction:(id)sender {

    if (_copyBlock) {
        _copyBlock(1);
    }
    [self ug_showToastWithToast:@"复制成功"];
}
- (IBAction)accountNameCopyAction:(id)sender {
    
     if (_copyBlock) {
           _copyBlock(2);
       }
    [self ug_showToastWithToast:@"复制成功"];
}

- (IBAction)bankCardCopyAction:(id)sender {
     if (_copyBlock) {
           _copyBlock(3);
       }
    [self ug_showToastWithToast:@"复制成功"];
}

- (IBAction)bankNameCopyAction:(id)sender {

     if (_copyBlock) {
           _copyBlock(4);
       }
    [self ug_showToastWithToast:@"复制成功"];
}


- (IBAction)confirmDissmissAction:(id)sender {
    
    NSLog(@"confirmDissmissAction");
    [PopView hidenPopView];
}

+(void)hidePopView{
    [PopView hidenPopView];
}


@end
