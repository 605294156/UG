//
//  UGCreateRelationApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCreateRelationApi : UGBaseRequest
@property (nonatomic, strong) NSString *relationId; //对方的memberId
@end

NS_ASSUME_NONNULL_END
