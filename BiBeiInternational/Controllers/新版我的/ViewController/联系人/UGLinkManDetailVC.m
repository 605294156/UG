//
//  UGLinkManDetailVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGLinkManDetailVC.h"
#import "UGRelationDetailApi.h"
#import "UGLinkModel.h"
#import "UGHomeTransferVC.h"
#import "UGJPushHandle.h"
#import "UGPayQRModel.h"

@interface UGLinkManDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic,strong)UGLinkModel *detailModel;
@end

@implementation UGLinkManDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationBarHidden = YES;
    
    [self getData];
}

-(void)getData{
    [self.view ug_showMBProgressHudOnKeyWindow];
    UGRelationDetailApi *api = [UGRelationDetailApi new];
    api.memberId = self.memberId;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            self.detailModel = [UGLinkModel mj_objectWithKeyValues:object];
            [self reloadUI];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(void)reloadUI{
    if (self.detailModel) {
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.detailModel.avatar] placeholderImage:nil];
        self.userName.text = self.detailModel.username;
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 转币
- (IBAction)transfer:(id)sender {
//    if ([self hasBindingGoogleValidator]) {//2.0换手机号
        if (self.detailModel && !UG_CheckArrayIsEmpty(self.detailModel.walletAddress) && self.detailModel.walletAddress.count>0)
        {
            UGPayQRModel *model = [UGPayQRModel new];
            model.merchCardNo =self.detailModel.walletAddress[0];
            model.loginName = self.detailModel.username;
            model.orderType = @"0";
            model.amount = @"";
            model.orderSn = @"";
            model.merchNo = @"";
            model.extra = @"";
            UGHomeTransferVC *vc = [UGHomeTransferVC new];
            vc.qrModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
//    }
}

#pragma mark - 聊天
- (IBAction)chat:(id)sender {
}

@end
