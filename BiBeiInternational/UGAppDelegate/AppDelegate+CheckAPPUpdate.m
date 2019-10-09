//
//  AppDelegate+CheckAPPUpdate.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate+CheckAPPUpdate.h"
#import "UGCheckReleaseVersionApi.h"

@implementation AppDelegate (CheckAPPUpdate)

#pragma mark -检测版本更新
-(void)checkUpdate{
    UGCheckReleaseVersionApi *api = [UGCheckReleaseVersionApi new];
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object) {
            UGCheckReleaseVersionModel *model = [UGCheckReleaseVersionModel mj_objectWithKeyValues:object];
            [self compareVersion:model];
        }
    }];
}

-(void)compareVersion:(UGCheckReleaseVersionModel *)model{
//    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isUpdateClick"];
    
    if (model.needToUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"发现更新" object:nil];
        if (!model.forceToUpdate) {
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:[NSString stringWithFormat:@"发现新版本(v %@)",model.version] message:model.remark cancle:@"取消" others:@[@"更新"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                
//                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isUpdateClick"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UGAnnouncementPopViewButtonClick" object:nil];
                
                if (buttonIndex == 1 && ! UG_CheckStrIsEmpty(model.downloadUrl)) {
                    [UG_MethodsTool openScheme:model.downloadUrl];
                }
            }];
        }else{
            NSString *str = [NSString stringWithFormat:@"%@  \n\n%@",model.remark,@"提示：由于版本过旧请更新应用，否则将无法继续使用"];
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:[NSString stringWithFormat:@"发现新版本(v %@)",model.version] message:str cancle:nil others:@[@"更新"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                if (buttonIndex == 0 && ! UG_CheckStrIsEmpty(model.downloadUrl)) {
                    [UG_MethodsTool openScheme:model.downloadUrl];
                }
            }];
        }
    }
}

@end
