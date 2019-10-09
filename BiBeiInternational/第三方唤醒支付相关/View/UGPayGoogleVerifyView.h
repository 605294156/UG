//
//  UGPayGoogleVerifyView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPayGoogleVerifyView : UIView

+(instancetype)fromXib;

@property (nonatomic, copy) void(^determineHanlde)(NSString *code,NSString *type);
@property (nonatomic, copy) void(^clickCloseHandle)(void);
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;

@end

NS_ASSUME_NONNULL_END
