//
//  NSString+LCJudgeNumber.h
//  ios_demo
//
//  Created by 刘翀 on 16/6/6.
//  Copyright © 2016年 xinhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LCJudgeNumber)

/*
 验证字符串是否为空
 */
+(BOOL)stringIsNull:(NSString *)string;
/*
 验证密码是否合法 至少一个字母和数字6-20位
 */
+ (BOOL)checkPassword:(NSString *) password;
/**
 *  判断中英混合字符串长度
 *
 *  @param strtemp 字符串
 *
 *  @return 长度int
 */
+ (int)convertToInt:(NSString*)strtemp;

/**
 *  验证首字母是否是中文
 *
 *
 *  @return yes or no
 */
+(BOOL)isChineseFirst:(NSString *)string;
/**
 *  判断首字符是否是英文字母
 *
 *  @param string 字符串
 *
 *  @return yes or no
 */
+(BOOL)pipeizimu:(NSString *)string;
/**
 *  获取字符串自适应高度
 *
 *  @param string 字符串
 *
 *  @return yes or no
 */
+(CGSize)stringSize:(NSString *)string withFont:(UIFont *)font;

/**
 * 判断是否存在表情符号
 *
 *  @param string 字符串
 *
 *  @return yes or no
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

+(BOOL)hasEmoji:(NSString*)string;

+(BOOL)isNineKeyBoard:(NSString *)string;
@end
