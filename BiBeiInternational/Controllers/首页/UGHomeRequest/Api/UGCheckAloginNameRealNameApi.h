//
//  UGCheckAloginNameRealNameApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/9/20.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCheckAloginNameRealNameApi : UGBaseRequest
@property (nonatomic,copy)NSString *aloginName;  //接收用户id
@end

NS_ASSUME_NONNULL_END
