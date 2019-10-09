//
//  UIViewController+Order.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UIViewController+Order.h"

#import "OTCJpushViewController.h"
#import "UGOTCCanelOrderApi.h"
#import "UGAssetsViewController.h"
#import "OTCComplaintViewController.h"
#import "OTCCancelledDetailsVC.h"

#import "UGBindingGoogleVC.h"
#import "UGBasePageViewController.h"
#import "UGAffirmAppealLimitTimeApi.h"

@implementation UIViewController (Order)


#pragma mark - 处理OTC订单状态跳转
- (void)pustToOTCOrderDetailsWithOrderSn:(NSString *)orderSn {
    OTCJpushViewController *vc = [OTCJpushViewController new];
    vc.orderSn = orderSn;
    [self.navigationController pushViewController:vc animated:YES];
}

//取消订单
- (void)cancelOroderWithOrderSn:(NSString *)oderSn handle:(void(^)(void))handle {
    NSString *messageStr = [self upDataMessage:@"cancelTrade" WithMessage:@"请您确认要取消本次交易！当日累计2笔取消，将会禁用交易24小时"];
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"取消交易" message: messageStr cancle:@"我再想想" others:@[@"确认取消"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        if (buttonIndex == 1) {
            @strongify(self);
            [self sendCancleOrderRequestWithOrderSn:oderSn handle:handle];
        }
    }];
}

-(NSString *)upDataMessage:(NSString *)dickey  WithMessage:(NSString *)msg{
    NSString *msgStr = msg;
    if ( ![UGManager shareInstance].hostInfo ||  ![UGManager shareInstance].hostInfo.userInfoModel || UG_CheckArrayIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList) || [UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList.count<0 ) {
        return msgStr;
    }
    for (UGMessageDictionary *item in [UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList){
        if ([item.dicKey isEqualToString:dickey]) {
            msgStr = item.dicValue;
            break;
        }
    }
    return  msgStr;
}

/**
 去申诉
 
 @param oderSn 订单号
 */
- (void)pushToOrderAppealWithOrderSn:(NSString *)oderSn WithReSubmit:(BOOL)resubmit{
    UGAffirmAppealLimitTimeApi *api = [UGAffirmAppealLimitTimeApi new];
    api.orderSn = oderSn;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object) {
            OTCComplaintViewController *complaintVC = [OTCComplaintViewController new];
            complaintVC.orderSn = oderSn;
            complaintVC.reSubmit = resubmit;
            [self.navigationController pushViewController:complaintVC animated:YES];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

/**
 去查看资产
 资产详情页面
 */
- (void)pushToAssetsViewController {
    [self.navigationController pushViewController:[UGAssetsViewController new] animated:YES];
}

#pragma mark - Request
//取消支付
- (void)sendCancleOrderRequestWithOrderSn:(NSString *)oderSn handle:(void(^)(void))handle {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCCanelOrderApi *api = [UGOTCCanelOrderApi new];
    api.orderSn = oderSn;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            //订单已取消页面
            OTCCancelledDetailsVC *vc = [OTCCancelledDetailsVC new];
            vc.orderSn = oderSn;
            [self.navigationController pushViewController:vc animated:YES];
        }  else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        //后台已经支付
        if (apiError.errorNumber == 508 && handle) {
            handle();
        }
    }];
}

#pragma mark - 检查谷歌验证器绑定状态

- (BOOL)hasBindingGoogleValidator {
    BOOL hasGoogleValidation = [UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation;
    if (!hasGoogleValidation){
        UGBindingGoogleVC *vc = [[UGBindingGoogleVC alloc] init];
        if ([self.parentViewController isKindOfClass:[UGBasePageViewController class]]) {
            vc.baseVC = self.parentViewController;
        } else {
            vc.baseVC = self;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    return hasGoogleValidation;
}


//带提示弹框的是否绑定谷歌验证器
- (BOOL)alerterHasBindingGoogleValidator
{
    BOOL hasGoogleValidation = [UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation;
    if (!hasGoogleValidation){
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"绑定提醒" message:@"为了您的资产安全，交易前请您先绑定谷歌验证器" cancle:@"我偏不" others:@[@"去绑定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
         if (buttonIndex == 1) {
            @strongify(self);
            UGBindingGoogleVC *vc = [[UGBindingGoogleVC alloc] init];
            if ([self.parentViewController isKindOfClass:[UGBasePageViewController class]]) {
                vc.baseVC = self.parentViewController;
            }else
            {
             vc.baseVC = self;
            }
            [self.navigationController pushViewController:vc animated:YES];
            }
                }];
    }
    return hasGoogleValidation;
}



@end
