//
//  UGBaseViewController.h
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+expand.h"
#import "UITableView+Expand.h"
#import "UIViewController+Order.h"
#import "UGTouchIDTool.h"
#import "UGOrderWaitingModel.h"
#import "UIViewController+Utils.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBaseViewController : UIViewController

/**
 是否隐藏 NavigationBar，在UGtNavController处理了。
 在viewDidLoad设置此属性即可，不需要其他操作
 */
@property (nonatomic, assign, getter=isNavigationBarHidden) BOOL navigationBarHidden;

/**
 导航栏背景色，默认主色调。在UGBaseViewController和UGtNavController处理了
 个别页面单独设在viewDidLoad设置此属性即可，不需要其他操作
 */
@property (nonatomic, strong) UIColor *navigationBarColor;

-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock;

-(void)addAlterViewWithTitle:(NSString *)title withMessage:(NSString *)message withCertainBtnTitle:(NSString *)certainBtnTilte withCancelBtnTitle:(NSString *)cancelBtnTitle withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock;

/**
 APP语言切换
 子类重写该方法在里面设置控件的title
 */
- (void)languageChange;

/**
 若用户未登录，则显示登录界面
 */
-(void)showLoginViewController;

/**
 弹出拍照、从相册选取
 @param maxCount 运行选取的最大张数
 @param handle 选择或拍照后的图片列表
 @param isPoto 是否在相册选择图片 默认是
 */
- (void)showTakePhotoChooseWithMaxCount:(NSInteger)maxCount WithPoto:(BOOL)isPoto handle:(void(^)(NSArray <UIImage *>*imageList))handle;

/**
 购买金额、出售金额需要实名、高级认证
 内部已经处理跳转
 
 @param moneyString 购买、出售金额
 @return 是否需要
 */
- (BOOL)checkMoneyNeedToValidation:(NSString *)moneyString;

#pragma mark - UIViewEmptyView or UIViewErrorView

/**
 数据没回来之前挡住self.view
 */
- (void)showEmptyView;

/**
 UIView添加加载数据出错占位图，默认整个self.view

 @param desc 错误信息
 @param reloadHandle 重新获取数据回调
 */
- (void)showErrorEmptyView:(NSString *)desc clickRelodRequestHandle:(void(^)(void))reloadHandle;

/**
 * 人脸识别调起   View
 */
-(void)verifyTouchOrFaceID:(void(^)(UGTouchIDState state, NSError *error))handle;

/**
 * web页跳转
 */
-(void)gotoWebView:(NSString *)title htmlUrl:(NSString *)url;

/**
 * 人脸识别提示
 */
-(void)showFaceAlterView:(NSString *)message;

/**
 * 去到放币或者付款页面
 */
-(void)gotoDetail:(UGOrderWaitingModel *)model;

/**
 * 判断有几个必须强制的待办事项
 */
-(int)forceNum:(NSArray *)orderWaitingArr;

/**
 * 查看是否被禁用
 */
-(BOOL)hasForbidden;

/**
 * 提示语更新
 */
-(NSString *)upDataMessage:(NSString *)dickey  WithMessage:(NSString *)msg;

/**
 * 是否是承兑商
 */
-(BOOL)isCardVip;

/**
 * 播放视频
 */
-(void)playVideo;

/**
 * 根据地址播放视频
 */
-(void)playVideoWithUrl:(NSString *)videoUrl;

/**
 * 检测是否需要去绑定银行卡
 */
- (BOOL)checkHadGotoBankBinding;

/**
 * 查看实名认证
 */
-(BOOL)gotoRealNameAuthentication;

//获取钱包信息接口
- (void)getWalletData:(UGRequestCompletionBlock)completionBlock;

//检测当前银行卡是否到达限额弹框
-(void)showBindingLimit:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
