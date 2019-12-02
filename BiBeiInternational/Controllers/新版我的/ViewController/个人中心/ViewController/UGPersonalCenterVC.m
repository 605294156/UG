//
//  UGPersonalCenterVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPersonalCenterVC.h"
#import "UGRevisePasswordVC.h"
#import "UGUploadImageRequest.h"
#import "UGReviseAvatarApi.h"


@interface UGPersonalCenterVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) dispatch_queue_t uploatHeadImageQueue;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UIView *phoneInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneViewH;        //电话号码栏高度

//实名认证
@property (weak, nonatomic) IBOutlet UILabel *realNameTitleLab;             //实名认证title
@property (weak, nonatomic) IBOutlet UILabel *realNameDetailLab;            //实名认证详情
@property (weak, nonatomic) IBOutlet UIImageView *realIconImg;              //实名认证icon
@property (weak, nonatomic) IBOutlet UILabel *realRemindLab;                //已认证/未认证/去认证lab
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realRemindTrail;   //认证提醒lab右边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realViewH;         //实名认证view高度

//高级认证
@property (weak, nonatomic) IBOutlet UILabel *seniorTitleLab;               //高级认证title
@property (weak, nonatomic) IBOutlet UILabel *seniorDetailLab;              //实名认证详情
@property (weak, nonatomic) IBOutlet UIImageView *seniorIconImg;            //高级认证icon
@property (weak, nonatomic) IBOutlet UILabel *seniorRemindLab;              //已认证/未认证/去认证lab
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seniorRemindTrail; //认证提醒lab右边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seniorViewH;       //高级认证view高度

@end

@implementation UGPersonalCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人中心";
    self.uploatHeadImageQueue = dispatch_queue_create("com.bibei.uploatHeadImageQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar] placeholderImage:nil];
     self.userNameLabel.text = _userName;
    
    if ([UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone) {
      self.userPhoneLabel.text = [NSString stringWithFormat:@"+%@  %@",_areaCode,_userPhone];
      self.phoneInfoView.hidden = NO;
        self.phoneViewH.constant = 0;
    }
    else
    {
        self.phoneViewH.constant = 0;
        self.phoneInfoView.hidden = YES;
    }
    
    [self updateSelfView];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longGes.minimumPressDuration = 0.5;//2秒（默认0.5秒）
    [longGes setNumberOfTouchesRequired:1];
    [self.userNameLabel addGestureRecognizer:longGes];
    self.userNameLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGes2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction2:)];
    longGes2.minimumPressDuration = 0.5;//2秒（默认0.5秒）
    [longGes2 setNumberOfTouchesRequired:1];
    [self.userPhoneLabel addGestureRecognizer:longGes2];
    self.userPhoneLabel.userInteractionEnabled = YES;
    
  
}

