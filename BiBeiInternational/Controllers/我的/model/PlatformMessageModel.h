//
//  PlatformMessageModel.h
//  CoinWorld
//
//  Created by iDog on 2018/3/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlatformMessageModel : NSObject

@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *publicDate;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *noticetype;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *updateDate;

@end
