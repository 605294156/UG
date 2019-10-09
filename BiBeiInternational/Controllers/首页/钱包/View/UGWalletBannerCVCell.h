//
//  UGWalletBannerCVCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseCollectionViewCell.h"

@interface UGWalletBannerCVCell : UGBaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAllNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAllTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletIdLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (copy, nonatomic) void(^buyClick)(NSInteger index);
@property (copy, nonatomic) void(^sellClick)(NSInteger index);
@property (copy, nonatomic) void(^idLongClick)(UILongPressGestureRecognizer *longPress);
@end
