//
//  UGMethodsTool.m
//  ug-wallet
//
//  Created by conew on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UG_MethodsTool.h"
#import "UIDevice+UGExpand.h"
#import <AudioToolbox/AudioToolbox.h>
#import <sys/utsname.h>
#import <Bugly/Bugly.h>
#import <CommonCrypto/CommonDigest.h>

#define DesignWidth  357.0f
#define DesignHeight 667.0f

@implementation UG_MethodsTool

+(CGFloat)UGAutoSize:(CGFloat)value{
    
    float scale = 1.0f;
    CGRect windowRect = [UIScreen mainScreen].bounds;
    CGFloat windowWidth=CGRectGetWidth(windowRect);
    
    bool isNoRate=NO;
    if (windowWidth>DesignWidth)
    {
        isNoRate=YES;
        scale=1;
    }
    else
        scale=windowWidth/(DesignWidth*1.0);
    if (isNoRate)
       return  value;
    return  value*scale;
}

+(UIFont *)UGAutoFont:(CGFloat)value{
    
    float scale = 1.0f;
    CGRect windowRect = [UIScreen mainScreen].bounds;
    CGFloat windowWidth=CGRectGetWidth(windowRect);
    bool isNoRate=NO;
    if (windowWidth>DesignWidth)
    {
        isNoRate=YES;
        scale=1;
    }
    else
        scale=windowWidth/(DesignWidth*1.0);
    
    if (isNoRate)
        return [UIFont systemFontOfSize:value] ;
    
    return  [UIFont systemFontOfSize:scale*value];
}


+ (CGFloat)navigationBarHeight {

    CGFloat statusHeight = [self statusBarHeight];
    
    CGFloat navHeight = 44;
    
    return navHeight + statusHeight;
}


+ (CGFloat)statusBarHeight {
    if ([UIDevice isIphoneXSeries]) {
        return 44;
    }
    return 20;
}


+ (CGFloat)tabBarHeight {
    if ([UIDevice isIphoneXSeries]) {
        return 83;
    }
    return 49;
}

+ (NSArray*)randomArray:(NSArray *)array{
   NSArray *arr = [array sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
       int seed = arc4random_uniform(2);
       if (seed) {
           return  [str1 compare:str2];
           
       } else {
           return [str2 compare:str1];
       }
   }];
    return arr;
}

+(NSDictionary *)deleteNullDictionary:(NSDictionary *)oldDic {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *obj in oldDic.allKeys) {
        if ([[oldDic objectForKey:obj] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:obj];
        }
        else{
            [mutableDic setObject:[oldDic objectForKey:obj] forKey:obj];
        }
    }
    return mutableDic;
}

+(void)AudioServicesPlayMesage:(BOOL)isMesage{
//    if (isMesage) {
//        NSURL *url = [[NSBundle mainBundle]URLForResource:@"m_click" withExtension:@"wav"];
//        //对该音效标记SoundID
//        SystemSoundID soundID1 = 0;
//        //加载该音效
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID1);
//        //播放该音效
//        AudioServicesPlaySystemSound(soundID1);
//    }else{
//      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); // 震动
       AudioServicesPlaySystemSound(1002); //这个声音是是类似于QQ声音的
//    }
}

/**
 时间搓改 制定的规则时间显示
 */
+(NSString *)getFriendIntervalTime:(NSTimeInterval)interval{
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return [self getFriendyWithStartTime:dateString];
}

