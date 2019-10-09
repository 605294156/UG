//
//  UGCheckReleaseVersionApi.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 检测版本更新
 */
@interface UGCheckReleaseVersionApi : UGBaseRequest

@end

@interface UGCheckReleaseVersionModel : UGBaseModel
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *downloadUrl;// 下载地址
@property(nonatomic,copy)NSString *platform;// 平台  0:安卓  1:IOS
@property(nonatomic,copy)NSString *publishTime;// 发布时间
@property(nonatomic,copy)NSString *remark;// 更新显示内容
@property(nonatomic,copy)NSString *version;// 当前最新版本号
@property(nonatomic,copy)NSString *lastForceVersion;// 最一个需要强制更新的版本号
@property(nonatomic,copy)NSString *force;//最新版本是否强制更新
@property(nonatomic,assign)BOOL needToUpdate;//当前APP版本是否可以更新
@property(nonatomic,assign)BOOL forceToUpdate;// 当前版本是否
@end

NS_ASSUME_NONNULL_END
