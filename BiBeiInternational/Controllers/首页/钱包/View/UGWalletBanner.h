//
//  UGWalletBanner.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseView.h"

@interface UGWalletBanner : UGBaseView

- (id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize;

@property (strong, nonatomic) NSArray *items;

@property (copy, nonatomic) void(^cellClick)(UGWalletBanner *barnerview,NSInteger index);
@property (copy, nonatomic) void(^buyClick)(UGWalletBanner *barnerview,NSInteger index);
@property (copy, nonatomic) void(^sellClick)(UGWalletBanner *barnerview,NSInteger index);
@property (copy, nonatomic) void(^idLongClick)(UILongPressGestureRecognizer *longPress);
@end
