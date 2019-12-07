//
//  UGBaseNotifyListVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseNotifyListVC.h"
#import "UGNotifyListApi.h"
#import "UGNotifyModel.h"
#import "UGRemotemessageHandle.h"

@implementation UGBaseNotifyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self headerBeginRefresh];
}

- (void)viewWillAppear:(BOOL)animated{[super viewWillAppear:animated];
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x333333), NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}


#pragma mark - Request

-(UGBaseRequest *)getRequestApiAppend:(BOOL)append{
    UGNotifyListApi *api = [UGNotifyListApi new];
    api.currentPage = self.minseq;
    UGRequestMessageType messageType = [self requestMessageType];
    switch (messageType) {
        case UGRequestMessageType_SYSTEM:
            api.parentMessageType = @"SYSTEM_CHANGE_INFO";
            break;
        case UGRequestMessageType_INFORM:
            api.parentMessageType = @"INFORM_INFO";

            break;
        case UGRequestMessageType_DYNAMIC:
            api.parentMessageType = @"DYNAMIC_CHANGE_INFO";

            break;
        case UGRequestMessageType_CHAT:
            api.parentMessageType = @"CHAT_INFO";
            break;
        default:
            break;
    }
    return api;
}


- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    if (object[@"rows"]) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[UGNotifyModel mj_objectArrayWithKeyValuesArray:object[@"rows"]]];
        [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UGNotifyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.messageType isEqualToString:@"BALANCE_CHANGE_INFO"]) {
                //转账
                model.data  = [UGTransferModel mj_objectWithKeyValues:model.data];
                
            }else if([model.messageType isEqualToString:@"OTC_CHANGE_INFO"]){
                //OTC
                model.data  = [UGOTCOrderMeeageModel mj_objectWithKeyValues:model.data];
                
            } else if ([model.messageType isEqualToString:@"OTC_INFORM_INFO"] || [model.messageType isEqualToString:@"APPEAL_CANCEL_INFO"] || [model.messageType isEqualToString:@"APPEAL_RELEASE_INFO"]|| [model.messageType isEqualToString:@"OTC_ORDER_TAKING_INFO"]) {
                //通知消息
                model.data  = [UGJpushNotifyModel mj_objectWithKeyValues:model.data];
                
            } else if ([model.messageType isEqualToString:@"APPEAL_NOTBAN_INFO"] || [model.messageType isEqualToString:@"APPEAL_FORBID_INFO"] || [model.messageType isEqualToString:@"APP_AUTH_INFO"]) {
                //系统消息
                model.data  = [UGJpushSystemModel mj_objectWithKeyValues:model.data];
            }
            else if ([model.messageType isEqualToString:@"SYS_FREEZE_RESULT"])
            {
                //新增动账消息内容:系统冻结返还
                model.data = [UGSysFreezeResultModel mj_objectWithKeyValues:model.data];
            }
            else
            {
                //匹配不到该类型直接移除数据，避免后面操作数据出问题
                [array removeObject:model];
            }
            
        }];
        return array;
    }
    return nil;
}

#pragma mark - Public Method

- (UGRequestMessageType)requestMessageType {
    return NSNotFound;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}




@end
