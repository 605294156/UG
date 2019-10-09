//
//  plateModel.h
//  bit123
//
//  Created by sunliang on 2018/2/11.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

@interface plateModel : BaseModel
@property(nonatomic,assign)double price;//价格
@property(nonatomic,assign)double amount;//交易量
@property(nonatomic,assign)double totalAmount;
//新加
@property(nonatomic,copy)NSString *priceStr;//价格
@property(nonatomic,copy)NSString *amountStr;//交易量
@end
