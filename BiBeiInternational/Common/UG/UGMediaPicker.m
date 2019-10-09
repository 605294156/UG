//
//  UGMediaPicker.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMediaPicker.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UGMediaPicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation UGMediaPicker{
    
    __weak UIViewController *_controller;
    
    void(^_onFinishBlock)(NSURL *fileUrl);
}

- (instancetype)initWithController:(UIViewController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)imageFromLibrary:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [_controller presentViewController:picker animated:YES completion:nil];
}

- (void)imageFromCamera:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera; // 仅从相机获取
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;// 当相机提供多种模式 (拍照, 录视频) 的时候, 优先选择录视频模式
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [_controller presentViewController:picker animated:YES completion:nil];
}

- (void)videoFromLibrary:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *) kUTTypeMovie];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [_controller presentViewController:picker animated:YES completion:nil];
}

- (void)videoFromCamera:(void (^)(NSURL *fileUrl))finishBlock {
    _onFinishBlock = finishBlock;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera; // 仅从相机获取
    picker.mediaTypes = @[(NSString *) kUTTypeMovie]; // 限定相机只提供录视频模式
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.videoMaximumDuration = 8;
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;// 当相机提供多种模式 (拍照, 录视频) 的时候, 优先选择录视频模式
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [_controller presentViewController:picker animated:YES completion:nil];
}

#pragma UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [_controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"didFinishPickingMediaWithInfo: %@", info);
    
    NSURL *fileUrl;
    if ([info[UIImagePickerControllerMediaType] isEqual:@"public.image"]) {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//相机拍照
            NSString *path = [self saveImage:info[UIImagePickerControllerOriginalImage]];
            fileUrl = [NSURL fileURLWithPath:path];
        } else {//相册图片
            if (@available(iOS 11, *)) {
                fileUrl = info[UIImagePickerControllerImageURL];
            } else {
                NSString *path = [self saveImage:info[UIImagePickerControllerOriginalImage]];
                fileUrl = [NSURL fileURLWithPath:path];
            }
        }
    } else if ([info[UIImagePickerControllerMediaType] isEqual:@"public.movie"]) {
        fileUrl = info[UIImagePickerControllerMediaURL];
//        [self saveVideo:fileUrl];
    }
    NSLog(@"----路径：%@   大小%@",fileUrl.absoluteString, [self sizeOf:fileUrl]);
    _onFinishBlock(fileUrl);
    _onFinishBlock = nil;
//    [self movTomp4:fileUrl finish:^(NSURL *fileUrl) {
//        self->_onFinishBlock(fileUrl);
//        self->_onFinishBlock = nil;
//    }];
}

- (NSString *)saveImage:(UIImage *)image {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/%f.jpeg", time];
    [UIImageJPEGRepresentation(image, 0.5f) writeToFile:path atomically:YES];
    return path;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -获取文件大小
-(NSString *)sizeOf:(NSURL *)fileUrl{
    NSString *sizeString = @"UNKNOWN";
    NSError *error = nil;
    NSDictionary *sizeDic = [fileUrl resourceValuesForKeys:@[NSURLFileSizeKey] error:&error];
    //[self log:[NSString stringWithFormat:@"NSDictionary for NSURLFileSizeKey: %@", sizeDic]];
    if (error) {
        NSString *msg = [NSString stringWithFormat:@"%@", error];
        NSLog(@"%@",msg);
    } else {
        NSNumber *size = [sizeDic valueForKey:NSURLFileSizeKey];
        long fileSize = [size longValue];
        long KB = 1024l;
        long MB = 1024l * KB;
        if (MB <= fileSize) {
            sizeString = [NSString stringWithFormat:@"%.2fMB", fileSize * 1.0f / MB];
        } else if (0l < fileSize < MB) {
            sizeString = [NSString stringWithFormat:@"%.2fKB", fileSize * 1.0f / KB];
        }
    }
    return sizeString;
}

#pragma mark ---- 获取图片第一帧
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

#pragma mark - 保存视频到相册
- (void)saveVideo:(NSURL *)outputFileURL
{
    //ALAssetsLibrary提供了我们对iOS设备中的相片、视频的访问。
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            NSLog(@"保存视频失败:%@",error);
        } else {
            NSLog(@"保存视频到相册成功");
        }
    }];
}

#pragma mark - 视频压缩
-(void)getAVURLAssetUrl:(NSURL *)path{
    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
        //输出URL
        exportSession.outputURL =path;
        //优化网络
        exportSession.shouldOptimizeForNetworkUse = true;
        //转换后的格式
        exportSession.outputFileType = AVFileTypeMPEG4;
        //异步导出
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            // 如果导出的状态为完成
            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
                [self saveVideo:path];
                [self sizeOf:path];
            }else{
                NSLog(@"当前压缩进度:%f",exportSession.progress);
            }
            NSLog(@"%@",exportSession.error);
        }];
    }
}

#pragma mark- 转MP4 格式   //暂时没用到 后期可能需要转换
- (void)movTomp4:(NSURL *)movUrl finish:(void (^)(NSURL *fileUrl))finishBlock
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    /**
     AVAssetExportPresetMediumQuality 表示视频的转换质量，
     */
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        //转换完成保存的文件路径
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4",@"cvt"];
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        //要转换的格式，这里使用 MP4
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //转换的数据是否对网络使用优化
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        //异步处理开始转换
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         {
             
             //转换状态监控
             switch (exportSession.status) {
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     //转换完成
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     //测试使用，保存在手机相册里面
                     [self saveVideo:exportSession.outputURL];
                     
                     if (finishBlock) {
                         finishBlock(exportSession.outputURL);
                     }
                     break;
                 }
             }
             
         }];
    }
}


@end
