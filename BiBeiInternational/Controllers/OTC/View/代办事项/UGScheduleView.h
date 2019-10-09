//
//  UGScheduleView.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGOrderWaitingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGScheduleView : UIView
+ (void)initWithArr:(NSMutableArray *)orderArr WithHandle:(void(^)(UGOrderWaitingModel *model))clickHandle WithViewHandle:(void(^)(UGScheduleView *scheduleView))scheduleViewHandle WithCloseHandle:(void(^)( void))closeHandle;
+(void)hidePopView;
@end

NS_ASSUME_NONNULL_END
