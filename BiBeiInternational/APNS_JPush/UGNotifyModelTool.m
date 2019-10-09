//
//  HFPostTagItemTool.m
//  HappyFishing_iPhone
//
//  Created by gL on 2017/11/28.
//  Copyright © 2017年 XingYunLeDongCo.Ltd. All rights reserved.
//

#import "UGNotifyModelTool.h"

@implementation UGNotifyModelTool

/**
 保存当前收到的消息
 */
+ (void)saveNotiyMessage:(UGBaseNotiyMessage *)notifyMessage {

    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    
    NSMutableArray *commonlyUsedList;
    if (data) {
        commonlyUsedList = [[NSMutableArray alloc] initWithArray:data];
    } else {
        commonlyUsedList = [NSMutableArray new];
    }
    if (notifyMessage == nil) {return;}
    
    BOOL isTrnsfer = NO;//动账  包含：转收币  OTC  交易
    BOOL isSystemMessage =NO;//系统
    BOOL isChatMessage = NO;
    //动账消息
    if ([notifyMessage isKindOfClass:[UGTransferModel class]] || ([notifyMessage isKindOfClass:[UGOTCOrderMeeageModel class]])) {
        isTrnsfer = YES;
    }
//    //系统消息
//    if ([notifyMessage isKindOfClass:[UGTransferModel class]]) {
//        isTrnsfer = YES;
//    }
//    //聊天消息
//    if ([notifyMessage isKindOfClass:[UGTransferModel class]]) {
//        isChatMessage = YES;
//    }
    if (isChatMessage)
        //聊天消息
        [commonlyUsedList addObject:notifyMessage];
    else{
        //动账、系统消息
         if(commonlyUsedList.count <= 0){
             
             UGJPushMesageModel *listModel = [UGJPushMesageModel new];
             listModel.title =isTrnsfer ? @"动账信息" : @"系统消息";
             listModel.messageType = isTrnsfer ? ACCOUNT_CHANGE_INFO : SYSTEM_CHANGE_INFO;
             
             if (isTrnsfer) {//动账
                 //转收币
                 if ([notifyMessage isKindOfClass:[UGTransferModel class]]) {
                     UGTransferModel *trans = (UGTransferModel *)notifyMessage;
                     listModel.content = [trans.orderType isEqualToString:@"SUB_TYPE_RECEIPT"]? [NSString stringWithFormat:@"您当前收币入账 +%@ UG",trans.amount] : [NSString stringWithFormat:@"您当前转币扣款 -%@ UG",trans.amount];
                     listModel.time = trans.createTime;
                     NSMutableArray *arrlist = [NSMutableArray new];
                     [arrlist addObject:trans];
                     listModel.list = arrlist;
                     [commonlyUsedList addObject:listModel];
                     //OTC、交易
                 } else if ([notifyMessage isKindOfClass:[UGOTCOrderMeeageModel class]]) {
                     UGOTCOrderMeeageModel *messgeModel = (UGOTCOrderMeeageModel *)notifyMessage;
#warning need to fix
                     listModel.content = @"测试收到一条OTC消息";
                     listModel.time = messgeModel.createTime;
                     NSMutableArray *arrlist = [NSMutableArray new];
                     [arrlist addObject:messgeModel];
                     listModel.list = arrlist;
                     [commonlyUsedList addObject:listModel];
                 }

     //            //交易
     //            else if([notifyMessage isKindOfClass:[UGTransferModel class]]){
     //
     //            }
             }else if(isSystemMessage){//系统
                 
             }
         }else{
             
             [self findeACCOUNT_CHANGE_INFOWithArray:commonlyUsedList complite:^(BOOL find, NSInteger index) {
                 if (find) {
                     UGJPushMesageModel *modle = commonlyUsedList[index];
                     [modle.list addObject:notifyMessage];
                 } else {
                     UGJPushMesageModel *listModel = [UGJPushMesageModel new];
                     listModel.title =isTrnsfer ? @"动账信息" : @"系统消息";
                     listModel.messageType = isTrnsfer ? ACCOUNT_CHANGE_INFO : SYSTEM_CHANGE_INFO;
                     UGTransferModel *trans = (UGTransferModel *)notifyMessage;
                     listModel.content = [trans.orderType isEqualToString:@"SUB_TYPE_RECEIPT"]? [NSString stringWithFormat:@"您当前收币入账 +%@ UG",trans.amount] : [NSString stringWithFormat:@"您当前转币扣款 -%@ UG",trans.amount];
                     listModel.time = trans.createTime;
                     NSMutableArray *arrlist = [NSMutableArray new];
                     [arrlist addObject:trans];
                     listModel.list = arrlist;
                     [commonlyUsedList addObject:listModel];
                 }
             }];
             
             
//             NSMutableArray *tempArray = [commonlyUsedList mutableCopy];
//             for (int i = 0 ; i<tempArray.count; i++) {
//                 UGJPushMesageModel *objec = tempArray[i];
//
//                 if(isTrnsfer){
//                     //转收币
//                     if ([notifyMessage isKindOfClass:[UGTransferModel class]]) {
//                         UGTransferModel *model = (UGTransferModel *)notifyMessage;
//                         if(objec.messageType == ACCOUNT_CHANGE_INFO){
//                             objec.content = [model.orderType isEqualToString:@"SUB_TYPE_RECEIPT"]? [NSString stringWithFormat:@"您当前收币入账 +%@ UG",model.amount] : [NSString stringWithFormat:@"您当前转币扣款 -%@ UG",model.amount];
//                             objec.time = model.createTime;
//                             [objec.list insertObject:model atIndex:0];
//                             [commonlyUsedList replaceObjectAtIndex:i withObject:objec];
//                         }else
//                         {
//                             UGJPushMesageModel *jpushModel = [UGJPushMesageModel new];
//                             jpushModel.title = @"动账信息";
//                             jpushModel.messageType = ACCOUNT_CHANGE_INFO;
//                             jpushModel.content = [model.orderType isEqualToString:@"SUB_TYPE_RECEIPT"]? [NSString stringWithFormat:@"您当前收币入账 +%@ UG",model.amount] : [NSString stringWithFormat:@"您当前转币扣款 -%@ UG",model.amount];
//                             jpushModel.time = model.createTime;
//                             jpushModel.list = [NSMutableArray new];
//                             [jpushModel.list addObject:model];
//                             [commonlyUsedList addObject:jpushModel];
//                         }
//                     }
         //            //otc
         //            else if([notifyMessage isKindOfClass:[UGTransferModel class]]){
         //
         //            }
         //            //交易
         //            else if([notifyMessage isKindOfClass:[UGTransferModel class]]){
         //
         //            }
//                 }else if(isSystemMessage){
//
//                 }
//             }
         }
    }
    //归档
    [NSKeyedArchiver archiveRootObject:commonlyUsedList toFile:[self filePath]];
}

