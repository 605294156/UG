//
//  UIAlertController+moreColor.m
//  Live
//
//  Created by Flame on 16/3/19.
//  Copyright © 2016年 aini25. All rights reserved.
//

#import "UIAlertController+moreColor.h"
#import "UIViewController+Utils.h"


static BOOL isShow = NO;

@implementation UIAlertController (moreColor)

+ (instancetype)ug_showAlertWithStyle:(UIAlertControllerStyle)style
                            title:(NSString *)title
                          message:(NSString *)msg
                           cancle:(NSString *)cancle
                           others:(NSArray<NSString *> *)others
                           handle:(void(^)(NSInteger buttonIndex,UIAlertAction *action)) handle {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    NSInteger actionIndex = 0;
    if (cancle) {
        [alert addCancelActionWithTitle:cancle Color:nil handler:^(UIAlertAction *action) {
            if (handle) {
                handle(actionIndex,action);
            }
        }];
    }else{
        actionIndex = -1;
    }
    if ([others isKindOfClass:[NSArray class]]) {
        for (NSString *title in others) {
            actionIndex++;
            [alert addActionWithTitle:title Color:nil handler:^(UIAlertAction *action) {
                if (handle) {
                    handle(actionIndex,action);
                }
            }];
        }
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [alert showAlert];
    });
    return alert;
}

- (void)showAlert {
    if ([[UIViewController currentViewController] isKindOfClass:[UIAlertController class]]) {
        return;
    }
    [[UIViewController currentViewController] presentViewController:self animated:YES completion:nil];
}

+ (instancetype)ug_showAlertWithStyle:(UIAlertControllerStyle)style
                                title:(NSString *)title
                              message:(NSString *)msg
                               cancle:(NSString *)cancle
                               others:(NSArray<NSString *> *)others
                       viewController:(UIViewController *)viewController
                               handle:(void(^)(NSInteger buttonIndex,UIAlertAction *action)) handle{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    NSInteger actionIndex = 0;
    if (cancle) {
        [alert addCancelActionWithTitle:cancle Color:nil handler:^(UIAlertAction *action) {
            if (handle) {
                handle(actionIndex,action);
            }
        }];
    } else {
        actionIndex = -1;
    }
    
    if ([others isKindOfClass:[NSArray class]]) {
        for (NSString *title in others) {
            actionIndex++;
            [alert addActionWithTitle:title Color:nil handler:^(UIAlertAction *action) {
                if (handle) {
                    handle(actionIndex,action);
                }
            }];
        }
    }

    [alert showInViewController:viewController];
    return alert;
}

- (void)showInViewController:(UIViewController *)viewController {
    [viewController presentViewController:self animated:YES completion:nil];
}



- (void)addActionWithTitle:(NSString *)title Color:(UIColor *)color handler:(void (^)(UIAlertAction *action))hand {
    if (hand==nil) { isShow = NO; }
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        isShow = NO;

        if (hand) {
            hand(action);
        }
    }];
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_3) {
        [action setValue:color forKey:@"_titleTextColor"];//此属性8.3才有
    }

    [self addAction:action];
}

- (void)addCancelActionWithTitle:(NSString *)title Color:(UIColor *)color handler:(void (^)(UIAlertAction *action))hand {
    if (hand==nil) { isShow = NO; }
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        if (hand) {
            hand(action);
        }
    }];
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_3) {
        [action setValue:color forKey:@"_titleTextColor"];//此属性8.3才有
    }
    [self addAction:action];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (BOOL)shouldAutorotate {
    return YES;
}



@end
