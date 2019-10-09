//
//  UGAcountModel.m
//  BiBeiInternational
//
//  Created by conew on 2018/9/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGAcountModel.h"

@implementation UGAcountModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        u_int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *key = [NSString stringWithUTF8String:propertyName];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
        free(properties);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(properties);
}

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    dict = [UG_MethodsTool deleteNullDictionary:dict];
    if (self = [super init]) {
        self.passWord= [dict objectForKey:@"passWord"];
        self.message = [dict objectForKey:@"message"];
        self.address = [dict objectForKey:@"address"];
        self.mnemonicPhrase = [dict objectForKey:@"mnemonicPhrase"];
        self.privateKey = [dict objectForKey:@"privateKey"];
        self.keyStore = [dict objectForKey:@"keyStore"];
        self.walletName = [dict objectForKey:@"walletName"];
    }
    return self;
}

@end
