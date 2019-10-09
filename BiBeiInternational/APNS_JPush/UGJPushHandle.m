//
//  HFMinPushHandle.m
//  HappyFishing_iPhone
//
//  Created by gL on 2017/2/21.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import "UGJPushHandle.h"
#import "UGRemotemessageHandle.h"
#import "UGTabBarController.h"
#import "AppDelegate.h"
#import "UIViewController+Utils.h"
#import "UGBillDetailVC.h"
#import "UGTransferView.h"
#import "UGHomeReceiptCoinVC.h"
#import "PopView.h"
#import "UGNotifyUpdateStatusApi.h"
//#import "JPUSHService.h"
#import "UGMessageApi.h"
#import "UGNotifyModel.h"
#import "UGupdateAllApi.h"
#import "UGBasePageViewController.h"
#import "OTCJpushViewController.h"
#import "UGSystemMessageDetailVC.h"
#import "UGAdDetailVC.h"
#import "QYSDK.h"

@implementation UGJPushHandle

#pragma mark - 页面跳转
+ (void)controlJPush:(UGBaseNotiyMessage *)messageModel {
    //转收币
    if ([messageModel isKindOfClass:[UGTransferModel class]]) {
        //1.跳转到UG钱包记录详情页面
        [PopView hidenPopView];
        UGTransferModel *model = (UGTransferModel *)messageModel;
        UGBillDetailVC *vc = [UGBillDetailVC new];
        vc.orderSn= model.orderSn;
        vc.orderType= [model.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"0": @"1";
        [self changeMesageStatus:model.ID];
        [[self getNavigationController] pushViewController:vc animated:YES];
        return;
    }
    //OTC、交易
    if ([messageModel isKindOfClass:[UGOTCOrderMeeageModel class]]) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"收到新的详情消息" object:nil];
        UGOTCOrderMeeageModel *oderModel = (UGOTCOrderMeeageModel *)messageModel;
        [self changeMesageStatus:oderModel.ID];
        if ([oderModel.otcMessageType isEqualToString: @"OTC_ORDER_MSG"]) {
            //订单详情  通知 刷新详情数据
             [self pushToOTCViewControllerWithOrderSn:oderModel.orderSn];
        } else if ([oderModel.otcMessageType isEqualToString: @"OTC_ADVERTISE_MSG"]) {
            //广告详情
            UGAdDetailVC *vc =  [UGAdDetailVC new];
            vc.advertiseId = oderModel.advertiseId;
            [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
        }
        return;
    }
    
    //OTC通知消息
    if ([messageModel isKindOfClass:[UGJpushNotifyModel class]]) {
        //OTC出售订单——已付款
        //OTC出售交易——已付款      详情页
        //OTC购买交易——待付款
        //申诉 --- 取消
        //申诉 --- 放币
        //接单通知
        UGJpushNotifyModel *orderModel = (UGJpushNotifyModel *)messageModel;
        [self changeMesageStatus:orderModel.ID];
        [self pushToOTCViewControllerWithOrderSn:orderModel.orderSn];
        return;
    }
    
    //系统消息
    if ([messageModel isKindOfClass:[UGJpushSystemModel class]]) {
        UGJpushSystemModel *systemModel = (UGJpushSystemModel *)messageModel;
        [self changeMesageStatus:systemModel.ID];
        UGSystemMessageDetailVC *detailVC = [UGSystemMessageDetailVC new];
        detailVC.notifyModel = systemModel;
        [[self getNavigationController] pushViewController:detailVC animated:YES];
        return;
    }
}

+ (void)pushToOTCViewControllerWithOrderSn:(NSString *)orderSn {
    OTCJpushViewController *vc = [OTCJpushViewController new];
    vc.orderSn = orderSn;
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取当前控制器Nav
+ (UINavigationController *)getNavigationController {
    UIViewController *viewController =  [UIViewController currentViewController];
    return viewController.navigationController;
}

+(void)popViewShow:(UGBaseNotiyMessage *)model{
    if ([model isKindOfClass:[UGTransferModel class]]) {
        UGTransferModel *temp = (UGTransferModel *)model;
        if ([temp.orderType isEqualToString:@"SUB_TYPE_RECEIPT"]) {
            [UGTransferView showPopViewWithModel:(UGTransferModel *)model clickItemHandle:^{
            }];
        }
    }
}

#pragma mark- 修改消息状态为 已读
+(void)changeMesageStatus:(NSString *)msgId{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UGNotifyUpdateStatusApi *api = [UGNotifyUpdateStatusApi new];
        api.ids = msgId;
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        }];
    });
}

#pragma mark - 设置icon 角标  标签栏角标  j服务器角标
+(void)setBageWith:(NSInteger)bageNum{
    
//        NSLog(@"剩余未读数：%zd",bageNum);
    //设置icon 角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:bageNum];
    //相当于告诉j服务器我现在的角标是多少
//    [JPUSHService setBadge:bageNum];
    //设置tab角标
    UGTabBarController *ugTabbar=(UGTabBarController *) APPLICATION.window.rootViewController;
    UITabBarItem * item=[ugTabbar.tabBar.items objectAtIndex:2];
//    NSLog(@"当前角标未读数：%@",item.badgeValue);
    item.badgeValue =  bageNum == 0 ? nil : [NSString stringWithFormat:@"%zd",bageNum];
}

#pragma mark - 拿到目前消息未读数
+ (void)getMessageVCDataCompletionBlock:(UGRequestCompletionBlock)completionBlock{
    UGMessageApi *api = [UGMessageApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                UGNotifySuperModel *notifySuperModel = [UGNotifySuperModel mj_objectWithKeyValues:object];
                //设置角标
                
                //j未读数的
//                NSInteger jmTotal =notifySuperModel.systemNoNum+notifySuperModel.balanceNoNum + notifySuperModel.informNoNum + [[JMSGConversation getAllUnreadCount] integerValue];
                     NSInteger jmTotal =notifySuperModel.systemNoNum+notifySuperModel.balanceNoNum + notifySuperModel.informNoNum;
                //网易七鱼客服未读数的(之前都是用j的 后来 迫于修改。。。。。。。)
                NSInteger qyTotal = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
                [self setBageWith:jmTotal+qyTotal];
                completionBlock(apiError,notifySuperModel);
            }
        }else{
            completionBlock(apiError,object);
        }
    }];
}

#pragma mark - 消息状态修改（接收者和消息的类型）
+ (void)updateMessageWithType:(NSString *)parentMessageType CompletionBlock:(UGRequestCompletionBlock)completionBlock{
    UGupdateAllApi *api = [UGupdateAllApi new];
    api.parentMessageType = parentMessageType;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        completionBlock(apiError,object);
    }];
}

///**
// 打开外部h5
// @param urlString 链接地址
// */
//+ (void)oepnSafariWithUrl:(NSString *)urlString {
//    if (![urlString hasPrefix:@"http://"] && ![urlString hasPrefix:@"https://"]) {
//        urlString = [NSString stringWithFormat:@"http://%@",urlString];
//    }
//    NSURL *url = [NSURL URLWithString:urlString];
//    if ([[UIApplication sharedApplication] canOpenURL:url]) {
//        [[UIApplication sharedApplication] openURL:url];
//    }
//}

@end
