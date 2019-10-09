//
//  UGCMCopyBankInfoPopView.h
//  BiBeiInternational
//
//  Created by 孙锟 on 2019/10/4.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOrderDetailModel.h"
typedef void(^CopyInfoType)(NSInteger type);

NS_ASSUME_NONNULL_BEGIN

@interface UGCMCopyBankInfoPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *moneyAmount;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumber;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;


+(instancetype)shareInstance;

@property(nonatomic,copy)CopyInfoType copyBlock;

-(void)showUGCMCopyBankInfoPopViewWithUGOrderDetailModel:(UGOrderDetailModel *)model   andConfirmlButtonTittle:(NSString *)confirmlButtonTittle confirmBlock:(CopyInfoType)copyBlock;

@end

NS_ASSUME_NONNULL_END
