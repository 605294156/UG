//
//  UGOredeModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/6.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOredeModel : UGBaseModel

//@property (nonatomic, copy) NSString * advertiseId;
//@property (nonatomic, copy) NSString * advertiseType;
//@property (nonatomic, copy) NSString * aliNo;
//@property (nonatomic, copy) NSString * bank;
//@property (nonatomic, copy) NSString * branch;
//@property (nonatomic, copy) NSString * cancelTime;
//@property (nonatomic, copy) NSString * cardNo;
//@property (nonatomic, copy) NSString * coinId;
@property (nonatomic, copy) NSString * commission;
//@property (nonatomic, copy) NSString * country;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * customerId;
@property (nonatomic, copy) NSString * customerName;
//@property (nonatomic, copy) NSString * customerRealName;
//@property (nonatomic, copy) NSString * ID;
//@property (nonatomic, copy) NSString * maxLimit;
//@property (nonatomic, copy) NSString * memberId;
//@property (nonatomic, copy) NSString * memberName;
//@property (nonatomic, copy) NSString * memberRealName;
//@property (nonatomic, copy) NSString * minLimit;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * number;


/**
 对方头像
 */
@property (nonatomic, copy) NSString * avatar;


//@property (nonatomic, copy) NSString * hisAvatar;

/**
 订单号
 */
@property (nonatomic, copy) NSString * orderSn;
//@property (nonatomic, copy) NSString * payMode;
//@property (nonatomic, copy) NSString * payTime;
//@property (nonatomic, copy) NSString * price;
//@property (nonatomic, copy) NSString * qrCodeUrl;
//@property (nonatomic, copy) NSString * qrWeCodeUrl;
//@property (nonatomic, copy) NSString * referenceNumber;
//@property (nonatomic, copy) NSString * releaseTime;
//@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * status;
//@property (nonatomic, copy) NSString * timeLimit;
//@property (nonatomic, copy) NSString * version;
//@property (nonatomic, copy) NSString * wechat;
@property (nonatomic, copy) NSString * coinName;
@property (nonatomic, copy) NSString * appealStatus;
@property (nonatomic, copy) NSString * initiatorId;  //申诉方Id

/**
  0  买入 1.卖出
 */
@property (nonatomic, copy) NSString * orderType;

/**
 0  登录人发布 1.其他用户发布
 */
@property (nonatomic, copy) NSString * isAdvertiser;


/**
 状态码装换成文字

 @return 未完成、已完成、已取消、申诉中、已付款、未付款
 */
- (NSString *)stautsConvertToString;

/**
 状态码装换成图片
 
 @return 未完成、已完成、已取消、申诉中、已付款、未付款
 */
- (NSString *)stautsConvertToImageStr;



///**
// 订单类型转换成买入卖出
//
// @return 买入、卖出
// */
//- (NSString *)advertiseTypeConvertToString;



/**
 订单类型转换成买入卖出
 
 @return 买入、卖出
 */
- (NSString *)orderTypeConvertToString;



@end

NS_ASSUME_NONNULL_END
