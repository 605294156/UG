//
//  UGOrderListModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//


typedef NS_ENUM(NSInteger, UGOrderListType) {
    UGOrderListType_Transfer = 0,//转收币
    UGOrderListType_OTC,//OTC
    UGOrderListType_Advertis,//交易
};


#import "UGBaseModel.h"
/**
 UG钱包记录模型
 */
@interface UGOrderListModel : UGBaseModel


/**
 流水中的交易金额
 */
@property (nonatomic, copy) NSString *  amount;


/**
 app端展示的类型
 */
@property (nonatomic, copy) NSString *  appClass;


/**
 业务id
 */
@property (nonatomic, copy) NSString *  businessId;


/**
 创建时间
 */
@property (nonatomic, copy) NSString * createTime;

/**
 当前余额
 */
@property (nonatomic, copy) NSString *  curBalance;

/**
 流水中费用
 */
@property (nonatomic, copy) NSString *  fee;

/**
 订单号
 */
@property (nonatomic, copy) NSString * orderSn;

/**
 付款UG钱包地址
 */
@property (nonatomic, copy) NSString * payAddress;


/**
 付款方头像
 */
@property (nonatomic, copy) NSString * payAvatar;


/**
 付款方用户名
 */
@property (nonatomic, copy) NSString * payName;

/**
 收款UG钱包地址
 */
@property (nonatomic, copy) NSString * receiptAddress;

/**
 收款方头像
 */
@property (nonatomic, copy) NSString * receiptAvatar;

/**
 收款方用户名
 */
@property (nonatomic, copy) NSString * receiptName;


/**
 备注 、附言
 */
@property (nonatomic, copy) NSString * remark;

/**
 总额
 */
@property (nonatomic, copy) NSString *  totalAmount;


/**
  跳转类型 1.转币详情 2.交易详情 3.订单详情
 */
@property (nonatomic, copy) NSString *  forward;


/**
 是否是收入 0否 1是
 */
@property (nonatomic, copy) NSString * isIncome;



/**
  展示文案
 
 冻结返还
 
 */
@property (nonatomic, copy) NSString * appText;

/**
 客户端自己新增
 用于显示。任何情况都是返回对方的头像
 
 @return 对方头像
 */
-(NSString *)showAvatar;


/**
 客户端自己新增
 
 用于显示。任何情况都是返回对方的用户名
 
 @return 对方用户名
 */
-(NSString *)showUserName;

/**
 客户端自己新增
 
 对方收币地址
 
 @return 对方收币地址
 */
- (NSString *)showAddress;


/*
 客户端自己新增
 展示文案处理
 */

- (NSString *)showType;


/**
 客户端自己新增
跳转类型
 */
- (UGOrderListType)orderListType;

@end
