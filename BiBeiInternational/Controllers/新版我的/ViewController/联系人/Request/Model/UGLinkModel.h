//
//  UGLinkModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGLinkModel : UGBaseModel

@property (nonatomic, strong) NSString *memberId;//联系人用户ID
@property (nonatomic, strong) NSArray *walletAddress;//UG钱包地址
@property (nonatomic, strong) NSString *avatar;//用户头像
@property (nonatomic, strong) NSString *messageAccount;//聊天用户名
@property (nonatomic, strong) NSString *status;//联系人与我关系状态
@property (nonatomic, strong) NSString *username;//用户名

@end

NS_ASSUME_NONNULL_END
