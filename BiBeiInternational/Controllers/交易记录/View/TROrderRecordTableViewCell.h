//
//  TROrderRecordTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"
#import "UGOredeModel.h"


typedef NS_ENUM(NSInteger, UGOrderType) {
    UGOrderTypeCancle = 0,//取消交易
    UGOrderTypePay,//去支付
    UGOrderTypeputCoin,//去放币
    UGOrderTypeAppeal,//去申诉
    UGOrderTypeCheckAppeal,//查看申诉结果
    UGOrderTypeAssets,//查看资产
    UGOrderTypeOder,//查看iveup订单
    UGOrderTypeGiveupAppeal,//放弃申诉
};


NS_ASSUME_NONNULL_BEGIN

@interface TROrderRecordTableViewCell : UGBaseTableViewCell

//OTC交易记录
@property (nonatomic, strong) UGOredeModel *orderModel;


/**
 点击底部按钮

 @param oderType 点击操作的目标
 */
@property (nonatomic, copy) void(^clickButtonHandle)(UGOrderType oderType);


@end

NS_ASSUME_NONNULL_END
