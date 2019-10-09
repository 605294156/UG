//
//  UGPayWayModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPayWayModel : UGBaseModel

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *desc;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
