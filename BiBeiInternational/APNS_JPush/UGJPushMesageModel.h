//
//  UGJPushMesageModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/21.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"
#import "UGRemotemessageHandle.h"

@interface UGJPushMesageModel : UGBaseModel

@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, assign) MessageType messageType;//类型
@property (nonatomic,strong) NSString *content;//显示内容
@property (nonatomic,strong) NSString *time;//时间
//@property (nonatomic,strong) NSMutableArray <UGTransferModel *>*list;//包含数据;
@property (nonatomic,strong) NSMutableArray *list;//包含数据;

@end
