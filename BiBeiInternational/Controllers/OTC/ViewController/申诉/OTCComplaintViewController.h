//
//  OTCComplaintViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"
#import "UGOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCComplaintViewController : UGTableViewController

@property (nonatomic, strong) NSString *orderSn;
@property (nonatomic, assign)  BOOL reApeal;  //是否带申诉信息过来
@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型   重新申诉需要用到
@property (nonatomic, assign)  BOOL reSubmit;  // 重新申诉
@end

NS_ASSUME_NONNULL_END
