//
//  UGMessageDictionary.h
//  BiBeiInternational
//
//  Created by conew on 2019/3/15.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMessageDictionary : UGBaseModel
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *subtype;
@property(nonatomic,copy)NSString *dicKey;
@property(nonatomic,copy)NSString *dicValue;
@end

NS_ASSUME_NONNULL_END
