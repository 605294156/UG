//
//  MineNetManager.m
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MineNetManager.h"

@implementation MineNetManager
//身份认证
+(void)identityAuthenticationRealName:(NSString *)realName andIdCard:(NSString *)idCard andCardDic:(NSMutableDictionary *)cardDic CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/real/name";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"realName"] = realName;
    dic[@"idCard"] = idCard;
    dic[@"idCardFront"] = cardDic[@"idCardFront"];
    dic[@"idCardBack"] = cardDic[@"idCardBack"];
    dic[@"handHeldIdCard"] = cardDic[@"handHeldIdCard"];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置交易密码
+(void)moneyPasswordForJyPassword:(NSString *)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/transaction/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"jyPassword"] = jyPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取重置交易密码的验证码
+(void)resetMoneyPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/transaction/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//重置交易密码
+(void)resetMoneyPasswordForCode:(NSString *)code withNewPassword:(NSString *)newPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/reset/transaction/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"newPassword"] = newPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//修改交易密码
+(void)resetMoneyPasswordForOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/update/transaction/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"oldPassword"] = oldPassword;
    dic[@"newPassword"] = latestPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取绑定邮箱的验证码
+(void)bindingEmailCodeForEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/bind/email/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"email"] = email;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//绑定邮箱
+(void)bindingEmailForCode:(NSString *)code withPassword:(NSString *)password withEmail:(NSString *)email CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/bind/email";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"password"] = password;
    dic[@"email"] = email;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取绑定手机的验证码
+(void)bindingPhoneCodeForPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/bind/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"phone"] = phone;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//绑定手机
+(void)bindingPhoneForCode:(NSString *)code withPassword:(NSString *)password withPhone:(NSString *)phone CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/bind/phone";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"password"] = password;
    dic[@"phone"] = phone;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取重置登录密码的验证码
+(void)resetLoginPasswordCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/update/password/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//重置登录密码
+(void)resetLoginPasswordForCode:(NSString *)code withOldPassword:(NSString *)oldPassword withLatestPassword:(NSString *)latestPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/update/password";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"code"] = code;
    dic[@"oldPassword"] = oldPassword;
    dic[@"newPassword"] = latestPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//我的订单
+(void)myBillInfoForStatus:(NSString *)status withPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/order/self";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"status"] = status;
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//账号设置的状态信息获取
+(void)accountSettingInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/security/setting";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取我的UG钱包所有信息
+(void)getMyWalletInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/asset/wallet";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//获取我的交易
+(void)getMyAdvertisingForPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/all";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//上架我的交易
+(void)upMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/on/shelves";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertisingId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//下架我的交易
+(void)downMyAdvertisingForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/off/shelves";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertisingId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取交易的详细信息
+(void)getMyAdvertisingDetailInfoForAdvertisingId:(NSString *)advertisingId CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/detail";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertisingId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//明细 获取交易历史
+(void)getTradeHistoryForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/asset/transaction/all";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

#warning  Unused 未调用
//上传图片
+(void)uploadImageForFile:(NSData *)file CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"ug/common/upload/oss/image";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"file"] = file;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置头像
+(void)setHeadImageForUrl:(NSString *)urlString CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/change/avatar";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"url"] = urlString;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提币申请
+(void)mentionCoinApplyForUnit:(NSString *)unit withAddress:(NSString*)address withAmount:(NSString *)amount withFee:(NSString *)fee withRemark:(NSString *)remark withJyPassword:(NSString *)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/withdraw/apply";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"unit"] = unit;
    dic[@"remark"] = remark;
    dic[@"address"] = address;
    dic[@"amount"] = amount;
    dic[@"fee"] = fee;
    dic[@"jyPassword"] = jyPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//提币选择信息
