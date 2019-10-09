//
//  UIViewController+expand.h
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    UGBarImteTypeLeft = 0,
    UGBarImteTypeRight
}UGBarImteType;



NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (expand)



/**
 图片添加barbuttonItems 一次性添加左、右按钮多个
 
 @param imageList 图片列表
 @param type 左边还是右边，指定全部按钮的位置
 @param callBack 回调
 @return customView的数组列表
 */
- (NSArray <UIButton *>*)setupBarButtonItemsWithImageList:(NSArray <NSString*>*)imageList type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item, NSInteger index, UIButton *btn))callBack;

/**
 图片添加barbuttonItem

 @param type 左边还是右边
 @param imageName 图片名字
 @param callBack 响应block
 @return customView
 */

- (UIButton *)setupBarButtonItemWithImageName:(NSString *)imageName type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item))callBack;


/**
 文字添加barbuttonItems 一次性添加左、右按钮多个
 默认白色文字
 @param type 左边还是右边，指定全部按钮的位置
 @param titleList 按钮名称数组
 @param callBack 响应block
 @return customView的数组列表
 */
- (NSArray <UIButton*> *)setupBarButtonItemsWithTitleList:(NSArray <NSString*>*)titleList type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item, NSInteger index, UIButton *btn))callBack;


/**
 文字添加barbuttonItem
 默认白色文字
 @param type 左边还是右边
 @param title buttonTitle
 @param callBack 响应block
 @return customView
 */
- (UIButton *)setupBarButtonItemWithTitle:(NSString *)title type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item))callBack;


/**
 文字添加barbuttonItem
 需要传入标题颜色
 @param title 文字
 @param type 左边还是右边
 @param titleColor 文字颜色
 @param callBack 响应block
 @return customView
 */
- (UIButton *)setupBarButtonItemWithTitle:(NSString *)title type:(UGBarImteType )type titleColor:(UIColor *)titleColor callBack:(void(^)(UIBarButtonItem *item))callBack;





@end

NS_ASSUME_NONNULL_END