//时间计算规则
//MARK:--发送时间的计算，5分钟以内标记刚刚，今天之内显示: 今天 00：00   昨天之内显示  昨天 00:00  两天以上显示 2018-12-20 12 : 20
+(NSString *)getFriendyWithStartTime:(NSString *)startTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSDate* date = [dateFormatter dateFromString:startTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    double beTime = [date timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    if (distanceTime < 60) {//小于一分钟
        distanceStr =LocalizationKey(@"justTime");
    }
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }
    else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"yyyy-MM-dd  HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }
    else if(distanceTime <24*60*60*365){
        [df setDateFormat:@"yyyy-MM-dd  HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

+(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&;=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

+(NSString *)decodeString:(NSString*)encodedString
{
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                    (__bridge CFStringRef)encodedString,
                                                                                                                    CFSTR(""),
                                                                                                                    CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}


//时间戳转换yyyy-MM-dd HH:mm:ss
+ (NSString *)timeFormatted:(NSNumber *)totalSeconds {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[totalSeconds doubleValue] / 1000.0];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}


#pragma mark - json解析
+ (NSDictionary *)dictWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dict;
}

#pragma mark - 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

/**
 * 检测版本号 1 后台大   -1 后台小  0 相等
 */
// 方法调用
+ (BOOL)versionCompareVersion:(NSString *)version andCurrentVersion: (NSString *)currentVersion
{
    NSArray *versions1 = [version componentsSeparatedByString:@"."];
    NSArray *versions2 = [currentVersion componentsSeparatedByString:@"."];
    NSMutableArray *ver1Array = [NSMutableArray arrayWithArray:versions1];
    NSMutableArray *ver2Array = [NSMutableArray arrayWithArray:versions2];
    // 确定最大数组
    NSInteger a = (ver1Array.count> ver2Array.count)?ver1Array.count : ver2Array.count;
    // 补成相同位数数组
    if (ver1Array.count < a) {
        for(NSInteger j = ver1Array.count; j < a; j++)
        {
            [ver1Array addObject:@"0"];
        }
    }
    else
    {
        for(NSInteger j = ver2Array.count; j < a; j++)
        {
            [ver2Array addObject:@"0"];
        }
    }
    // 比较版本号
    int result = [self compareArray1:ver1Array andArray2:ver2Array];
    if(result == 1 || result ==0 )
    {
        return NO;
    }
    
    return YES;
}
// 比较版本号
+ (int)compareArray1:(NSMutableArray *)array1 andArray2:(NSMutableArray *)array2
{
    for (int i = 0; i< array2.count; i++) {
        NSInteger a = [[array1 objectAtIndex:i] integerValue];
        NSInteger b = [[array2 objectAtIndex:i] integerValue];
        if (a > b) {
            return 1;
        }
        else if (a < b)
        {
            return -1;
        }
    }
    return 0;
}

/**
 * 打开外部链接
 */
+ (void)openScheme:(NSString *)scheme {
    if (UG_CheckStrIsEmpty(scheme)) {
        return;
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@: %d",scheme,success);
        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}

/**
 *  判断手机号
 */
+(BOOL)checkPhone:(NSString *)phoneNumber
{
    NSString *regex = @"^1[345789]{1}\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    if (!isMatch)
    {
        return NO;
    }
    return YES;
}

/**
 * 压缩图片到指定文件大小
 *
 * @param image 目标图片
 * @param maxLength 目标大小（最大值）
 * @return 返回的图片文件
 */
+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression =0.9;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength){
        return data;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

/**
 * 隐藏显示账号
 */
+(NSString *)encryptionWord:(NSString *)encryption{
    if (encryption.length<=3) {
        return encryption;
    }
    int  n = (int)encryption.length/3;
    double x = (double)encryption.length/3.0;
    int f = (x-n)*10;
    
    if (f>0 && f<5) {
        n = n+1;
    }else if (f>=5){
        n = n+2;
    }
    int w = (encryption.length-n)/2.0;
    
    NSString *repalceStr = @"";
    for (int i = 0; i< n; i++) {
        repalceStr = [NSString stringWithFormat:@"%@%@",repalceStr,@"*"];
    }
    
    NSString *numberString = [encryption stringByReplacingCharactersInRange:NSMakeRange(w, n) withString:repalceStr];
    return numberString;
}
    
#pragma mark -手机机型
+(NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceModel;
    }

/**
 * 动态计算高度
 */
+(CGFloat)heightWithWidth:(CGFloat)width font:(CGFloat)font str:(NSString *)string
{
    
    UIFont * fonts = [UIFont systemFontOfSize:font];
    
    CGSize size =CGSizeMake(width, 1000000000000.0);
    
    NSDictionary * dict  = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
    
    size = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size.height;
    
}


/**
 * 动态计算带行间距的高度
 */

+(CGFloat)heightWithFontSize:(CGFloat)fontSize text:(NSString *)text needWidth:(CGFloat)needWidth lineSpacing:(CGFloat )lineSpacing
{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = lineSpacing;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(needWidth, CGFLOAT_MAX) options:options context:nil];

    return rect.size.height;
    
}



/**
 * 字符串转Json数据
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 * 获取应用BundleID
 */
+(NSString*)getBundleID
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/**
 * 是否是4英寸屏幕
 */
+(BOOL)is4InchesScreen
{
    BOOL vaild = NO;
    if (UG_SCREEN_WIDTH == 320) {
        vaild = YES;
    }
    return vaild;
}


#pragma mark- 上报异常信息与错误信息
+(void)reportErrorMessage:(NSNumber *)number  WithReson: (NSString *)reason WithUrl:(NSURL *)url{
    // 上报请求异常的名称
    NSString *exceptionName = [NSString stringWithFormat:@"错误码：%@  原因：%@",number,reason];    //异常的原因pi
    NSString *exceptionReason = [NSString stringWithFormat:@"请求API：%@", url];   //异常请求Api信息
    NSDictionary *exceptionUserInfo = nil;
    NSException *exception = [NSException exceptionWithName:exceptionName reason:exceptionReason userInfo:exceptionUserInfo];
    [Bugly reportException:exception];
}

+(UIImage *)getContentImageWithTargetView:(UIView *)targetView
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, NO, 0.0);
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//加密请求规则
+(NSString *)accessAuthUgcoinEncryption{
    //版本号
    NSString *versionStr = [APP_VERSION stringByReplacingOccurrencesOfString:@"." withString:@""];
    //时间磋（毫秒）
    NSString *timeStr = [self getNowTimeTimestamp3:YES];
    //需要base64加密的字符串
    NSString *base64Str = [NSString stringWithFormat:@"%@%@",versionStr,timeStr];
    //需要MD5加密的字符串
    NSString *md5Str= [NSString stringWithFormat:@"UGCOIN_PLATFORM_KEY_%@",timeStr];
    //base64加密
    NSString *base64Encryption = [self baseAddBase64:base64Str];
    //需要md5加密
    NSString *md5Encryption = [self md5StringFromString:md5Str];
    //最终的结果
    NSString *accessAuthUgcoinEncryptionStr = [NSString stringWithFormat:@"%@-%@",base64Encryption,md5Encryption];
    return  accessAuthUgcoinEncryptionStr;
}

//md5加密  32位小写
+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    return outputString;
}

