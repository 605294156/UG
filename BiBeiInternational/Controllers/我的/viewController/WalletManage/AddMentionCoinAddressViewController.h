//
//  AddMentionCoinAddressViewController.h
//  CoinWorld
//
//  Created by iDog on 2018/3/8.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@class AddMentionCoinAddressViewController;

@protocol AddMentionCoinAddressViewControllerDelegate <NSObject>
- (void)AddAdressString: (NSString *)addAdressString;

@end

@interface AddMentionCoinAddressViewController : UGBaseViewController

@property(nonatomic,copy)NSArray *addressInfoArr; //地址数组
@property (nonatomic,weak) id<AddMentionCoinAddressViewControllerDelegate> delegate;

@end
