//
//  UGChatTopView.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGPayMethodView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGChatTopView : UIView
//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：9999.00 UG
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：已付款
@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 圆圈view
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY
@property (weak, nonatomic) IBOutlet UILabel *statusTypeLabel;//订单状态 例如：等待卖家放币

+(instancetype)fromXib;
@end

NS_ASSUME_NONNULL_END
