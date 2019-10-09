//
//  UGBillDetailModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/3.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
/**
 UG钱包记录详情模型
 */
@interface UGBillDetailModel : UGBaseModel
@property(nonatomic,copy)NSString *otherloginName;//对方账号名
@property(nonatomic,copy)NSString *orderSn;//订单号
@property(nonatomic,copy)NSString *tradeAmount;//交易金额,单位UG
@property(nonatomic,copy)NSString *poundage;//手续费,单位UG
@property(nonatomic,copy)NSString *otherCardNo;//对方UG钱包地址
@property(nonatomic,copy)NSString *createDate;//创建时间
@property(nonatomic,copy)NSString *payState;//0成功，1失败，2支付中
@property(nonatomic,copy)NSString *tradeUgNumber;//交易UG数量
@property(nonatomic,copy)NSString *remark;//备注
@property(nonatomic,copy)NSString *avatar;//头像
@property(nonatomic,copy)NSString *orderType;//类型
@end
