//
//  UGTouchLoginVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/18.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGTouchLoginVC : UGBaseViewController
@property (nonatomic,copy)void(^accountLoginBlock)(void);
@property (nonatomic,copy)void(^faceLoginBlock)(void);
@end

NS_ASSUME_NONNULL_END
