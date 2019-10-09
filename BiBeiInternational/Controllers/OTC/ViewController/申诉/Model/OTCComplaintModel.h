//
//  OTCComplaintModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCComplaintModel : UGBaseModel

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *placeholder;
//0 textfield输入框  1 textview输入框 2 图片选取
@property(nonatomic, copy) NSString *cellType;
@property(nonatomic, copy) NSNumber *keyboardType;
@property(nonatomic, copy) NSString *value;//如果是图片
@property(nonatomic, strong) NSArray <UIImage *>*imagelist;

@end

NS_ASSUME_NONNULL_END
