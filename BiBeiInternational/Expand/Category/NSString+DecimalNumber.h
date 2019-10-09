//
//  NSString+DecimalNumber.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DecimalNumber)



/**
 字符串格式化 除法

 @param divisor 除数
 @param dividend 被除数
 @param scale 保留位数
 @return 结果
 */
+ (NSString *)ug_positiveFormatWithDivisor:(NSString *)divisor dividend:(NSString *)dividend scale:(NSInteger)scale;



/**
 字符串格式化 乘法
 
 @param multiplier 乘数
 @param multiplicand 被乘数
 @param scale 保留位数
 @param roundingMode NSRoundingMode 保留位数格式
 @return 结果
 */
+ (NSString *)ug_positiveFormatWithMultiplier:(NSString *)multiplier multiplicand:(NSString *)multiplicand scale:(NSInteger)scale roundingMode:(NSRoundingMode)roundingMode;



/**
 金额格式化，保留6位小数。不补0，只舍不入

 @return 格式化之后的数据
 */
- (NSString *)ug_amountFormat;

/**
 * 加法
 */
+ (NSString *)ug_addFormatWithMultiplier:(NSString *)multiplier multiplicand:(NSString *)multiplicand;

/**
 * 减法
 */
+(NSString *)ug_bySubtractFormatWithMultiplier:(NSString *)multiplier multiplicand:(NSString *)multiplicand;

@end

NS_ASSUME_NONNULL_END