//当前时间磋 以毫米为单位
+(NSString *)getNowTimeTimestamp3 : (BOOL)isH{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:  isH ? @"YYYY-MM-dd HH:mm:ss SSS" : @"YYYY-MM-dd HH"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

//base64 加密字符串
+(NSString *)baseAddBase64:(NSString *)baseStr{
    NSData *data = [baseStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    return base64Str;
}

//国家取号缓存
+(void)toCreateUGAreacodePlistWith:(NSArray *)areaArray
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UGAreaCode.plist"];
    NSMutableDictionary *areaCodeDic = [[NSMutableDictionary alloc]init];
    NSData *data = [NSJSONSerialization dataWithJSONObject:areaArray options:0 error:NULL];
    [areaCodeDic setObject:data forKey:@"UGAreaData"];
    if ([areaCodeDic writeToFile:plistPath atomically:YES]) {
        NSLog(@"保存成功！！");
    }
    else
    {
        NSLog(@"保存不成功！！");
    }
}

//从plist中获取区号数据
+(NSArray *)GetAreacodeArrayFromPlist
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UGAreaCode.plist"];
    NSMutableDictionary *areaCodeDic  = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * areaArray = [[NSArray alloc]init];
    if (areaCodeDic) {
        NSData *arrayData = [areaCodeDic objectForKey:@"UGAreaData"];
        areaArray = [NSJSONSerialization JSONObjectWithData:arrayData options:0 error:nil];
    }
    return areaArray;
}

//还原发布广告随机数数据
+(void)toCreateUGPlaceAnADRandomNumber
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UGADRandomNumber.plist"];
    NSMutableDictionary *randomNumberDic = [[NSMutableDictionary alloc]init];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    long nowTime =  (long)[datenow timeIntervalSince1970];
    [randomNumberDic setObject:[NSNumber numberWithLong:nowTime] forKey:@"RandomNumber_CreateTime"];
    NSMutableArray *randomNumberArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i<100; i++) {
        if (i< 10) {
            [randomNumberArray addObject:[NSString stringWithFormat:@"0%zd",i]];
        }
        else
        {
            if (i%10 != 0) {
            [randomNumberArray addObject:[NSString stringWithFormat:@"%zd",i]];
            }
        }
    }
    [randomNumberDic setObject:randomNumberArray forKey:@"RandomNumber_Array"];
    if ([randomNumberDic writeToFile:plistPath atomically:YES]) {
        NSLog(@"成功！！");
    }
    else
    {
        NSLog(@"保存不成功！！");
    }

}

