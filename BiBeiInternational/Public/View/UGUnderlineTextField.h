//
//  UGUnderlineTextField.h
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UGUnderlineTextField : UITextField


@property(nonatomic, strong) IBInspectable NSString *leftImageName;

@property(nonatomic, strong) IBInspectable UIColor *lineColor;

@property(nonatomic, assign) IBInspectable CGFloat lineHeight;


@end

NS_ASSUME_NONNULL_END
