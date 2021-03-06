//
//  UGShowBindPayInfoViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/2.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGShowBindPayInfoViewController.h"

@interface UGShowBindPayInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *userBameT;
@property (weak, nonatomic) IBOutlet UIView *userNameLine;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameTop;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weChatName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payNameTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userLalTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLalCenter;
@end

@implementation UGShowBindPayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UGMember *member = [UGManager shareInstance].hostInfo.userInfoModel.member;
    
    NSString *qrCodeUrl = self.payType == UGPayTypeWeChatPay ? member.qrWeCodeUrl :    (self.payType == UGPayTypeUnionPay ? member.qrUnionCodeUrl : member.qrCodeUrl) ;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:qrCodeUrl] placeholderImage:nil];
    
    self.accountLabel.text = self.payType == UGPayTypeWeChatPay ? member.wechat : (self.payType == UGPayTypeUnionPay ? member.unionPay : member.aliNo) ;
    
    NSString *payName = self.payType == UGPayTypeWeChatPay ? @"微信账号" : (self.payType == UGPayTypeUnionPay ? @"云闪付账号" : @"支付宝账号");
    
    self.payNameLabel.text = payName;
    
    if (self.payType == UGPayTypeUnionPay) {
        self.userBameT.text = [UGManager shareInstance].hostInfo.userInfoModel.member.realName;
        self.userNameLab.hidden = NO;
        self.userBameT.hidden = NO;
        self.userNameLine.hidden = NO;
//        self.userNameTop.constant = 24.0f;
//        self.weChatName.constant = 74.0f;
//        self.payNameTop.constant = 0.f;
        self.centerH.constant = 333.0f;
        self.payNameTop.constant = 13.f;
        self.userLalTop.constant = 13.f;
        self.userNameLalCenter.constant = -.5;
    }else{
        self.userNameLab.hidden = YES;
        self.userBameT.hidden = YES;
        self.userNameLine.hidden = YES;
        self.payNameTop.constant = -31.f;
//        self.userNameTop.constant = 0.0f;
//        self.weChatName.constant = 24.0f;
        self.centerH.constant = 289.0f;
    }
}

- (IBAction)cancelBinding:(id)sender {
    if (self.clickUnBinding) {
        self.clickUnBinding(self.payType);
    }
}

@end
