
//  QRCodeViewModel.h


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^Analysis_GetPicInfoSuccess)(NSString *resultString);

typedef void (^Analysis_GetPicInfoFailure)(void);

@interface QRCodeViewModel : NSObject

+ (instancetype)sharedInstance;

//根据传入的字符串生成二维码图片
+(UIImage *)createQRimageString:(NSString *)QRString sizeWidth:(CGFloat)sizeWidth fillColor:(UIColor *)color;

//读取二维码图片信息，返回二维码内容
+(NSString *)readQRCodeFromImage:(UIImage *)image;

//从图片中识别二维码
-(void)GetQrcodeInfoFromAPicture:(UIImage *)qrcodeImage SuccessBlock:(Analysis_GetPicInfoSuccess)success FailureBlock:(Analysis_GetPicInfoFailure)failure;

@end
