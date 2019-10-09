//
//  UGOrderDeatilModel.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGPayInfoModel.h"
#import "UGAppealModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOrderDetailModel : UGBaseModel

@property (nonatomic, copy) NSString * amount;//
//@property (nonatomic, copy) NSString * appealImageUrls;
//@property (nonatomic, copy) NSString * appealMobile;
//@property (nonatomic, copy) NSString * appealRealName;
//@property (nonatomic, copy) NSString * appealRemark;


/**
 申诉方用户名非 申诉填写的姓名
 */
//@property (nonatomic, copy) NSString * appealName;

/**
 手续费
 */
@property (nonatomic, copy) NSString * commission;

/**
 订单创建时间
 */
@property (nonatomic, copy) NSString * createTime;

/**
 订单完成时间
 */
@property (nonatomic, copy) NSString *releaseTime;

/**
 订单取消完成时间
 */
@property (nonatomic, copy) NSString *cancelTime;

/**
 对方头像
 */
@property (nonatomic, copy) NSString * hisAvatar;
@property (nonatomic, copy) NSString * hisId;  //目前没有 聊天需要用到 需要用到
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * myId;
@property (nonatomic, copy) NSString * orderSn;

/**
 对方用户名
 */
@property (nonatomic, copy) NSString * otherSide;
@property (nonatomic, strong) UGPayInfoModel * payInfo;
@property (nonatomic, copy) NSString * payTime;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * referenceNumber;
@property (nonatomic, copy) NSString * remark;

/**
 接收方信息
 */
@property (nonatomic, strong) UGPayInfoModel *reveiveInfo;

/**
 订单状态
 0 已取消
 1 未付款
 2 已付款
 3 已完成
 4 申诉中
 */

@property (nonatomic, copy) NSString * status;


/**
 后台返回的分钟
 */
@property (nonatomic, copy) NSString * timeLimit;

/**
 0 购买 1出售
 */
@property (nonatomic, copy) NSString * type;


/**
 币种名称缩写 例如：ETH 、BTC、UG
 */
@property (nonatomic, copy) NSString * unit;

/**
 type 转换成 购买、出售
 0 购买 1出售
 @return 购买 or 出售
 */
- (NSString *)typeConvertToString;

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

- (NSString *)statusConvertToImageStr;


/**
 卖家or买家支持的支付方式列表

 @return @[alipay,wechatPay,bankInfo]
 */
- (NSArray *)payModeList;


//---------------------新增加的---------
/**
 payModel
 */
@property (nonatomic, copy) NSString * payModel;

/**
 
 */
@property (nonatomic, copy) NSString * orderPayMode;

/**
 申诉信息
 */
@property (nonatomic, strong) UGAppealModel * appeal;

/**
 广告类型 参见广告
 */
@property (nonatomic, copy) NSString * advertiseType;

/**
 申诉等待时间
 */
@property (nonatomic, copy) NSString * appealLimitTime;

/**
sysBuy   0  用户购买  1 系统回购
 */
@property (nonatomic, copy) NSString * sysBuy;

/**
isAppealSuccess   是否申诉成功 0失败 1 成功
 */
@property(nonatomic,copy)NSString *isAppealSuccess;

/**
 appealResult   申诉结果
 */
@property(nonatomic,copy)NSString *appealResult;

/**
 dealRestitution   订单返还
 */
@property (nonatomic, copy) NSString * dealRestitution;

@property (nonatomic, strong) UGAlipayModel * alipay;
@property (nonatomic, strong) UGBankInfoModel * bankInfo;
@property (nonatomic, strong) UGWechatPayModel * wechatPay;
@property (nonatomic, strong) UGUnionModel * unionPay;


@end

NS_ASSUME_NONNULL_END
