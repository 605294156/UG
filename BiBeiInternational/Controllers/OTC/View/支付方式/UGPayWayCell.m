//
//  UGPayWayCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayWayCell.h"
#import "UGPayInfoModel.h"

@interface UGPayWayCell ()
//@property (weak, nonatomic) IBOutlet UILabel *banNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *alipayFastPayImageview;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;

@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView2;

@end

@implementation UGPayWayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.banNameLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)setModel:(id)model {
//    _model = model;
//    if ([model isKindOfClass:[UGBankInfoModel class]]) {
//        self.payWayLabel.text = @"银行卡";
////        self.banNameLabel.hidden = NO;
////        self.alipayFastPayImageview.hidden = NO;
//        NSString *bank = ((UGBankInfoModel *)model).bank;
//        //        NSString *branch = [NSString stringWithFormat:@"%@  %@", !UG_CheckStrIsEmpty(((UGBankInfoModel *)model).bankProvince) ? ((UGBankInfoModel *)model).bankProvince : @"",!UG_CheckStrIsEmpty(((UGBankInfoModel *)model).bankCity) ? ((UGBankInfoModel *)model).bankCity : @"" ];
//        //        self.banNameLabel.text = [NSString stringWithFormat:@"%@  %@",bank, branch ];
////        self.banNameLabel.text = [NSString stringWithFormat:@"%@",bank];
//    }else if ([model isKindOfClass:[UGWechatPayModel class]]) {
//        self.payWayLabel.text = @"微信";
////        self.alipayFastPayImageview.hidden = YES;
//    } else if ([model isKindOfClass:[UGAlipayModel class]]) {
//        self.payWayLabel.text = @"支付宝";
////        self.alipayFastPayImageview.hidden = YES;
//    }else if ([model isKindOfClass:[UGUnionModel class]]) {
//        self.payWayLabel.text = @"云闪付";
////        self.alipayFastPayImageview.hidden = YES;
//    }
//}

- (void)setModels:(NSArray *)models{
    for (int i=0; i<2; i++) {
        id model = models[i];
        if ([model isKindOfClass:[UGBankInfoModel class]]) {
            NSString *bank = ((UGBankInfoModel *)model).bank;
            if (i==0) {
                self.payWayLabel.text = [NSString stringWithFormat:@"%@",bank];
                self.icon1.image = [UIImage imageNamed:@"trade_bank_icon"];
                self.payWayLabel.superview.hidden = NO;
            }else{
                self.payWayLabel2.text = [NSString stringWithFormat:@"%@",bank];
                self.icon2.image = [UIImage imageNamed:@"trade_bank_icon"];
                self.payWayLabel2.superview.hidden = NO;
            }
        }else if ([model isKindOfClass:[UGWechatPayModel class]]) {
            if (i==0) {
                self.payWayLabel.text = @"微信";
                self.icon1.image = [UIImage imageNamed:@"trade_wx_icon"];
                self.payWayLabel.superview.hidden = NO;
            }else{
                self.payWayLabel2.text = @"微信";
                self.icon2.image = [UIImage imageNamed:@"trade_wx_icon"];
                self.payWayLabel2.superview.hidden = NO;
            }
        } else if ([model isKindOfClass:[UGAlipayModel class]]) {
            if (i==0) {
                self.payWayLabel.text = @"支付宝";
                self.icon1.image = [UIImage imageNamed:@"trade_ali_icon"];
                self.payWayLabel.superview.hidden = NO;
            }else{
                self.payWayLabel2.text = @"支付宝";
                self.icon2.image = [UIImage imageNamed:@"trade_ali_icon"];
                self.payWayLabel2.superview.hidden = NO;
            }
        }else if ([model isKindOfClass:[UGUnionModel class]]) {
            if (i==0) {
                self.payWayLabel.text = @"云闪付";
                self.icon1.image = [UIImage imageNamed:@"trade_yun_icon"];
                self.payWayLabel.superview.hidden = NO;
            }else{
                self.payWayLabel2.text = @"云闪付";
                self.icon2.image = [UIImage imageNamed:@"trade_yun_icon"];
                self.payWayLabel2.superview.hidden = NO;
            }
        }
    }
}

//- (void)setCheck:(NSInteger)check {
//    _check = check;
//    self.selectedImageView.image = check%2==0 ? [UIImage imageNamed:@"pop_selected"] : nil;
//    self.selectedImageView2.image = check%2!=0 ? [UIImage imageNamed:@"pop_selected"] : nil;
//}

- (void) upCheck:(NSInteger) row index:(NSInteger)index{
    if (row==0) {
        self.selectedImageView.image = index==0 ? [UIImage imageNamed:@"pop_selected"] : nil;
        self.selectedImageView2.image = index==1 ? [UIImage imageNamed:@"pop_selected"] : nil;
    }else{
        self.selectedImageView.image = index==2 ? [UIImage imageNamed:@"pop_selected"] : nil;
        self.selectedImageView2.image = index==3 ? [UIImage imageNamed:@"pop_selected"] : nil;
    }
}

@end
