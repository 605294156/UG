//
//  UGShowGoogleVerifyVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface UGShowGoogleVerifyVC : UGBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tishiLabel;
@property (weak, nonatomic) IBOutlet UIButton *click;
@property (weak, nonatomic) IBOutlet UILabel *qrContent;

@property (nonatomic,strong)UIViewController *baseVC;
@property (nonatomic,assign)BOOL isReSet;
@property (nonatomic,copy)NSString *key;//重置谷歌验证码 人脸识别认证后带过来的key
@property(nonatomic,assign)BOOL isCarvip;  //点击承兑商按钮过来
@end
