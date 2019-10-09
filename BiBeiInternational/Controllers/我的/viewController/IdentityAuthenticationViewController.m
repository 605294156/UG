//
//  IdentityAuthenticationViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/7.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//
#import "IdentityAuthenticationViewController.h"
#import "MineNetManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MineNetManager.h"
#import "IdentifyPersionInfoModel.h"

@interface IdentityAuthenticationViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *IDNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *faceImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *backImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *takeImageBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic) NSInteger btnTag;
//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
//返回的图片路径数组
@property (nonatomic,strong)NSMutableDictionary *imageDic;
@property(nonatomic,strong)IdentifyPersionInfoModel *personInfoModel;
@property (weak, nonatomic) IBOutlet UILabel *reasonTitle;
@property (weak, nonatomic) IBOutlet UIView *reasonView;
@property (weak, nonatomic) IBOutlet UIImageView *reasonImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resonViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *faceImageView;
@property (weak, nonatomic) IBOutlet UIView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *takeImageView;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *faceIDImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *backIDImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeIDImage;

@end

@implementation IdentityAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"identityAuthentication");
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageDic = [[NSMutableDictionary alloc]init];
    self.IDNumTextField.keyboardType = UIKeyboardTypeASCIICapable;
    if ([self.identifyStatus isEqualToString:@"1"]) {
        //审核成功
        [self getIdentifyData];
        self.faceImageView.hidden = YES;
        self.backImageView.hidden = YES;
        self.takeImageView.hidden = YES;
        self.submitButton.hidden = YES;
        [self makeUI];
    }else{
        self.faceImageView.hidden = NO;
        self.backImageView.hidden = NO;
        self.takeImageView.hidden = NO;
        self.submitButton.hidden = NO;
        if ([self.realAuditing isEqualToString:@"1"]) {
            //审核中
            [self getIdentifyData];
            [self makeUI];
        }else{
            if (self.realNameRejectReason== nil) {
                //未提交认证
                [self makeUI];
            }else{
                //审核失败
                [self getIdentifyData];
                [self makeUI];
            }
        }
    }
    self.nameLabel.text = LocalizationKey(@"name");
    self.IDNumLabel.text = LocalizationKey(@"IdCardNumber");
    self.faceIDImageLabel.text = LocalizationKey(@"faceIDImage");
    self.backIDImageLabel.text = LocalizationKey(@"backIDImage");
    self.takeIDImage.text = LocalizationKey(@"takeIDImage");
    self.nameTextField.placeholder = LocalizationKey(@"inputcertifyName");
    self.IDNumTextField.placeholder = LocalizationKey(@"inputcertifyIDNum");
    [self.submitButton setTitle:LocalizationKey(@"startCertification") forState:UIControlStateNormal];
}
//MARK:--获取身份认证的消息
-(void)getIdentifyData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getIdentifyInfo:^(id resPonseObj, int code){
        [EasyShowLodingView hidenLoding];
        NSLog(@"___%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                self.personInfoModel = [IdentifyPersionInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                [self arrageData];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//整理数据
-(void)arrageData{

    self.personInfoModel.identityCardImgInHand  = [self.personInfoModel.identityCardImgInHand  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.personInfoModel.identityCardImgReverse  = [self.personInfoModel.identityCardImgReverse  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([self.identifyStatus isEqualToString:@"1"]) {
        //审核成功
        self.nameTextField.enabled = NO;
        self.IDNumTextField.enabled = NO;
        self.faceImageBtn.userInteractionEnabled = NO;
        self.backImageBtn.userInteractionEnabled = NO;
        self.takeImageBtn.userInteractionEnabled = NO;
        self.submitButton.userInteractionEnabled = NO;
        self.submitButton.alpha = 0.4;
        if (self.personInfoModel.realName.length == 2) {
            NSString *name = [self.personInfoModel.realName substringFromIndex:self.personInfoModel.realName.length-1];
             self.nameTextField.text = [NSString stringWithFormat:@"*%@",name];
        }else if (self.personInfoModel.realName.length == 4){
            NSString *name = [self.personInfoModel.realName substringFromIndex:self.personInfoModel.realName.length-1];
            self.nameTextField.text = [NSString stringWithFormat:@"***%@",name];
        }else{
            NSString *name = [self.personInfoModel.realName substringFromIndex:self.personInfoModel.realName.length-1];
            self.nameTextField.text = [NSString stringWithFormat:@"**%@",name];
        }
        NSString *backFourId = [self.personInfoModel.idCard substringFromIndex:self.personInfoModel.idCard.length-4];
        NSString *fontFourId = [self.personInfoModel.idCard substringToIndex:4];
         self.IDNumTextField.text = [NSString stringWithFormat:@"%@*********%@",fontFourId,backFourId];
    }else{
        if ([self.realAuditing isEqualToString:@"1"]) {
            //审核中
            self.nameTextField.enabled = NO;
            self.IDNumTextField.enabled = NO;
            self.faceImageBtn.userInteractionEnabled = NO;
            self.backImageBtn.userInteractionEnabled = NO;
            self.takeImageBtn.userInteractionEnabled = NO;
            self.submitButton.userInteractionEnabled = NO;
            self.submitButton.alpha = 0.4;
            self.nameTextField.text = self.personInfoModel.realName;
            self.IDNumTextField.text = self.personInfoModel.idCard;
   
            [self.faceImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PicHOST,self.personInfoModel.identityCardImgFront]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"faceImage"]];
            
            [self.backImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PicHOST,self.personInfoModel.identityCardImgReverse]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"backImage"]];
           
            NSString * handStr = [NSString stringWithFormat:@"%@%@",PicHOST,self.personInfoModel.identityCardImgInHand];
            
            [self.takeImageBtn sd_setImageWithURL:[NSURL URLWithString:handStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"takeIDImage"]];
        }else{
            if (self.realNameRejectReason== nil) {
                //未提交认证

            }else{
                //审核失败
                self.nameTextField.text = self.personInfoModel.realName;
                self.IDNumTextField.text = self.personInfoModel.idCard;
                
                [self.faceImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PicHOST,self.personInfoModel.identityCardImgFront]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"faceImage"]];
                
                [self.backImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PicHOST,self.personInfoModel.identityCardImgReverse]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"backImage"]];
                
                NSString * handStr = [NSString stringWithFormat:@"%@%@",PicHOST,self.personInfoModel.identityCardImgInHand];
                
                [self.takeImageBtn sd_setImageWithURL:[NSURL URLWithString:handStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"takeIDImage"]];
                
                
                
