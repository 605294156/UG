//
//  MyAdvertisingAlterView.m
//  CoinWorld
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyAdvertisingAlterView.h"

@implementation MyAdvertisingAlterView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.myAdvertiseLabel.text = LocalizationKey(@"myAdvertising");
     self.limitLabel.text = LocalizationKey(@"limit");
     self.remainNumLabel.text = LocalizationKey(@"numberRemaining");
    [self.changeButton setTitle:LocalizationKey(@"modify") forState:UIControlStateNormal];
   [self.cancelButton setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.advertisingBGView.clipsToBounds = YES;
    self.advertisingBGView.layer.cornerRadius = 6;
    self.advertisingBGView.layer.borderWidth = 1;
    self.advertisingBGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.4];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
