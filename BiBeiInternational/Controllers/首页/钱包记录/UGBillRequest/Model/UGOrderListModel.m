//
//  UGOrderListModel.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGOrderListModel.h"

@implementation UGOrderListModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"totalAmount"] || [property.name isEqualToString:@"curBalance"] || [property.name isEqualToString:@"fee"] || [property.name isEqualToString:@"amount"] ) {
        if (oldValue == nil) {return @"";}
        if (property.type.typeClass  == [NSString class]) {
            NSString *value = [NSString stringWithFormat:@"%@",oldValue];
            return [value ug_amountFormat];
        }
        return oldValue;
    }
    return oldValue;
}

- (NSString *)showAvatar {
     //其中一方是自己就显示返回对方的头像
    if ([self.showUserName isEqualToString:self.payName]) {
        return self.payAvatar;
    }
    return self.receiptAvatar;
}

- (NSString *)showUserName {
    //其中一方是自己就显示返回对方用名
    if ([self.receiptName isEqualToString:[UGManager shareInstance].hostInfo.userInfoModel.member.username]) {
        return  self.payName;
    }
    return self.receiptName;
}

/**
 客户端自己新增
 
 对方收币地址
 
 @return 对方收币地址
 */
- (NSString *)showAddress {
    //其中一方是自己就显示返回对方的地址
    if ([self.showUserName isEqualToString:self.payName]) {
        return self.payAddress;
    }
    return self.receiptAddress;

}



/*
 
 展示文案处理
 */

- (NSString *)showType {
    if ([self.appText containsString:@"["]) {
        return self.appText;
    }
    if (self.appText.length > 0) {
        return [NSString stringWithFormat:@"[%@]",self.appText];
    }
    return @"";
}



/**
跳转类型
 @return 交易、OTC订单、转收币订单
 */
- (UGOrderListType)orderListType {
    //转收币
    if ([self.forward isEqualToString:@"1"]) {
        return UGOrderListType_Transfer;
    }
    //交易详情
    if ([self.forward isEqualToString:@"2"]) {
        return UGOrderListType_Advertis;
    }
    //OTC
    if ([self.forward isEqualToString:@"3"]) {
        return UGOrderListType_OTC;
    }
    return NSNotFound;
}

- (void)setCreateTime:(NSString *)createTime{
    _createTime = createTime;
    if (createTime && createTime.length>0) {
        NSString *date = [UG_MethodsTool getFriendyWithStartTime:createTime];
        
        NSArray *list = [date componentsSeparatedByString:@" "];
        
        for (int i = 0; i< list.count; i++) {
            if (i==0) {
                self.createDate = list.firstObject;
            }else{
//                self.createNoYear = list.firstObject
            }
        }
    }
}

@end
