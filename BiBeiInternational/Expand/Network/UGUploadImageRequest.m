//
//  UGUploadImageRequest.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGUploadImageRequest.h"

@interface UGUploadImageRequest () {
    UIImage *_image;
    NSString *_fileName;

}

@end

@implementation UGUploadImageRequest

- (instancetype)initWithImage:(UIImage *)image fileName:(NSString *)fileName {
    self = [super init];
    if (self) {
        _image = image;
        _fileName = fileName;
    }
    return self;
}


- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 30;
}

- (NSString *)requestUrl {
    return @"ug/common/upload/oss/image";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        //控制图片大小在1m 以下
        NSData *data =[UG_MethodsTool compressImageQuality:self->_image toByte:1024*1024];
//       NSData *data = UIImageJPEGRepresentation(self->_image, 0.9);

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *road = [NSString stringWithFormat:@"%@.jpg", str];
        
        NSString *fileName = self->_fileName != nil ? [NSString stringWithFormat:@"%@.jpg",self->_fileName] : road;
    
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    };
}

@end
