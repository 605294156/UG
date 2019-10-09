//
//  UGContentInsetLabel.h
//  GLDemo
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGContentInsetLabel : UILabel

/**
 文字与label的间距，默认UIEdgeInsetsZero
 */
@property(nonatomic, assign) UIEdgeInsets ug_contentInset;

@end

NS_ASSUME_NONNULL_END
