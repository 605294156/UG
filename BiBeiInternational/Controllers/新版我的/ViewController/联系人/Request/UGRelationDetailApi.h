//
//  UGRelationDetailApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGRelationDetailApi : UGBaseRequest
@property (nonatomic, strong) NSString *memberId; //联系人用户id
@property (nonatomic, strong) NSString *username; //用户名
@end

NS_ASSUME_NONNULL_END
