//
//  UGCheckUserAuxiliariesApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/6/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCheckUserAuxiliariesApi : UGBaseRequest
@property (nonatomic, copy) NSString *userAuxiliaries;
@property(nonatomic,copy)NSString *username;
@end

NS_ASSUME_NONNULL_END
