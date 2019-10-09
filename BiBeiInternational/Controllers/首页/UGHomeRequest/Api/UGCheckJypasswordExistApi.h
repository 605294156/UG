//
//  UGCheckJypasswordExistApi.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"
/**
校验交易密码
 */
@interface UGCheckJypasswordExistApi : UGBaseRequest
@property (nonatomic, copy) NSString *password;//新密码
@end
