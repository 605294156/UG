//
//  HFRemotemessageManager.m
//  HappyFishing_iPhone
//
//  Created by gL on 2017/2/16.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import "UGRemotemessageHandle.h"

@implementation UGNotiyMessageFactory

- (UGBaseNotiyMessage *)getNotify {
    
    NSDictionary *messageDict = [UG_MethodsTool dictWithJsonString :self.data];
    BOOL dataNoEmpty = messageDict != nil;
    //动账
    if ([self.parentMessageType isEqualToString:@"DYNAMIC_CHANGE_INFO"]) {
        //转币
        if ([self.messageType isEqualToString:@"BALANCE_CHANGE_INFO"] && dataNoEmpty) {
            UGTransferModel *model =  [UGTransferModel mj_objectWithKeyValues:messageDict];
            model._j_msgid = self._j_msgid;
            model.ID = self.ID;
            return model;
        }
        //OTC
        if ([self.messageType isEqualToString:@"OTC_CHANGE_INFO"] && dataNoEmpty ) {
            UGOTCOrderMeeageModel *model = [UGOTCOrderMeeageModel mj_objectWithKeyValues: messageDict];
            model._j_msgid = self._j_msgid;
            model.ID = self.ID;
            return model;
        }
    }
    //通知
    else if([self.parentMessageType isEqualToString:@"INFORM_INFO"] && dataNoEmpty){
        //OTC通知消息
        if ([self.messageType isEqualToString:@"OTC_INFORM_INFO"] || [self.messageType isEqualToString:@"APPEAL_CANCEL_INFO"] || [self.messageType isEqualToString:@"APPEAL_RELEASE_INFO"] || [self.messageType isEqualToString:@"OTC_ORDER_TAKING_INFO"]) {
            UGJpushNotifyModel *model =  [UGJpushNotifyModel mj_objectWithKeyValues:messageDict];
            model._j_msgid = self._j_msgid;
            model.ID = self.ID;
            return model;
        }
    }
    //系统
    else if([self.parentMessageType isEqualToString:@"SYSTEM_CHANGE_INFO"] && dataNoEmpty){
        UGJpushSystemModel *model =  [UGJpushSystemModel mj_objectWithKeyValues:messageDict];
        model._j_msgid = self._j_msgid;
        model.ID = self.ID;
        return model;
    }
    else if ([self.parentMessageType isEqualToString:@"SYS_FREEZE_RESULT"])
    {
        UGSysFreezeResultModel *model = [UGSysFreezeResultModel mj_objectWithKeyValues:messageDict];
        model._j_msgid = self._j_msgid;
        model.ID = self.ID;
        return model;
    }
    return nil;
}
@end

@implementation UGBaseNotiyMessage

@end

@implementation UGTransferModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {

    if ([property.name isEqualToString:@"amount"]) {
        if (oldValue == nil) {return @"";}
        if (property.type.typeClass  == [NSString class]) {
            NSString *value = [NSString stringWithFormat:@"%@",oldValue];
            return [value ug_amountFormat];
        }
        return oldValue;
    }
    return oldValue;
}
@end

@implementation UGOTCOrderMeeageModel



/**
 订单状态转换成中文
 0 已取消
 1 未付款
 2 已付款
 3 已完成
 4 申诉中
 @return 已取消 、未付款、已付款、已完成、申诉中
 */
- (NSString *)statusConvertToString {
    switch ([self.orderStatus intValue]) {
        case 0:
            return @"已取消";
            break;
        case 1:
            return @"未付款";
            break;
        case 2:
            return @"已付款";
            break;
        case 3:
            return @"已完成";
            break;
        default:
            return @"申诉中";
            break;
    }
    return @"";
}

@end

#pragma mark - 系统消息
@implementation UGJpushSystemModel

@end

#pragma mark - 通知消息
@implementation UGJpushNotifyModel
//
//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
//    if ([property.name isEqualToString:@"deal"]) {
//        if (oldValue == nil) {return @"";}
//        if (property.type.typeClass  == [BOOL class]) {
//            return [oldValue boolValue];
//        }
//        return oldValue;
//    }
//    return oldValue;
//}

@end

#pragma mark - 动账消息：系统冻结返还
@implementation UGSysFreezeResultModel

@end




