//
//  AppDelegate+Pay.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/15.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+Pay.h"
#import "UIViewController+Utils.h"
#import "UGPayViewController.h"
#import "UGSettingPayPassWordVC.h"
#import "UGOrder.h"

@implementation AppDelegate (Pay)

- (BOOL)ug_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.orderString = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    return [self handlePayOrderWithOrderString:self.orderString];
}

- (BOOL)ug_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
 self.orderString = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    return [self handlePayOrderWithOrderString:self.orderString];
}

#pragma mark - Private Method

- (BOOL)handlePayOrderWithOrderString:(NSString *)orderString {
    
    //没登录、没有绑定谷歌验证器
    if (![[UGManager shareInstance] hasLogged]) {
        return NO;
    }
    //没有交易密码
    if (![UGManager shareInstance].hostInfo.userInfoModel.hasJypassword) {
        //顶层控制器不是设置交易密码控制器
        if (![[UIViewController currentViewController] isKindOfClass:[UGSettingPayPassWordVC class]]) {
            // 进行支付密码设置
            UGSettingPayPassWordVC *vc =[UGSettingPayPassWordVC new];
            [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
        }
        return NO;
    }
    //没有绑定谷歌验证、没绑定会直接进去绑定    2.0换手机号
//    BOOL hasBindingGoogle = [[UIViewController currentViewController] hasBindingGoogleValidator];
//    if (!hasBindingGoogle) {
//        return NO;
//    }

    NSArray *list = [orderString componentsSeparatedByString:@"&"];
    NSString *appScheme = [list.firstObject substringFromIndex:[list.firstObject rangeOfString:@"appScheme="].length];
    NSString *orderStr = [self dencode:[list.lastObject substringFromIndex:[list.lastObject rangeOfString:@"order="].length]];
    NSDictionary *dict = [orderStr mj_JSONObject];
    UGOrder *order = [UGOrder mj_objectWithKeyValues:dict];
    BOOL show = appScheme.length > 0 && [order.tradeUgNumber doubleValue] > 0 && order.orderSn.length >0 && order.merchNo.length > 0 ;
    
    if (show) {
        [[UIViewController currentViewController].navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UGPayViewController class]]) {
                [obj.navigationController popViewControllerAnimated:NO];
            }
        }];
        //置空第三方支付订单信息
        self.orderString = nil;
        //支付页面
        UGPayViewController *payVC = [UGPayViewController new];
        payVC.orderModel = order;
        payVC.fomeScheme = appScheme;
        [[UIViewController currentViewController].navigationController pushViewController:payVC animated:YES];
        
    } else {
        NSString *message =  order.orderSn.length == 0 ? @"订单号不能为空！" : order.merchNo.length == 0 ? @"收款方商户号为空！"  : order.tradeUgNumber.length == 0 ? @"商品总价为0！" : @"appScheme地址不能为空！";
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"收到支付订单" message:message cancle:@"确定" others:nil handle:nil];
    }
    return show;
}

- (NSString *)dencode:(NSString *)base64String {
    if (base64String) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return string;
    }
    return nil;
}




@end