//根据用户详情刷新view
- (void)updateSelfView
{
    UGUserInfoModel *userModel = [UGManager shareInstance].hostInfo.userInfoModel;
    
    //是否实名认证
    if (userModel.hasRealnameValidation) {
        self.realNameDetailLab.text = [NSString stringWithFormat:@"%@ %@",[UGManager shareInstance].hostInfo.userInfoModel.application.realName,[UGManager shareInstance].hostInfo.userInfoModel.application.idCard];
        self.realIconImg.image = [UIImage imageNamed:@"invalidName"];
        self.realRemindLab.text = @"已认证";
        self.realRemindLab.textColor = [UIColor colorWithRed:163.0/255.0 green:181.0/255.0 blue:221.0/255.0 alpha:1.0];
        self.realRemindTrail.constant = 20.0;
        self.realViewH.constant = 89.0;
    }else {
        self.realNameDetailLab.text = @"认证后可提升提币额度";
        self.realIconImg.image = [UIImage imageNamed:@"invalidName-1"];
        self.realRemindLab.text = @"去认证";
        self.realRemindLab.textColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:55.0/255.0 alpha:1.0];
        self.realRemindTrail.constant = 36.0;
        self.realViewH.constant = 126.0;
        
    }
    
    //是否高级认证
    if (userModel.hasHighValidation) {
        self.seniorRemindLab.text = @"已完成认证，可以安心交易了";
        self.seniorIconImg.hidden = NO;
        self.seniorIconImg.image = [UIImage imageNamed:@"invalidName"];
        self.seniorRemindLab.text = @"已认证";
        self.seniorRemindLab.textColor = [UIColor colorWithRed:163.0/255.0 green:181.0/255.0 blue:221.0/255.0 alpha:1.0];
        self.seniorRemindTrail.constant = 20.0;
    }else {
        self.realNameDetailLab.text = @"实名认证后，方可进行高级认证";
        if (userModel.hasRealnameValidation) {
            self.seniorIconImg.hidden = NO;
            self.seniorIconImg.image = [UIImage imageNamed:@"invalidName-1"];
            self.seniorRemindLab.text = @"去认证";
            self.seniorRemindLab.textColor = [UIColor colorWithRed:255.0/255.0 green:125.0/255.0 blue:55.0/255.0 alpha:1.0];
            self.seniorRemindTrail.constant = 36.0;
        }else {
            self.seniorIconImg.hidden = YES;
            self.seniorRemindLab.text = @"未认证";
            self.seniorRemindLab.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
            self.seniorRemindTrail.constant = 20.0;
        }
    }
    
}

#pragma mark -长按复制
-(void)longPressAction2:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSString *qrstring =  _userPhone;
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSString *qrstring = _userName;
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}



//用户信息
- (IBAction)tapUserInfo:(UITapGestureRecognizer *)sender {
    @weakify(self);
    [self showTakePhotoChooseWithMaxCount:1 WithPoto:YES handle:^(NSArray<UIImage *> * _Nonnull imageList) {
        @strongify(self);
        if (imageList) {
            [self updateImageRequest:imageList.firstObject];
        }
    }];
}

//实名认证
- (IBAction)realNameVerifyAction:(id)sender
{
    
}

//高级认证
- (IBAction)seniorVerifyAction:(id)sender
{
    
}

//上传图片，然后调用修改头像接口
- (void)updateImageRequest:(UIImage *)image {
    
    [EasyShowLodingView showLodingText:@"" inView:self.navigationController.view];
    
    dispatch_async(self.uploatHeadImageQueue, ^{
        dispatch_group_t uploadGroup = dispatch_group_create();
        
        __block NSString *headImageUrlStr = nil;
        __block UGApiError *error = nil;
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.uploatHeadImageQueue, ^(){
            //上传图片到服务器拿到图片URL
            [[[UGUploadImageRequest alloc] initWithImage:image] ug_startWithCompletionBlock:^(UGApiError * _Nonnull apiError, id  _Nonnull object) {
                if (object && [object isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *dic = [NSMutableDictionary new];
                    [dic addEntriesFromDictionary:object];
                    NSArray *arr = [NSArray arrayWithArray:[dic allValues]];
                    if (arr.count>0) {
                         headImageUrlStr = arr[0];
                    }
                }
                error = apiError;
                dispatch_group_leave(uploadGroup);
            }];
            
        });
        
        dispatch_group_notify(uploadGroup, self.uploatHeadImageQueue, ^(){
            
            if (headImageUrlStr) {
                //调用修改头像接口，传入图片的URL
                UGReviseAvatarApi *avatarApi =  [UGReviseAvatarApi new];
                avatarApi.url = headImageUrlStr;
                [avatarApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
                    error = apiError;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [EasyShowLodingView hidenLoingInView:self.navigationController.view];
                        if (!apiError) {
                            self.headImageView.image = image;
                            [UGManager shareInstance ].hostInfo.userInfoModel.member.avatar = headImageUrlStr;
                            //刷新用户信息
                            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                            
                            }];
                        } else {
                            [self.view ug_showToastWithToast:error.desc];
                        }
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [EasyShowLodingView hidenLoingInView:self.navigationController.view];
                        [self.view ug_showToastWithToast:error.desc];
                });
            }
        });
    });
    
}


@end
