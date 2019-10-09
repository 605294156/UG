//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhoto.h"
#import "UGBaseViewController.h"

@protocol MJPhotoBrowserDelegate;

@interface MJPhotoBrowser : UGBaseViewController <UIScrollViewDelegate>
// 所有的图片对象
@property (nonatomic, strong) NSArray *photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
// 保存按钮
@property (nonatomic, assign) NSUInteger showSaveBtn;

// 显示
- (void)show;


/**
 本地图片
 */
+ (void)showlocalImages:(NSArray <UIImage *>*)images currentImage:(UIImage *)currentImage;


/**
 需要下载
 */
+ (void)showOnlineImages:(NSArray <NSString *>*)images currentItem:(NSString *)currentItem;


@end
