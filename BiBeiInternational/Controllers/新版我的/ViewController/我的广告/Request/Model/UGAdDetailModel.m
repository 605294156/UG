//
//  UGAdDetailModel.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdDetailModel.h"

@implementation UGAdDetailModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
     return @{
              @"ID":@"id",
              @"isAuto":@"auto"
              };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"order" : [UGAdDetailListModel class]
             };
}

-(void)replaceAdModel{
    UGOTCAdModel *model = [UGOTCAdModel new];
    model.ID = self.ID;
    model.advertiseType = self.advertiseType;
    model.remainAmount = self.remainAmount;
    model.price = self.price;
    model.maxLimit = self.maxLimit;
    model.minLimit = self.minLimit;
    model.username = self.username;
    model.avatar = self.memberAvatar;
    model.number = self.number;
    model.remark = self.remark;
    model.coinId = self.coinId;
    model.status = self.status;
    model.coinName = @"UG";
    model.payMode = self.payMode;

    self.adModel = model;
}

@end

@implementation UGAdDetailListModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
     return @{
              @"ID":@"id"
              };
}

-(NSString *)statusStr{
    if ([self.status isEqualToString:@"0"]) {
        return @"已取消";
    }else if ([self.status isEqualToString:@"1"]){
        return @"未付款";
    }else if ([self.status isEqualToString:@"2"]){
        return @"已付款";
    }else if ([self.status isEqualToString:@"3"]){
        return @"已完成 ";
    }else if ([self.status isEqualToString:@"4"]){
        return @"申诉中";
    }
    return @"";
}

- (NSString *)stautsConvertToImageStr{
    NSString *string = @"";
    if ([self.status isEqualToString:@"0"]) {
        string = @"account_cancel";
    } else if (([self.status isEqualToString:@"1"])) {
        string = @"account_nopay";
    } else if (([self.status isEqualToString:@"2"])) {
        string = @"account_paid";
    } else if (([self.status isEqualToString:@"3"])) {
        string = @"account_done";
    } else if (([self.status isEqualToString:@"4"])) {
        string = @"account_appeal";
    }
    return string;
}

@end
