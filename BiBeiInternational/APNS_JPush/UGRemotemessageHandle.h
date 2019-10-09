//
//  HFRemotemessageManager.h
//  HappyFishing_iPhone
//
//  Created by gL on 2017/2/16.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import "UGBaseModel.h"

@class UGBaseNotiyMessage;

@interface UGNotiyMessageFactory : UGBaseModel
/**
 *****父类消息 parentMessageType
 * 系统：SYSTEM_CHANGE_INFO
 * 动账：DYNAMIC_CHANGE_INFO
 * 通知消息：INFORM_INFO
 * 聊天：CHAT_INFO
 
 *****子类消息 messageType
 * 转账：BALANCE_CHANGE_INFO
 * OTC：OTC_CHANGE_INFO
 */
@property (nonatomic, strong) NSString *messageType;//消息类型
@property (nonatomic, strong) NSString *parentMessageType;//父消息类型
@property (nonatomic, strong) NSString *data;//模型数据
@property (nonatomic,strong) NSString *createTime;//创建时间
@property (nonatomic,strong) NSString *receiver;//消息接收方
@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,strong) NSString *_j_msgid;//消息ID
@property (nonatomic,strong) NSString *ID;//消息ID

- (UGBaseNotiyMessage *)getNotify;

@end

@interface UGBaseNotiyMessage : UGBaseModel

@property (nonatomic,strong) NSString *ID;//消息ID
@property (nonatomic,strong) NSString *_j_msgid;//消息ID

@end

#pragma mark - 转收币
@interface UGTransferModel : UGBaseNotiyMessage
@property(nonatomic,copy)NSString *owner;//自己
@property(nonatomic,copy)NSString *customer;//交易的对象
@property(nonatomic,copy)NSString *amount;//交易的金额
@property(nonatomic,copy)NSString *orderSn;//orderSn = c181120201126484831488   订单号
@property(nonatomic,copy)NSString *orderType;//订单的类型
@property (nonatomic,strong) NSString *createTime;//创建时间
@end


#pragma mark - OTC 消息

@interface UGOTCOrderMeeageModel : UGBaseNotiyMessage

/**
 交易类型
 */
@property(nonatomic,copy)NSString *advertiseType;


/**
 副标题：OTC：已完成、已取消 广告：已下架、已上架
 */
@property(nonatomic,copy)NSString *subTitle;

/**
 交易ID
 */
@property(nonatomic,copy)NSString *advertiseId;

/**
 订单号
 */
@property(nonatomic,copy)NSString *orderSn;

/**
 订单状态
 */
@property(nonatomic,copy)NSString *orderStatus;


/**
 交易账号
 */
@property(nonatomic,copy)NSString *others;

/**
 创建消息的时间
 */
@property(nonatomic,copy)NSString *createTime;

/**
币种缩写
 */
@property(nonatomic,copy)NSString *coinUnit;


/**
 消息的类型
 交易：OTC_ADVERTISE_MSG
 订单：OTC_ORDER_MSG
 */
@property(nonatomic,copy)NSString *otcMessageType;


/**
 手续费
 */
@property(nonatomic, copy) NSString *commission;


/**
 交易的金额
 */
@property(nonatomic,copy)NSString *amount;


/**
 总额 = 成交量+手续
 */
@property(nonatomic,copy)NSString *total;

/**
 为0 就是交易金额 不为0就为交易返还
 */
@property(nonatomic,copy)NSString *restitutionAmount;

/**
 订单状态转换成中文
 0 已取消
 1 未付款
 2 已付款
 3 已完成
 4 申诉中
 @return 已取消 、未付款、已付款、已完成、申诉中
 */
- (NSString *)statusConvertToString;


@end


#pragma mark - 系统消息
@interface UGJpushSystemModel : UGBaseNotiyMessage

/**
 文本内容
 */
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createTime;
//暂时是只有 “系统消息”
@property(nonatomic,copy)NSString *messageType;
@property(nonatomic,copy)NSString *title;

@end

#pragma mark - 通知消息
@interface UGJpushNotifyModel : UGBaseNotiyMessage

@property(nonatomic,copy)NSString *coinUnit;//币种缩写
@property(nonatomic,copy)NSString *advertiseId;//交易的ID
@property(nonatomic,copy)NSString *amount;//交易的金额
@property(nonatomic,copy)NSString *orderSn;//orderSn = c181120201126484831488   订单号
@property(nonatomic,copy)NSString *others;//对方的用户名
@property (nonatomic,strong) NSString *createTime;//创建时间
@property (nonatomic,strong) NSString *avatar;//对方头像
@property (nonatomic,strong) NSString *otcMessageType;//OTC消息的类型
@property (nonatomic,strong) NSString *commission;//手续费

/**
 订单状态
 */
@property(nonatomic,copy)NSString *orderStatus;

@property(nonatomic,copy)NSString *orderType;

@property(nonatomic,copy)NSString *advertiseType;


/**
 OTC-出售
 我的交易-购买
 我的交易-出售
 */
@property(nonatomic,copy)NSString *informType;


/**
 提示文案
 */
@property(nonatomic,copy)NSString *informAction;

@end
 
#pragma mark - 动账消息：系统冻结返还UGSysFreezeResultModel
@interface UGSysFreezeResultModel : UGBaseNotiyMessage

@property(nonatomic,copy)NSString *amount;

@property(nonatomic,copy)NSString *balance;

@property(nonatomic,copy)NSString *coinUnit;

@property(nonatomic,copy)NSString *createTime;

@property(nonatomic,copy)NSString *resultAmount;

@property(nonatomic,copy)NSString *total;

@property(nonatomic,copy)NSString *userName;

@end