+ (void)findeACCOUNT_CHANGE_INFOWithArray:(NSArray *)array complite:(void(^)(BOOL find, NSInteger index))complite{
   __block BOOL isFind = NO;
   __block NSInteger index = NSNotFound;
    [array enumerateObjectsUsingBlock:^(UGJPushMesageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.messageType == ACCOUNT_CHANGE_INFO) {
            isFind = YES;
            index = idx;
            *stop = YES;
        }
    }];

    if (complite) {
        complite(isFind,index);
    }
}


+ (NSString *)filePath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:@"UGBaseNotiyMessage.arch"];
    return path;
}

/**
 获取当前收到的消息
 */
+ (NSArray <UGJPushMesageModel *>*)messageList {

    NSMutableArray *commonlyUsedList;

    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];

    if (data) {
        commonlyUsedList = [[NSMutableArray alloc] initWithArray:data];
    } else {
        commonlyUsedList= [NSMutableArray new];
    }
    return commonlyUsedList;
}

///**
// 这个标签是否存在后台给的标签列表中
// */
//+ (BOOL)canFindeThisPostTagItem:(HFPostTagItem *)postTagItem dataSource:(NSArray <HFPostTagItem *>*)postTagItemList {
//    //后台给的所有标签列表
//    NSMutableArray <HFPostTagItem *>*allPostTagItemList = [[NSMutableArray alloc] initWithArray:postTagItemList];
//
//    for (HFPostTagItem *item in allPostTagItemList) {
//        if (item._id == postTagItem._id ) {
//            return YES;
//        }
//    }
//    return NO;
//}

@end




