//
//  UGGenerateGoogleKeyModel.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGGenerateGoogleKeyModel.h"

static UGGenerateGoogleKeyModel *model = nil;

@implementation UGGenerateGoogleKeyModel
/*  通过初始化将、谷歌验证（目前只有一个，暂且这样做）并保存在本地(单利模式)   */
+(instancetype)getModelWithDic:(UGGenerateGoogleKeyModel *)model{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UGGenerateGoogleKeyModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
    return model;
}

/*  获取用户谷歌验证码信息*/
+(instancetype)shareUGGoogleKeyModel{
    
    if (model == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"UGGenerateGoogleKeyModel"];
        if (data) {
            model =[NSKeyedUnarchiver unarchiveObjectWithData:data];
            return model;
        }
    }
    return model;
}

/*  保存当前UGGenerateGoogleKeyModel*/
+(void)saveGoogleKeyModel:(UGGenerateGoogleKeyModel *)model{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"UGGenerateGoogleKeyModel"];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.link forKey:@"link"];
    [aCoder encodeObject:self.secret forKey:@"secret"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.link = [aDecoder decodeObjectForKey:@"link"];
        self.secret = [aDecoder decodeObjectForKey:@"secret"];
    }
    return self;
}
@end
