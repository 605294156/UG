//
//  UGMethodsTool.h
//  ug-wallet
//
//  Created by conew on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UG_MethodsTool : NSObject

+(CGFloat)UGAutoSize:(CGFloat)value;

+(UIFont *)UGAutoFont:(CGFloat)value;


//时间戳转换yyyy-MM-dd HH:mm:ss
+ (NSString *)timeFormatted:(NSNumber *)totalSeconds;


/**
 获取导航栏高度
navigationBar = statusBarHeight + navHeight
内部已自动处理X系列
 */
+ (CGFloat)navigationBarHeight;


/**
 获取当前设备状态栏高度
 内部已自动处理X系列
 */
+ (CGFloat)statusBarHeight;


/**
 标签栏高度
 内部已自动处理X系列
 */
+ (CGFloat)tabBarHeight;


/**
 数组随机打乱顺序
 */
+ (NSArray*)randomArray:(NSArray *)array;

/**
 去除字典空值
 */
+(NSDictionary *)deleteNullDictionary:(NSDictionary *)oldDic;

/**
 播放提示音
 */
+(void)AudioServicesPlayMesage:(BOOL)isMesage;

/**
 获取友好时间提示
 */
+(NSString *)getFriendyWithStartTime:(NSString *)startTime;

/**
 时间搓改 制定的规则时间显示
 */
+(NSString *)getFriendIntervalTime:(NSTimeInterval)interval;

/**
 字符串编码
 */
+(NSString*)encodeString:(NSString*)unencodedString;

/**
 字符串解码
 */
+(NSString *)decodeString:(NSString*)encodedString;

/**
 json数据解析
 */
+ (NSDictionary *)dictWithJsonString:(NSString *)jsonString;

/**
 字典转json数据
 */
+(NSString *)convertToJsonData:(NSDictionary *)dict;

/**
 * 检测版本号 1 后台大   -1 后台小  0 相等
 */
// 方法调用
+ (BOOL)versionCompareVersion:(NSString *)version andCurrentVersion: (NSString *)currentVersion;

/**
 * 打开外部链接
 */
+ (void)openScheme:(NSString *)scheme;

/**
 *  判断手机号
 */
+(BOOL)checkPhone:(NSString *)phoneNumber;

/**
 * 压缩图片到指定文件大小
 *
 * @param image 目标图片
 * @param maxLength 目标大小（最大值）
 * @return 返回的图片文件
 */
+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

/**
 * 隐藏显示账号
 */
+(NSString *)encryptionWord:(NSString *)encryption;
    
#pragma mark -手机机型
+(NSString *)iphoneType;


/**
 * 动态计算高度
 */
+(CGFloat)heightWithWidth:(CGFloat)width font:(CGFloat)font str:(NSString *)string;

/**
 * 动态计算带行间距的高度
 */

+(CGFloat)heightWithFontSize:(CGFloat)fontSize text:(NSString *)text needWidth:(CGFloat)needWidth lineSpacing:(CGFloat )lineSpacing;

/**
 * 字符串转Json数据
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 * 获取应用BundleID
 */
+(NSString*)getBundleID;
/**
 * 是否是4英寸屏幕
 */
+(BOOL)is4InchesScreen;

/**
 * 上报异常信息与错误信息
 */
+(void)reportErrorMessage:(NSNumber *)number  WithReson: (NSString *)reason WithUrl:(NSURL *)url;

/**
 * 获取目标view的截图
 */
+(UIImage *)getContentImageWithTargetView:(UIView *)targetView;

/**
 * 加密请求规则
 */
+(NSString *)accessAuthUgcoinEncryption;

//md5加密  32位小写
+ (NSString *)md5StringFromString:(NSString *)string;

//当前时间磋 以毫米为单位
+(NSString *)getNowTimeTimestamp3 : (BOOL)isH;

//base64 加密字符串
+(NSString *)baseAddBase64:(NSString *)baseStr;

//缓存国家取号
+(void)toCreateUGAreacodePlistWith:(NSArray *)areaArray;

//构造发布广告随机数数据
+(void)toCreateUGPlaceAnADRandomNumber;

//检查本地数据状态
+(void)UGPlaceAnADRandomNumberIsNeedToUpdate;

//更新数据库中随机数数据的数据，超过时间5分钟则重置数据
+(void)toUpdateUGPlaceAnADRandomNumberWith:(NSMutableArray *)randomNumberArray;

//获取发布广告金额后的随机数数据
+(NSMutableArray *)GetPlaceAnADRandomNumberFromPlist;

//从plist中获取区号数据
+(NSArray *)GetAreacodeArrayFromPlist;

//图片压缩
+(UIImage*)imageCompressWithSimple:(UIImage*)image;

//判读字符串是否为整数
+(BOOL)isPureInteger:(NSString *)inputString;

//ios oc 判断输入的数是否是另一个的整数倍
+(BOOL)judgeStrIsMultipleOfTenWith:(NSString *)inputString;

@end

NS_ASSUME_NONNULL_END
