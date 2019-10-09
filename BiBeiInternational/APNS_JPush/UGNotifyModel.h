//
//  UGNotifyModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGRemotemessageHandle.h"

NS_ASSUME_NONNULL_BEGIN

@class UGNotifyRowsModel;

@interface UGNotifyModel : UGBaseModel

@property(nonatomic,copy)NSString *ID;//消息id
@property(nonatomic,copy)NSString *title;//标题
@property(nonatomic,copy)NSString *alert;//弹框显示的内容
@property(nonatomic,copy)NSString *receiver;//接受者
@property(nonatomic,copy)NSString *sendNo;//返回的数据
@property(nonatomic,copy)NSString *jPushMsgId;//保送的编号
@property(nonatomic,copy)NSString *status;//消息的状态
@property(nonatomic,strong)id data;//推送的内容
@property(nonatomic,copy)NSString *createTime;//创建的时间


/**
 订单消息处理情况
 1 已处理
 0 未处理
 */
@property (nonatomic,assign) BOOL deal;


/**
 OTC通知消息：OTC_INFORM_INFO
 转账：BALANCE_CHANGE_INFO
 OTC：OTC_CHANGE_INFO
 */
@property(nonatomic,copy)NSString *messageType;//消息的类型


/**
 系统：SYSTEM_CHANGE_INFO
 
 动账：DYNAMIC_CHANGE_INFO
 
 通知：INFORM_INFO
 
 聊天：CHAT_INFO
 */
@property(nonatomic,copy)NSString *parentMessageType;//父类消息的类型
@property(nonatomic,copy)NSString *errorMessage;//错误的消息
@end

@interface UGNotifySuperModel : UGBaseModel
@property(nonatomic,copy)NSArray <UGNotifyModel *>*rows;//当前页的数据
@property(nonatomic,assign)NSInteger systemNoNum;//系统未读消息数
@property(nonatomic,assign)NSInteger balanceNoNum;//动账未读消息数
@property(nonatomic,assign)NSInteger informNoNum;//通知未读消息数
@end

NS_ASSUME_NONNULL_END