+(void)mentionCoinInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/withdraw/support/coin/info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//1付款 2取消
+(void)myBillDetailTipForUrlString:(NSString *)urlString withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = urlString;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
// 4放款
+(void)myBillDetailTipForOrderSn:(NSString *)orderSn withJyPassword:(NSString*)jyPassword CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/order/release";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    dic[@"jyPassword"] = jyPassword;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//订单投诉
+(void)myBillDetailComplaintsForRemark:(NSString *)remark withOrderSn:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
{
    NSString *path = @"otc/order/appeal";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    dic[@"remark"] = remark;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//平台消息
+(void)getPlatformMessageForCompleteHandleWithPageNo:(NSString*)pageNo withPageSize:(NSString *)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/announcement/page";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取更改绑定手机的验证码
+(void)changePhoneNumCodeForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/mobile/change/code";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//更换手机号
+(void)changePhoneNumForPassword:(NSString *)password withPhone:(NSString*)phone withCode:(NSString *)code CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/change/phone";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"password"] = password;
    dic[@"phone"] = phone;
    dic[@"code"] = code;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//上传反馈意见
+(void)takeUpFeedBackForRemark:(NSString *)remark CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/feedback";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"remark"] = remark;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//关于我们
+(void)aboutUSInfo:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/ancillary/website/info";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//订单详情页
+(void)myBillDetailForId:(NSString *)orderSn CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/order/detail";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderSn"] = orderSn;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//获取历史聊天记录
+(void)chatRecordDetailForId:(NSString *)orderSn uidTo:(NSString *)uidTo uidFrom:(NSString *)uidFrom limit:(NSString *)limit page:(NSString *)page sortFiled:(NSString *)sortFiled CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"chat/getHistoryMessage";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"orderId"] = orderSn;
//    dic[@"uidTo"] = uidTo;
//    dic[@"uidFrom"] = uidFrom;
    dic[@"limit"] = limit;
    dic[@"page"] = page;
    dic[@"sortFiled"] = sortFiled;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

#warning Unused 未调用
//查看历史委托
+(void)historyEntrustForPageNo:(NSString *)pageNo withPageSize:(NSString*)pageSize CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
{
    NSString *path = @"exchange/order/history";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"pageNo"] = pageNo;
    dic[@"pageSize"] = pageSize;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

#warning Unused 未调用
//查看委托详情
+(void)historyEntrustDetailForOrderId:(NSString *)orderId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = orderId;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];

}
//提交的身份认证信息获取
+(void)getIdentifyInfo:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/real/detail";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//获取交易对数据
+(void)getTradCoinForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"market/symbol";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//获取收款账户信息
+(void)getPayAccountInfoForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/approve/account/setting";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置银行卡
+(void)setBankNumForUrlString:(NSString *)url withBank:(NSString *)bank withBranch:(NSString *)branch withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withCardNo:(NSString *)cardNo CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = url;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"bank"] = bank;
    dic[@"branch"] = branch;
    dic[@"jyPassword"] = jyPassword;
    dic[@"realName"] = realName;
    dic[@"cardNo"] = cardNo;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置支付宝账号
+(void)setAliPayForUrlString:(NSString *)url withAli:(NSString *)ali withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = url;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"ali"] = ali;
    dic[@"jyPassword"] = jyPassword;
    dic[@"realName"] = realName;
    dic[@"qrCodeUrl"] = qrCodeUrl;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//设置微信账号
+(void)setWeChatForUrlString:(NSString *)url withWechat:(NSString *)wechat withJyPassword:(NSString *)jyPassword withRealName:(NSString *)realName withQrCodeUrl:(NSString *)qrCodeUrl CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = url;
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"wechat"] = wechat;
    dic[@"jyPassword"] = jyPassword;
    dic[@"realName"] = realName;
    dic[@"qrCodeUrl"] = qrCodeUrl;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//推广好友记录
+(void)getPromoteFriendsForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/promotion/record";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}

//我的佣金记录
+(void)getMyCommissionForCompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"uc/promotion/reward/record";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//版本更新
+(void)versionUpdateForId:(NSString *)ID  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = [NSString stringWithFormat:@"uc/ancillary/system/app/version/%@",ID];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [self requestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//删除我的交易
+(void)deleteAdvertiseForAdvertiseId:(NSString *)advertiseId  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle{
    NSString *path = @"otc/advertise/delete";
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"id"] = advertiseId;
    [self ylNonTokenRequestWithGET:path parameters:dic successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
//数据流上传图片
+(void)uploadImageData:(NSData *)imageData  CompleteHandle:(void(^)(id resPonseObj,int code))completeHandle;
{
    NSString *path = @"ug/common/upload/oss/image";
    [self uploadImageDataWith:path imageData:imageData successBlock:^(id resultObject, int isSuccessed) {
        completeHandle(resultObject,isSuccessed);
    }];
}
@end
