//
//  UGWalletBannerCVCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGWalletBannerCVCell.h"

@interface UGWalletBannerCVCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletnameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletAllConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletTypeConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sellrightCnstraint;
@end

@implementation UGWalletBannerCVCell

#pragma mark - 购买
- (IBAction)buyClick:(id)sender {
    if (self.buyClick) {
        self.buyClick(0);
    }
}

#pragma mark - 出售
- (IBAction)sellClick:(id)sender {
    if (self.sellClick) {
        self.sellClick(1);
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.allLabel.font = UG_AutoFont(14);
    self.walletAllNumLabel.font = UG_AutoFont(40);
    self.walletAllTypeLabel.font = UG_AutoFont(14);
    self.buyButton.titleLabel.font = UG_AutoFont(14);
    self.sellButton.titleLabel.font = UG_AutoFont(14);
    self.walletnameConstraint.constant = UG_AutoSize(18);
    self.allLabelConstraint.constant = UG_AutoSize(15);
    self.walletAllConstraint.constant = UG_AutoSize(5);
    self.walletTypeConstraint.constant = UG_AutoSize(50);
    self.buyConstraint.constant = UG_AutoSize(20);
    self.sellConstriant.constant = UG_AutoSize(20);
    self.sellrightCnstraint.constant = UG_AutoSize(14);
    
}
@end
