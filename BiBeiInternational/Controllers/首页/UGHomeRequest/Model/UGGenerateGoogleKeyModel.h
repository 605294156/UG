//
//  UGGenerateGoogleKeyModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
/**
 获取UG钱包秘钥模型
 */
@interface UGGenerateGoogleKeyModel : UGBaseModel<NSCoding>
@property(nonatomic,copy)NSString *link;//UG钱包id
@property(nonatomic,copy)NSString *secret;//秘钥

+(instancetype)getModelWithDic:(UGGenerateGoogleKeyModel *)model;

+(instancetype)shareUGGoogleKeyModel;

+(void)saveGoogleKeyModel:(UGGenerateGoogleKeyModel *)model;
@end
