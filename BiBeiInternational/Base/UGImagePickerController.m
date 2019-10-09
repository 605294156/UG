//
//  HFImagePickerController.m
//  HappyFishing_iPhone
//
//  Created by fuyoufang on 2017/3/3.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import "UGImagePickerController.h"

@interface UGImagePickerController ()

@end

@implementation UGImagePickerController

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<TZImagePickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc {
    self = [super initWithMaxImagesCount:maxImagesCount columnNumber:columnNumber delegate:delegate pushPhotoPickerVc:pushPhotoPickerVc];
    if (self) {
        self.alwaysEnableDoneBtn = YES;
        self.allowPickingVideo = NO;
        self.allowPickingGif = NO;
        self.allowTakePicture = NO;
        self.allowPickingOriginalPhoto = NO;
        self.barItemTextColor = [UIColor blackColor];
        self.naviBgColor = UG_MainColor;
        self.naviTitleColor = [UIColor whiteColor];
        self.naviTitleFont = [UIFont systemFontOfSize:20];
        self.barItemTextColor = self.naviTitleColor;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
