//
//  NSString+DecimalNumber.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "NSString+DecimalNumber.h"

@implementation NSString (DecimalNumber)


/**
 字符串格式化
 
 @param divisor 除数
 @param dividend 被除数
 @param scale 保留位数
 @return 结果
 */
+ (NSString *)ug_positiveFormatWithDivisor:(NSString *)divisor dividend:(NSString *)dividend scale:(NSInteger)scale {
    //输入的值 / 单价
    NSDecimalNumber *total = [[[NSDecimalNumber alloc] initWithString:divisor] decimalNumberByDividingBy:[[NSDecimalNumber alloc]initWithString:dividend]];
    //只舍不入   NSRoundDown
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown
                                                                                                      scale:scale
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *resutlt = [total decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *lastStr = [resutlt stringValue];
    return lastStr;
}

/**
 字符串格式化 乘法
 
 @param multiplier 乘数
 @param multiplicand 被乘数
 @param scale 保留位数
 @param roundingMode NSRoundingMode 保留位数格式
 @return 结果
 */
+ (NSString *)ug_positiveFormatWithMultiplier:(NSString *)multiplier multiplicand:(NSString *)multiplicand scale:(NSInteger)scale roundingMode:(NSRoundingMode)roundingMode {
    if (UG_CheckStrIsEmpty(multiplier) || UG_CheckStrIsEmpty(multiplicand)) {
        return @"0.00";
    }
    //输入的值 * 单价
    NSDecimalNumber *total = [[[NSDecimalNumber alloc] initWithString:multiplier] decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc]initWithString:multiplicand]];
    //只舍不入  NSRoundDown
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode
                                                                                                      scale:scale
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *resutlt = [total decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *lastStr = [resutlt stringValue];
    if ([[resutlt stringValue] isEqualToString:@"0"]) {
        lastStr = @"0.00";
    }
    return lastStr;
}




/**
 金额格式化，保留6位小数。不补0，只舍不入
 
 @return 格式化之后的数据
 */
- (NSString *)ug_amountFormat {
//    NSDecimalNumber *textNum = [NSDecimalNumber decimalNumberWithString:self];
//    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
//                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
//                                       scale:6
//                                       raiseOnExactness:NO
//                                       raiseOnOverflow:NO
//                                       raiseOnUnderflow:NO
//                                       raiseOnDivideByZero:YES];
//    NSDecimalNumber *resutlt = [textNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    
    return [NSString ug_positiveFormatWithMultiplier:self multiplicand:@"1" scale:6 roundingMode:NSRoundDown];
}


/**
 * 加法
 */
+ (NSString *)ug_addFormatWithMultiplier:(NSString *)multiplier multiplicand:(NSString *)multiplicand{
    NSDecimalNumber *textNuma = [NSDecimalNumber decimalNumberWithString:multiplier];
    NSDecimalNumber *textNumb = [NSDecimalNumber decimalNumberWithString:multiplicand];
    NSDecimalNumber *addStr = [textNuma decimalNumberByAdding:textNumb];
    return [addStr stringValue];
}

/**
 * 减法
 */
+ (NSString *)ug_bySubtractFormatWithMultiplier:(NSString *)multiplier multiplicand:(NSString *)multiplicand{
    NSDecimalNumber *textNuma = [NSDecimalNumber decimalNumberWithString:multiplier];
    NSDecimalNumber *textNumb = [NSDecimalNumber decimalNumberWithString:multiplicand];
    NSDecimalNumber *addStr = [textNuma decimalNumberBySubtracting:textNumb];
    return [addStr stringValue];
}
@end
