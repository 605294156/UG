//
//  UGOpenCloseDispatchApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/3/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOpenCloseDispatchApi : UGBaseRequest

//openingOrderStatus：0:关闭 1:开启
@property (nonatomic,copy)NSString *openingOrderStatus;

@end

NS_ASSUME_NONNULL_END
