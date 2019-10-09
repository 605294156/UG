//
//  UGBaseNotifyListVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"

typedef NS_ENUM(NSInteger, UGRequestMessageType) {
    UGRequestMessageType_SYSTEM = 0,//系统消息
    UGRequestMessageType_INFORM,//通知消息
    UGRequestMessageType_DYNAMIC,//动账消息 ：交易和OTC
    UGRequestMessageType_CHAT//聊天消息
};

NS_ASSUME_NONNULL_BEGIN

@interface UGBaseNotifyListVC : UGTableViewController




/**
 请求消息列表类型,默认NSNofund

 UGRequestMessageType_SYSTEM = 0,//系统消息
 UGRequestMessageType_INFORM,//通知消息
 UGRequestMessageType_DYNAMIC,//动账消息 ：交易和OTC
 UGRequestMessageType_CHAT//聊天消息

 */
- (UGRequestMessageType)requestMessageType;


@end

NS_ASSUME_NONNULL_END
