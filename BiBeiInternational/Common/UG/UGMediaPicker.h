//
//  UGMediaPicker.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMediaPicker : NSObject

- (instancetype)initWithController:(UIViewController *)controller;

- (void)imageFromLibrary:(void(^)(NSURL *fileUrl))finishBlock;

- (void)imageFromCamera:(void (^)(NSURL *fileUrl))finishBlock;

- (void)videoFromLibrary:(void(^)(NSURL *fileUrl))finishBlock;

- (void)videoFromCamera:(void(^)(NSURL *fileUrl))finishBlock;

- (NSString *)sizeOf:(NSURL *)fileUrl;

- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
