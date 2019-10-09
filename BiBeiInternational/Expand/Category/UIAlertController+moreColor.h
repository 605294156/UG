//
//  UIAlertController+moreColor.h
//  Live
//
//  Created by Flame on 16/3/19.
//  Copyright © 2016年 aini25. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (moreColor)

+ (instancetype)ug_showAlertWithStyle:(UIAlertControllerStyle)style
                            title:(NSString *)title
                          message:(NSString *)msg
                           cancle:(NSString *)cancle
                           others:(NSArray<NSString *> *)others
                           handle:(void(^)(NSInteger buttonIndex,UIAlertAction *action)) handle;

+ (instancetype)ug_showAlertWithStyle:(UIAlertControllerStyle)style
                                title:(NSString *)title
                              message:(NSString *)msg
                               cancle:(NSString *)cancle
                               others:(NSArray<NSString *> *)others
                       viewController:(UIViewController *)viewController
                               handle:(void(^)(NSInteger buttonIndex,UIAlertAction *action)) handle;

- (void)addActionWithTitle:(NSString *)title Color:(UIColor *)color handler:(void (^)(UIAlertAction * action))hand;


- (void)addCancelActionWithTitle:(NSString *)title Color:(UIColor *)color handler:(void (^)(UIAlertAction *action))hand;



@end
