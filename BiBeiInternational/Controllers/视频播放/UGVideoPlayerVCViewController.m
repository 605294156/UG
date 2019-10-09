//
//  UGVideoPlayerVCViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2019/5/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGVideoPlayerVCViewController.h"
#import "SJVideoPlayer.h"
#import <Masonry/Masonry.h>
#import "SJVCRotationManager.h"


@interface UGVideoPlayerVCViewController ()
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) SJVCRotationManager *vcRotationManager;

@end

@implementation UGVideoPlayerVCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBarHidden = YES;
    
    //自定义播放器的颜色，使其更符合app的风格
    SJVideoPlayer.update(^(SJVideoPlayerSettings * _Nonnull commonSettings) {
        
        commonSettings.progress_traceColor = UG_MainColor;
        commonSettings.more_traceColor = UG_MainColor;
    });
    
    // create a player of the default type
    _player = [SJVideoPlayer player];
    [self.view addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        else make.top.offset(0);
        make.leading.trailing.offset(0);
        make.height.equalTo(self->_player.view.mas_width).multipliedBy(9 / 16.0f);
    }];
    
    __weak typeof(self) _self = self;
    _player.clickedBackEvent = ^(SJVideoPlayer * _Nonnull player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:_ugVideoUrl]];
    
    _player.URLAsset.title = @"";
   
    _player.hideBackButtonWhenOrientationIsPortrait = NO;
    
    [self.player rotate:SJOrientation_LandscapeLeft animated:NO];
    //禁用播放器的自动旋转;
    self.player.disableAutoRotation = YES;
    
    _player.pausedToKeepAppearState = YES;
    
    //移除全屏切换的按钮
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_FullBtn];

    //移除返回锁定按钮
    [_player.defaultEdgeControlLayer.leftAdapter removeItemForTag:SJEdgeControlLayerLeftItem_Lock];
    
    //修改完成后需要reload各个层，否则会崩溃
    [_player.defaultEdgeControlLayer.leftAdapter reload];

    [_player.defaultEdgeControlLayer.bottomAdapter reload];

    [_player.defaultEdgeControlLayer.topAdapter reload];

    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];

    [button setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];

    [button addTarget:self action:@selector(VideoPlayerPopBack) forControlEvents:UIControlEventTouchUpInside];
    
    SJEdgeControlButtonItem *item = [SJEdgeControlButtonItem frameLayoutWithCustomView:button tag:201910086];
   
    [_player.defaultEdgeControlLayer.topAdapter addItem:item];
    
    [_player.defaultEdgeControlLayer.topAdapter reload];

    //将自定义的返回按钮与原始返回按钮交换位置后，再将原始按钮移除
    [_player.defaultEdgeControlLayer.topAdapter exchangeItemForTag:SJEdgeControlLayerTopItem_Back withItemForTag:201910086];
    
    //移除返回按钮，需要自定义，否则存在大小屏切换的问题
    [_player.defaultEdgeControlLayer.topAdapter removeItemForTag:SJEdgeControlLayerTopItem_Back];
    
    [_player.defaultEdgeControlLayer.topAdapter reload];
    
}

-(void)VideoPlayerPopBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}


/*
 
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
