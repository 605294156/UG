#import <UIKit/UIKit.h>
#import "UGBaseModel.h"

@interface UGApplication : UGBaseModel
//后台数据库表创建时间
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * idCard;
@property (nonatomic, copy) NSString * identityCardImgFront;
@property (nonatomic, copy) NSString * identityCardImgInHand;
@property (nonatomic, copy) NSString * identityCardImgReverse;
@property (nonatomic, copy) NSString * memberId;
@property (nonatomic, copy) NSString * realName;

/**
 认证失败原因
 */
@property (nonatomic, copy) NSString * rejectReason;
@property (nonatomic, copy) NSString * type;


/**
 审核通过时间
 */
@property (nonatomic, copy) NSString * updateTime;

/**
 提交审核时间
 */
@property (nonatomic, copy) NSString *committime;

/**
 人脸识别状态 0 未认证  1 已认证
 */
@property (nonatomic, copy) NSString *faceStatus;

/**
 审核状态
 nil == 未提交
 0 == 审核中
 1 == 审核失败
 2 == 审核通过
 */
@property (nonatomic, copy) NSString * auditStatus;

@end
