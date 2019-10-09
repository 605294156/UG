//
//  UGOTCBankInfoView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCBankInfoView : UIView
@property (weak, nonatomic) IBOutlet UIButton *bankNoBtn;

@property (weak, nonatomic) IBOutlet UILabel *bankCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *banckCyL;
@property (nonatomic,copy) void ((^copClickBlock)(void));

+ (instancetype)fromXib;



@end

NS_ASSUME_NONNULL_END
