//
//  UGAcountModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/9/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

@interface UGAcountModel : UGBaseModel<NSCoding>
@property(nonatomic,copy)NSString *walletName;
@property(nonatomic,copy)NSString *passWord;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *keyStore;
@property(nonatomic,copy)NSString *mnemonicPhrase;
@property(nonatomic,copy)NSString *privateKey;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