//                [self.faceImageBtn sd_setImageWithURL:[NSURL URLWithString:self.personInfoModel.identityCardImgFront] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"faceImage"]];
//                [self.backImageBtn sd_setImageWithURL:[NSURL URLWithString:self.personInfoModel.identityCardImgReverse] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"backImage"]];
//                [self.takeImageBtn sd_setImageWithURL:[NSURL URLWithString:self.personInfoModel.identityCardImgInHand] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"takeIDImage"]];

                [self.imageDic setObject:self.personInfoModel.identityCardImgFront forKey:@"idCardFront"];
                [self.imageDic setObject:self.personInfoModel.identityCardImgReverse forKey:@"idCardBack"];
                [self.imageDic setObject:self.personInfoModel.identityCardImgInHand forKey:@"handHeldIdCard"];
            
            }
        }
    }
}
//MARK:---修饰界面
-(void)makeUI{
    
    CGRect rect = self.bgView.frame;
    if ([self.identifyStatus isEqualToString:@"1"]) {
        //审核成功
         self.reasonTitle.text = LocalizationKey(@"certifySuccessful");
        self.resonViewHeight.constant = [self calculateRowHeight:self.reasonTitle.text fontSize:17]+40;
        rect.size.height=rect.size.height-(100-self.resonViewHeight.constant);
        self.reasonImage.image = [UIImage imageNamed:@""];
        self.reasonView.backgroundColor = baseColor;
    
    }else{
        if ([self.realAuditing isEqualToString:@"1"]) {
            //审核中
            self.reasonTitle.text = LocalizationKey(@"certifyAuditing");
            self.resonViewHeight.constant = [self calculateRowHeight:self.reasonTitle.text fontSize:17]+40;
            rect.size.height=rect.size.height-(100-self.resonViewHeight.constant);
            self.reasonImage.image = [UIImage imageNamed:@"identityWaitImage"];
            self.reasonView.backgroundColor = [UIColor colorWithRed:233/255.0 green:244/255.0 blue:249/255.0 alpha:1];
            
        }else{
            if (self.realNameRejectReason== nil) {
                //未提交认证
                rect.size.height=rect.size.height-100;
                self.resonViewHeight.constant = 0;
                self.reasonView.hidden = YES;
            }else{
                //审核失败
                self.reasonTitle.text = [NSString stringWithFormat:@"%@ \n%@%@",LocalizationKey(@"certifyFailure"),LocalizationKey(@"failureReason"),self.realNameRejectReason];

                self.resonViewHeight.constant = [self calculateRowHeight:self.reasonTitle.text fontSize:17]+40;
                rect.size.height=rect.size.height-(100-self.resonViewHeight.constant);
                self.reasonImage.image = [UIImage imageNamed:@"careFullyImage"];
                self.reasonView.backgroundColor = [UIColor colorWithRed:250/255.0 green:253/255.0 blue:243/255.0 alpha:1];
            }
        }
    }
    rect.size.width=kWindowW;
    self.bgView.frame=rect;
    [self.bgScrollView addSubview:self.bgView];
 self.bgScrollView.contentSize=self.bgView.frame.size;

}
//MARK--计算文字的高度
- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.reasonTitle.frame.size.width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
//MARK:--证件照点击事件
- (IBAction)takeImageBtnClick:(UIButton *)sender {
    self.btnTag = sender.tag;
    [self changeHeaderImage];
}
//MARK:--添加头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    UIAlertController *sheet =[UIAlertController alertControllerWithTitle:LocalizationKey(@"projectNameTip") message:LocalizationKey(@"certifyTakePhotoTip") preferredStyle:UIAlertControllerStyleActionSheet];
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
                [self.view ug_showToastWithToast:LocalizationKey(@"cameraPermissionsTips") ];
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
                [self.view ug_showToastWithToast:LocalizationKey(@"upLoadPictureSuccess")];
                UIButton *btn = [self.view viewWithTag:self.btnTag];
                btn.userInteractionEnabled = YES;
                NSString * avatar = resPonseObj[@"data"];
                if (self.btnTag == 11) {
                    [self.imageDic setObject:avatar forKey:@"idCardFront"];
                    [self.faceImageBtn setImage:headImage forState:UIControlStateNormal];
                    NSLog(@"--%@--%ld",headImage,(long)self.btnTag);
                }
                if (self.btnTag == 22) {
                    [self.imageDic setObject:avatar forKey:@"idCardBack"];
                    [self.backImageBtn setImage:headImage forState:UIControlStateNormal];
                }
                if (self.btnTag == 33) {
                    [self.imageDic setObject:avatar forKey:@"handHeldIdCard"];
                    [self.takeImageBtn setImage:headImage forState:UIControlStateNormal];
                }
                
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


//MARK:--按钮的点击事件
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //国籍按钮
        NSLog(@"国籍按钮");
    }else if (sender.tag == 2){
        //开始认证按钮
        if ([self.nameTextField.text isEqualToString:@""]) {
            [self.view ug_showToastWithToast:LocalizationKey(@"inputcertifyName")];
            return;
        }
        if ([self.IDNumTextField.text isEqualToString:@""]) {
            [self.view ug_showToastWithToast:LocalizationKey(@"inputcertifyIDNum")];
            return;
        }
        if ([self.imageDic allKeys].count < 3) {
            [self.view ug_showToastWithToast:LocalizationKey(@"upLoadPictureFailure")];
            return;
        }
        [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
        [MineNetManager identityAuthenticationRealName:self.nameTextField.text  andIdCard:self.IDNumTextField.text andCardDic:self.imageDic CompleteHandle:^(id resPonseObj, int code) {
             [EasyShowLodingView hidenLoding];
            NSLog(@"--%@",resPonseObj);
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });

                }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                    //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                    [[UGManager shareInstance] signout:nil];
                }else{
                     [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                }
            }else{
                [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
            }
        }];
    }else {
        //其他
    }
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
