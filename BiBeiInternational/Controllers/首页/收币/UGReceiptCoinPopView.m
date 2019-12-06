//
//  UGReceiptCoinPopView.m
//  BiBeiInternational
//
//  Created by XiaoCheng on 05/12/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGReceiptCoinPopView.h"
#import "PopView.h"

@interface UGReceiptCoinPopView ()
@property (weak, nonatomic) IBOutlet UILabel *context;
@property (weak, nonatomic) IBOutlet UIButton *okbtn;

@end

@implementation UGReceiptCoinPopView

+ (void)showWithContext:(NSString *)title WithHandle:(void(^)(void))clickHandle{
    UGReceiptCoinPopView *coinView = [[[NSBundle mainBundle] loadNibNamed:@"UGReceiptCoinPopView" owner:nil options:nil] objectAtIndex:0];
    coinView.mj_h = 287.f;
    coinView.mj_w = 285.f;
    
    coinView.context.text = title;
    [[coinView.okbtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [PopView hidenPopView];
    }];
    
    PopView *popView =[PopView popSideContentView:coinView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.clickOutHidden = NO;
}

@end
