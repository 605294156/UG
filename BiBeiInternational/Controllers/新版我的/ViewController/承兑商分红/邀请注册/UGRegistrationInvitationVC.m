//
//  UGRegistrationInvitationVC.m
//  BiBeiInternational
//
//  Created by keniu on 2019/8/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGRegistrationInvitationVC.h"
#import "UGInvitationCardVC.h"
#import "UGRatePopView.h"
#import "UGRateModel.h"
#import "UGAcceptorGetRateApi.h"

@interface UGRegistrationInvitationVC ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *RegistrationInvitationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout6;
@property (weak, nonatomic) IBOutlet UILabel *rateLabe;
//分红费率View
@property (weak, nonatomic) IBOutlet UIView *dividendRateView;
@property (weak, nonatomic) IBOutlet UILabel *dividendRateLabel;
@property (weak, nonatomic) IBOutlet UIButton *dividendRateButton;
//下拉弹框是否显示
@property(nonatomic,assign)BOOL isRateSelectViewShow;
@property(nonatomic,strong)UGRatePopView *ratePopView;
@property(nonatomic,strong)UGRateModel *dataSource;
@property(nonatomic,strong)UGSlaveRateModel *selectedModel;

//四寸屏幕适配相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitationButtonHeight;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descRightLayout;
@property (weak, nonatomic) IBOutlet UILabel *lable3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitationButtonLeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *invitationButtonRightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateviewLeftLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateviewRightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toRateTopHeight;


@end

@implementation UGRegistrationInvitationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self aboutUI];
    
   [self getRateList:YES];
}

-(void)getRateList:(BOOL)isFirst{
    if ( ! isFirst) {
          [self.view ug_showMBProgressHUD];
    }
    @weakify(self);
    UGAcceptorGetRateApi *api = [[UGAcceptorGetRateApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if ( ! isFirst) {
            [self.view ug_hiddenMBProgressHUD];
        }
        if (object) {
            self.dataSource = [UGRateModel mj_objectWithKeyValues:object];
            if (self.dataSource) {
                self.rateLabe.text = [NSString stringWithFormat:@"%@‰",self.dataSource.masterRate];
            }
            if ( ! isFirst) {
                [self showPopView];
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark-UI 设置
-(void)aboutUI
{
    self.navigationBarHidden = YES;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.topLayout1.constant = UG_AutoSize(12);
    self.topLayout2.constant = UG_AutoSize(12);
    self.topLayout4.constant = UG_AutoSize(35);
    self.topLayout5.constant = UG_AutoSize(46);
    self.topLayout6.constant = UG_AutoSize(15);
    if (IS_IPHONE_X) {
        self.navTopLayout.constant = 32;
    }
    if (UG_SCREEN_WIDTH < 414) {
        self.topLayout1.constant = 4;
        self.topLayout2.constant = 4;
    }
    //四英寸屏幕适配
    if ([UG_MethodsTool is4InchesScreen]) {
        self.rateLabe.font = [UIFont systemFontOfSize:32];
        self.avatarWidthLayout.constant = 50;
        self.avatarHeightLayout.constant = 50;
        self.avatarTopLayout.constant = -25;
        self.avatarImageView.layer.cornerRadius = 25;
        self.avatarImageView.layer.masksToBounds = YES;
        self.topLayout1.constant = 4;
        self.topLayout2.constant = 4;
        self.topLayout4.constant = 20;
        self.topLayout5.constant = 20;
        self.topLayout6.constant = 8;
        self.invitationButtonHeight.constant = 40;
        self.lineLabel1.text = @"—————";
        self.lineLabel2.text = @"—————";
        self.descLeftLayout.constant = 20;
        self.descRightLayout.constant = 20;
        self.rateviewLeftLayout.constant = 30;
        self.rateviewRightLayout.constant = 30;
        self.toRateTopHeight.constant = 14;
        self.invitationButtonLeftLayout.constant = 30;
        self.invitationButtonRightLayout.constant = 30;
        self.RegistrationInvitationButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.label1.font = [UIFont systemFontOfSize:14];
        self.label2.font = [UIFont systemFontOfSize:14];
        self.lable3.font = [UIFont systemFontOfSize:14];
        
    }
}

#pragma mark-下拉按钮响应事件
- (IBAction)dividendRateButtonAction:(UIButton *)sender {
    [self showPopView];
}

-(void)showPopView{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect startRact = [self.dividendRateView convertRect:self.dividendRateView.bounds toView:window];
    startRact = CGRectMake(0, 0, UG_SCREEN_WIDTH, UG_SCREEN_HEIGHT);
    if (self.dataSource && ! UG_CheckArrayIsEmpty(self.dataSource.slaveRate) && self.dataSource.slaveRate.count > 0) {
        if ( ! self.isRateSelectViewShow) {
            if ( ! self.ratePopView) {
                self.ratePopView = [[UGRatePopView alloc] initWithViewFrame:startRact WithDataArr:self.dataSource.slaveRate WithHandle:^(UGSlaveRateModel * _Nonnull model) {
                    self.selectedModel = model;
                    self.dividendRateLabel.text = [NSString stringWithFormat:@"%@‰",model.nextRate];
                    [self changeStyle:NO];
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:self.ratePopView];
            }else{
                [self.ratePopView showMenuWithFrame:startRact ];
            }
            [self changeStyle:YES];
        }else{
            [self changeStyle:NO];
            [self.ratePopView hideMenuWithFrame:startRact];
        }
    }else{
        [self getRateList:NO];
    }
}

-(void)changeStyle:(BOOL)show{
    if (show) {
        self.isRateSelectViewShow  = YES;
//        self.dividendRateButton.selected = YES;
        self.dividendRateLabel.textColor = [self.dividendRateLabel.text isEqualToString: @"请选择"] ? [UIColor colorWithHexString: @"AAAAAA"] : UG_MainColor;
//        self.dividendRateView.layer.borderColor = UG_MainColor.CGColor;
    }else{
        self.isRateSelectViewShow  = NO;
//        self.dividendRateButton.selected = NO;
        self.dividendRateLabel.textColor = [self.dividendRateLabel.text isEqualToString: @"请选择"] ? [UIColor colorWithHexString: @"AAAAAA"] : UG_MainColor;
//        self.dividendRateView.layer.borderColor = [UIColor colorWithHexString: @"D8D8D8"].CGColor;
    }
}

- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registrationInvitationAction:(id)sender {
   
    if (self.selectedModel) {
        
        UGInvitationCardVC *vc = [[UGInvitationCardVC alloc]init];
        vc.rate = self.selectedModel.nextRate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self.view ug_showToastWithToast:@"您还未选择下级分红费率"];
    }

    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.ratePopView removeFromSuperview];
    self.ratePopView = nil;
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect startRact = [self.dividendRateView convertRect:self.dividendRateView.bounds toView:window];
//    [self.ratePopView hideMenuWithFrame:startRact];
    
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
