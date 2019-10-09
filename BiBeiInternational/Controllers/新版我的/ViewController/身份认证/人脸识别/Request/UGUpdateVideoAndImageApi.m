//
//  UGUpdateVideoAndImageApi.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGUpdateVideoAndImageApi.h"
#import <AVFoundation/AVFoundation.h>
@interface UGUpdateVideoAndImageApi () {
    NSData *_videoData;
}
@end

@implementation UGUpdateVideoAndImageApi
- (id)initWithVideoPath:(NSData *)data{
    self = [super init];
    if (self) {
        _videoData = data;
    }
    return self;
}

- (id)requestArgument {
    NSMutableDictionary *dict  = [super requestArgument];
    [dict removeObjectForKey:@"id"];
    [dict setObject:!UG_CheckStrIsEmpty(self.validateData)? self.validateData : @"" forKey:@"validateData"];
     [dict setObject:!UG_CheckStrIsEmpty(self.userId)? self.userId : @"" forKey:@"id"];
     [dict setObject:!UG_CheckStrIsEmpty(self.username)? self.username : @"" forKey:@"username"];
    return dict;
}

- (NSString *)requestUrl {
    return @"ug/application/validFaceReconize";
}

- (AFConstructingBlock)constructingBodyBlock{
    if (!self->_videoData)
        return ^(id<AFMultipartFormData> formData) {};
    return ^(id<AFMultipartFormData> formData) {
        //视频
        NSDateFormatter *formatterVideo = [[NSDateFormatter alloc] init];
        formatterVideo.dateFormat = @"yyyyMMddHHmmss";
        NSString *videostr = [formatterVideo stringFromDate:[NSDate date]];
        NSString *videoName = [NSString stringWithFormat:@"%@.mov", videostr];
        NSString *videoformKey = @"video";
        NSString *videotype = @"video/mov";
        [formData appendPartWithFileData:self->_videoData name:videoformKey fileName:videoName mimeType:videotype];
    };
}

@end