//检查本地数据状态
+(void)UGPlaceAnADRandomNumberIsNeedToUpdate
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UGADRandomNumber.plist"];
    NSMutableDictionary *randomNumberDic  = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (randomNumberDic)
    {
        NSNumber *oldTimeNumber = randomNumberDic[@"RandomNumber_CreateTime"];
        long oldTime = [oldTimeNumber longValue];
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        long nowTime =  (long)[datenow timeIntervalSince1970];
        if ((nowTime - oldTime)>300)
        {
            [self toCreateUGPlaceAnADRandomNumber];
        }
    }
    else
    {
        [self toCreateUGPlaceAnADRandomNumber];
    }
}

+(void)toUpdateUGPlaceAnADRandomNumberWith:(NSMutableArray *)randomNumberArray
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UGADRandomNumber.plist"];
    NSMutableDictionary *randomNumberDic  = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSNumber *oldTimeNumber = randomNumberDic[@"RandomNumber_CreateTime"];
    long oldTime = [oldTimeNumber longValue];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    long nowTime =  (long)[datenow timeIntervalSince1970];
    if ((nowTime - oldTime)>300)
    {
        [self toCreateUGPlaceAnADRandomNumber];
    }
    else
    {
        [randomNumberDic setObject:randomNumberArray forKey:@"RandomNumber_Array"];
        if ([randomNumberDic writeToFile:plistPath atomically:YES]) {
            NSLog(@"保存成功！！");
        }
        else
        {
            NSLog(@"保存不成功！！");
        }
    }
}

//从plist中获取区号数据
+(NSMutableArray *)GetPlaceAnADRandomNumberFromPlist
{
    NSMutableArray * randomNumberArray = [[NSMutableArray alloc]init];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *plistPath = [path stringByAppendingPathComponent:@"UGADRandomNumber.plist"];
    NSMutableDictionary *randomNumberDic  = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (randomNumberDic)
    {
        randomNumberArray = [randomNumberDic objectForKey:@"RandomNumber_Array"];
        //当本地的数据用完了
        if (randomNumberArray.count == 0) {
            
            [self toCreateUGPlaceAnADRandomNumber];
            for (NSInteger i = 1; i<100; i++) {
                if (i< 10) {
                    [randomNumberArray addObject:[NSString stringWithFormat:@"0%zd",i]];
                }
                else
                {
                    [randomNumberArray addObject:[NSString stringWithFormat:@"%zd",i]];
                }
            }
     }
    
    }
    return randomNumberArray;
}

//图片压缩
+(UIImage*)imageCompressWithSimple:(UIImage*)image{
    CGSize size = image.size;
    CGFloat scale = 1.0;
    //TODO:KScreenWidth屏幕宽
    if (size.width > UG_SCREEN_HEIGHT || size.height > UG_SCREEN_WIDTH) {
        if (size.width > size.height) {
            scale = UG_SCREEN_HEIGHT / size.width;
        }else {
            scale = UG_SCREEN_WIDTH / size.height;
        }
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    //TODO:设置新图片的宽高
    UIGraphicsBeginImageContext(secSize); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//判读字符串是否为整数
+(BOOL)isPureInteger:(NSString *)inputString
{
    NSScanner *scan = [NSScanner scannerWithString:inputString];
    NSInteger val;
    return [scan scanInteger:&val]&&[scan isAtEnd];
}


//ios oc 判断输入的数是否是另一个的整数倍
+(BOOL)judgeStrIsMultipleOfTenWith:(NSString *)inputString
{
    if (inputString.length) {
       NSString *firstStr = [inputString substringToIndex:1];
       NSArray *array = [inputString componentsSeparatedByString:@"1"];
       NSString *otherNumer = [array lastObject];
       BOOL result = [firstStr isEqualToString:@"1"]&& otherNumer.length && ![otherNumer floatValue];
       return result;
    }
    return NO;
}

@end
