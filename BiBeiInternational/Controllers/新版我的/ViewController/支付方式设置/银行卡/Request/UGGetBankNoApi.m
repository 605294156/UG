//
//  UGGetBankNoApi.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGGetBankNoApi.h"
@interface UGGetBankNoApi () {
    UIImage *_image;
}
@end

@implementation UGGetBankNoApi
- (id)initWithBankImage:(UIImage *)image{
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

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    return dict;
}

- (NSString *)requestUrl {
    return @"ug/ocr/getBankNo";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        
        NSData *data = UIImageJPEGRepresentation(self->_image, 0.9);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *road = [NSString stringWithFormat:@"%@.jpg", str];
        NSString *fileName = road;
        
        [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    };
}
@end
