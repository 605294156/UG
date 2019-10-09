//
//  AccountSettingViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountImageTableViewCell.h"
#import "AccountSettingTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MoneyPasswordViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "BindingEmailViewController.h"
#import "BindingPhoneViewController.h"
#import "ChangeLoginPasswordViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "ResetPhoneViewController.h"
#import "PaymentAccountViewController.h"

@interface AccountSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    BOOL _phoneVerified;
    BOOL _emailVerified;
    BOOL _loginVerified;
    BOOL _fundsVerified;
    BOOL _realVerified;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
//上传路径
@property(nonatomic,strong) NSMutableArray *accountInfoArr;
@property(nonatomic,strong)NSMutableArray *accountColorArr;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) UIImage *headImage;
@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"accountSettings");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountImageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountImageTableViewCell class])];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.headImage = [[UIImage alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self accountSettingData];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
   
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {

                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
               
                [self getAccountSettingStatus];
            }else if ([resPonseObj[@"code"] integerValue]==4000){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//MARK:--整理账号设置的信息状态
-(void)getAccountSettingStatus{
    if ([_accountInfo.phoneVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:1 withObject:LocalizationKey(@"bounded")];
         [self.accountColorArr replaceObjectAtIndex:1 withObject:[UIColor darkGrayColor]];
        _phoneVerified = YES;
    }else{
        _phoneVerified = NO;
    }
    if ([_accountInfo.emailVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:2 withObject:LocalizationKey(@"bounded")];
        [self.accountColorArr replaceObjectAtIndex:2 withObject:[UIColor darkGrayColor]];
        _emailVerified = YES;
    }else{
        _emailVerified = NO;
    }
    //收款账户
    if ([_accountInfo.accountVerified isEqualToString:@"1"]) {
        //已设置
        [self.accountInfoArr replaceObjectAtIndex:3 withObject:LocalizationKey(@"yetSetting")];
        [self.accountColorArr replaceObjectAtIndex:3 withObject:[UIColor darkGrayColor]];
    }
    if ([_accountInfo.loginVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:4 withObject:LocalizationKey(@"bounded") ];
        [self.accountColorArr replaceObjectAtIndex:4 withObject:[UIColor darkGrayColor]];
        _loginVerified = YES;
    }else{
        _loginVerified = NO;
    }
    if ([_accountInfo.fundsVerified isEqualToString:@"1"]) {
        [self.accountInfoArr replaceObjectAtIndex:5 withObject:LocalizationKey(@"bounded")];
        [self.accountColorArr replaceObjectAtIndex:5 withObject:[UIColor darkGrayColor]];
        _fundsVerified = YES;
    }else{
        _fundsVerified = NO;
    }
    
    if ([_accountInfo.realVerified isEqualToString:@"1"]) {
        //审核成功
        [self.accountInfoArr replaceObjectAtIndex:6 withObject:LocalizationKey(@"bounded")];
        [self.accountColorArr replaceObjectAtIndex:6 withObject:[UIColor darkGrayColor]];
        _realVerified = YES;
    }else{
        if ([_accountInfo.realAuditing isEqualToString:@"1"]) {
            //审核中
            [self.accountInfoArr replaceObjectAtIndex:6 withObject:LocalizationKey(@"auditing")];
            [self.accountColorArr replaceObjectAtIndex:6 withObject:GreenColor];
        }else{
            if (_accountInfo.realNameRejectReason== nil) {
                //未绑定
            }else{
                [self.accountInfoArr replaceObjectAtIndex:6 withObject:LocalizationKey(@"auditFailure")];
                [self.accountColorArr replaceObjectAtIndex:6 withObject:RedColor];
            }
        }
        _realVerified = NO;
    }
    [self.tableView reloadData];
}
- (NSMutableArray *)accountInfoArr {
    if (!_accountInfoArr) {
        _accountInfoArr = [NSMutableArray arrayWithArray:@[@"",
                                                           LocalizationKey(@"unbounded"),
                                                           LocalizationKey(@"unbounded"),
                                                           LocalizationKey(@"unSetting"),
                                                           LocalizationKey(@"unbounded"),
                                                           LocalizationKey(@"unbounded"),
                                                           LocalizationKey(@"unbounded"),
                                                           LocalizationKey(@"unbounded")
                                                           ]];
    }
    return _accountInfoArr;
}
- (NSMutableArray *)accountColorArr {
    if (!_accountColorArr) {
        _accountColorArr = [NSMutableArray arrayWithArray:@[baseColor,baseColor,baseColor,baseColor,baseColor,baseColor,baseColor,baseColor]];
    }
    return _accountColorArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 80;
    }else{
      return 50;
    }
}
-(NSArray *)getNameArr{
    NSArray * nameArr = @[
                          @"",
                          LocalizationKey(@"bindPhoneNumber"),
                          LocalizationKey(@"bindingEmail"),
                          LocalizationKey(@"paymentAccount"),
                          LocalizationKey(@"loginPassword"),
                          LocalizationKey(@"moneyPassword"),
                          LocalizationKey(@"identityAuthentication")
                          ];
    return nameArr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AccountImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountImageTableViewCell class]) forIndexPath:indexPath];
        cell.headImage.clipsToBounds = YES;
        cell.headImage.layer.cornerRadius = 30;
        if (self.accountInfo.avatar == nil || [self.accountInfo.avatar isEqualToString:@""]) {
        }else{
            NSString *headStr = [NSString stringWithFormat:@"%@%@",PicHOST,self.accountInfo.avatar];
            NSURL *headUrl = [NSURL URLWithString:headStr];

            [cell.headImage sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"header_defult"]];
        }
        return cell;
    }else{
        AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
        cell.leftLabel.text = [self getNameArr][indexPath.row];
        cell.rightLabel.text = [self accountInfoArr][indexPath.row];
        cell.rightLabel.textColor = [self accountColorArr][indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //改变头像
        [self changeHeaderImage];
    }else if (indexPath.row == 1){
        //绑定手机
        if (_phoneVerified){
            ResetPhoneViewController *resetVC = [[ResetPhoneViewController alloc] init];
            resetVC.phoneNum = self.accountInfo.mobilePhone;
            [self.navigationController pushViewController:resetVC animated:YES];
        }else{
            BindingPhoneViewController *phoneVC = [[BindingPhoneViewController alloc] init];
            [self.navigationController pushViewController:phoneVC animated:YES];
        }
    }else if (indexPath.row == 2){
        //绑定邮箱
        BindingEmailViewController *emailVC = [[BindingEmailViewController alloc] init];
        if (_emailVerified == YES) {
            emailVC.bindingStatus = 1;
            emailVC.emailStr = self.accountInfo.email;
        }else{
            emailVC.bindingStatus = 0;
        }
        [self.navigationController pushViewController:emailVC animated:YES];
    }else if (indexPath.row == 3){
        //收款方式
        if (!_realVerified) {
            [self.view ug_showToastWithToast:LocalizationKey(@"validateYourID")];
            return;
        }
        if (!_fundsVerified) {
            [self.view ug_showToastWithToast:LocalizationKey(@"bindingPwd")];
            return;
        }
        PaymentAccountViewController *payVC = [[PaymentAccountViewController alloc] init];
        [self.navigationController pushViewController:payVC animated:YES];
        
    }else if (indexPath.row == 4){
        //登录密码
        if (!_phoneVerified) {
            [self.view ug_showToastWithToast:LocalizationKey(@"unBindPhoneTip")];
            return;
        }
        ChangeLoginPasswordViewController *changeLoginVC = [[ChangeLoginPasswordViewController alloc] init];
        changeLoginVC.phoneNum = self.accountInfo.mobilePhone;
        [self.navigationController pushViewController:changeLoginVC animated:YES];
    }else if (indexPath.row == 5){
        //资金密码
        MoneyPasswordViewController *moneyVC = [[MoneyPasswordViewController alloc] init];
        if (_fundsVerified == YES) {
            moneyVC.setStatus = 1;
        }else{
            moneyVC.setStatus = 0;
        }
        [self.navigationController pushViewController:moneyVC animated:YES];
        
    }else if (indexPath.row == 6){
        //身份认证
        IdentityAuthenticationViewController *identityVC = [[IdentityAuthenticationViewController alloc] init];
        identityVC.identifyStatus = self.accountInfo.realVerified;
        identityVC.realNameRejectReason = self.accountInfo.realNameRejectReason;
        identityVC.realAuditing = self.accountInfo.realAuditing;
        [self.navigationController pushViewController:identityVC animated:YES];
    }else{
        //其他
    }
}
//MARK:--添加头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    UIAlertController *sheet =[UIAlertController alertControllerWithTitle:LocalizationKey(@"projectNameTip") message:LocalizationKey(@"addHeadImageMessage") preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"takingPictures") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否已授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
                [self.view ug_showToastWithToast:LocalizationKey(@"cameraPermissionsTips")];
                return ;
            }
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self chooseImage:sourceType];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"tips") message:LocalizationKey(@"unSupportTakePhoto") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"photoAlbumSelect") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否已授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus == ALAuthorizationStatusDenied) {
                [self.view ug_showToastWithToast:LocalizationKey(@"cameraPermissionsTips")];
                return;
            }
        }
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self chooseImage:sourceType];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:sheet animated:YES completion:nil];
    });
    
}
//从本地选择照片（拍照或从相册选择）
-(void)chooseImage:(NSInteger)sourceType
{
    //创建对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerVC = imagePickerController;
    //设置代理
    imagePickerController.delegate = self;
    //是否允许图片进行编辑
    imagePickerController.allowsEditing = YES;
    //选择图片还是开启相机
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController代理 已经选择了图片,上传到服务器中,返回上传结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //选择图片
    UIImage *headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
    //将图片上传到服务器
    [EasyShowLodingView showLodingText:LocalizationKey(@"upLoadingHeadPhoto")];
    [MineNetManager uploadImageData:imageData CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        DLog(@"%@",resPonseObj);
        if (code) {
            //
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AccountImageTableViewCell *cell = (AccountImageTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                cell.headImage.image = headImage;
                [self headImage:resPonseObj[@"data"]];
                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
//                [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [self showLoginViewController];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"upLoadPictureFailure")];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//MARK:--设置头像
-(void)headImage:(NSString *)urlString{
    [EasyShowLodingView showLodingText:LocalizationKey(@"settingHeadImage")];
     NSString * upAvatar = [NSString stringWithFormat:@"%@",urlString];
    [MineNetManager setHeadImageForUrl:upAvatar CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //设置头像成功
                  [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];

            }else if ([resPonseObj[@"code"] integerValue]==4000){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                 [[UGManager shareInstance] signout:nil];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
           [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
    
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    
//    //设置动画时间为0.25秒,xy方向缩放的最终值为1
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        
//    }completion:^(BOOL finish){
//        
//    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
