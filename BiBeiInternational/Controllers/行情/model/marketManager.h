//
//  marketManager.h
//  bit123
//
//  Created by sunliang on 2018/2/24.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface marketManager : NSObject
+ (marketManager *)shareInstance;
@property(nonatomic,strong)NSMutableArray* AllCoinArray;//全部交易对
@property(nonatomic,strong)NSMutableArray* USDTArray;
@property(nonatomic,strong)NSMutableArray* UGArray;
@property(nonatomic,strong)NSMutableArray* CollectionArray;
@property(nonatomic,strong)NSMutableArray* BTCArray;
@property(nonatomic,strong)NSMutableArray* ETHArray;
@property(nonatomic,copy)NSString* symbol;//当前选择的交易对名称
@end
