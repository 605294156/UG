//
//  UGMakeTrueMnemonnicVC.m
//  ug-wallet
//
//  Created by conew on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGMakeTrueMnemonnicVC.h"
#import "UGMnemoesCollectionView.h"
#define TOPCOLLECTIONTAG  100
#define BOTTOMCOLLECTIONTAG 101
#import "UGAssetsViewController.h"
#import "UGGetAuxiliariesApi.h"
#import "UGFingerprintVC.h"
#import "UGCheckUserAuxiliariesApi.h"
#import "UGSubmitUserAuxiliariesApi.h"
#import "UGfindAuxiliariesByUsernameApi.h"
#import "UGFindPassWordTureVC.h"
#import "UGReviseWalletPasswordVC.h"
#import "UGRevisePasswordVC.h"
#import "UILabel+XcXibLabel.h"


@interface UGMakeTrueMnemonnicVC ()<UGMnemoesCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstrain;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLabelConstrain;
@property (nonatomic,strong)UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerH2;
@property (weak, nonatomic) IBOutlet UILabel *registerL;

@property (nonatomic,strong)UGMnemoesCollectionView *topCollectionView;
@property (nonatomic,strong)UGMnemoesCollectionView *bottomCollectionView;
@property (nonatomic,strong)NSMutableArray*selectedArray;
@property (nonatomic,strong)NSArray *wordsArray;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,copy)NSString *size;
@property (nonatomic,assign)BOOL isBack;
@property (nonatomic,assign)BOOL isSeting;
@end

@implementation UGMakeTrueMnemonnicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isFindLoginPassword){
      [self resetLoginPasswordRequest];
    }else{
     [self haveRequest];
    }
    
    [self initUI];
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self retruns];
    }];
}

-(void)retruns{
    if (self.isfromRegister) {
        self.isBack = YES;
        if (self.isRegister) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        } else {
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSMutableArray *)selectedArray{
    if ( ! _selectedArray) {
        _selectedArray = [[NSMutableArray alloc] init];
    }
    return _selectedArray;
}

-(void)haveRequest{
    UGGetAuxiliariesApi *api = [UGGetAuxiliariesApi new];
    [self.view ug_showMBProgressHudOnKeyWindow];
    [api  ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)object;
                self.size = [dict objectForKey:@"size"];
                NSString *str = [dict objectForKey:@"list"];
                self.wordsArray =[str componentsSeparatedByString:@","];
                if ( ! UG_CheckArrayIsEmpty(self.wordsArray)) {
                    if ( ! self.isfromRegister) {
                        self.wordsArray = [UG_MethodsTool randomArray:self.wordsArray];
                    }else{
                        NSString *str =  [NSString stringWithFormat:@"助记词用于重置钱包登陆密码或支付密码,请您从下方词组中任意选择%@个词组,并按顺序准确地抄写在纸上或截图保存到手机，助记词丢失将无法找回。",self.size];
                        NSString  *str1 = [NSString stringWithFormat : @"%@个词组",self.size];
                        NSMutableAttributedString *attrbuStr = [self attributedStringWith:str WithRangeStr1:str1 WithRangeStr2:@"按顺序" WithRangeStr3:@"抄写" WithRangeStr4:@"截图"];
                        self.registerLabel.attributedText =attrbuStr;
                    }
                     [self.bottomCollectionView changeTitle:self.wordsArray];
                }
            }
        }else{
            [self.view  ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark - 标记不同字体颜色为红色
-(NSMutableAttributedString *)attributedStringWith:(NSString *)attributedString WithRangeStr1:(NSString *)rangeStr1  WithRangeStr2:(NSString *)rangeStr2 WithRangeStr3:(NSString *)rangeStr3 WithRangeStr4:(NSString *)rangeStr4{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    NSRange range1 = [[str string] rangeOfString:rangeStr1];
    NSRange range2 = [[str string] rangeOfString:rangeStr2];
    NSRange range3 = [[str string] rangeOfString:rangeStr3];
    NSRange range4 = [[str string] rangeOfString:rangeStr4];
    [str addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithHexString:Color_RedX] range:range1];
    [str addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithHexString:Color_RedX] range:range2];
    [str addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithHexString:Color_RedX] range:range3];
    [str addAttribute:NSForegroundColorAttributeName value: [UIColor colorWithHexString:Color_RedX] range:range4];
    return str;
}

#pragma mark - 找回密码相关
-(void)resetLoginPasswordRequest
{
    UGfindAuxiliariesByUsernameApi *api = [UGfindAuxiliariesByUsernameApi new];
    api.username = self.username;
    [self.view ug_showMBProgressHudOnKeyWindow];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            NSDictionary *dict = (NSDictionary *)object;
            self.size = [dict objectForKey:@"size"];
            NSString *str = [dict objectForKey:@"list"];
            self.wordsArray =[str componentsSeparatedByString:@","];
            if ( ! UG_CheckArrayIsEmpty(self.wordsArray)){
                self.wordsArray = [UG_MethodsTool randomArray:self.wordsArray];
                [self.bottomCollectionView changeTitle:self.wordsArray];
            }
        }
        else
        {
            [self.view ug_showToastWithToast:apiError.desc];
        }

    }];
}

#pragma mark -找回密码
-(void)resetLoginPasswordConfirmAction{
    
         NSString *string = [self.selectedArray componentsJoinedByString:@","];
    if (self.isFindLoginPassword) {
        UGFindPassWordTureVC *vc = [[UGFindPassWordTureVC alloc]init];
        vc.topVC =  self.topVC;
        vc.username = self.username;
        vc.auxiliaries = string;
        vc.isFindLoginPassword = self.isFindLoginPassword;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UGRevisePasswordVC *vc =  [[UGRevisePasswordVC alloc]init];
        vc.topVC = self.topVC;
        vc.username = self.username;
        vc.auxiliaries = string;
        vc.fromAuxiliaries = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)initUI{
    self.title = self.isfromRegister ? @"备份助记词" : @"助记词验证";
 
    self.titleConstrain.constant = UG_AutoSize(30);
    self.desLabelConstrain.constant = UG_AutoSize(15);
    self.registerH.constant = UG_AutoSize(20);
    self.registerH2.constant = UG_AutoSize(15);
    
    if (self.isfromRegister) {
        self.height = self.registerH.constant+self.registerL.frame.size.height+self.registerH2.constant+ self.registerLabel.frame.size.height;
        self.titleLabel.hidden = YES;
        self.desLabel.hidden = YES;
        self.registerLabel.hidden = NO;
        self.registerL.hidden = NO;
    }else{
        self.height = self.titleConstrain.constant+self.titleLabel.frame.size.height +self.desLabelConstrain.constant+ self.desLabel.frame.size.height;
        self.titleLabel.hidden = NO;
        self.desLabel.hidden = NO;
        self.registerLabel.hidden = YES;
        self.registerL.hidden = YES;
    }
    
    self.topCollectionView = [[UGMnemoesCollectionView alloc] initWithFrame:CGRectMake(UG_AutoSize(30),self.height+UG_AutoSize(20), UG_SCREEN_WIDTH-2*UG_AutoSize(30), UG_AutoSize(120)) withTitle:self.selectedArray];
    self.topCollectionView.tag = TOPCOLLECTIONTAG;
    self.topCollectionView.ugDelegate = self;
    self.topCollectionView.backgroundColor = RGBCOLOR(245, 245, 245);
    self.topCollectionView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    self.topCollectionView.layer.borderWidth = 1.0f;
    [self.view addSubview:self.topCollectionView];
    
    self.bottomCollectionView = [[UGMnemoesCollectionView alloc] initWithFrame:CGRectMake(UG_AutoSize(30), CGRectGetMaxY(self.topCollectionView.frame)+UG_AutoSize(20), UG_SCREEN_WIDTH-2*UG_AutoSize(30), UG_AutoSize(120)) withTitle:self.wordsArray];
    self.bottomCollectionView.isShowdom = false;
    self.bottomCollectionView.tag = BOTTOMCOLLECTIONTAG;
    self.bottomCollectionView.ugDelegate = self;
    [self.view addSubview:self.bottomCollectionView];
    
    self.createBtn.frame = CGRectMake(UG_AutoSize(30), CGRectGetMaxY(self.bottomCollectionView.frame)+UG_AutoSize(100), UG_SCREEN_WIDTH-2*UG_AutoSize(30), UG_AutoSize(44));
    [self.view addSubview:self.createBtn];
}

#pragma mark- UGMnemoesCollectionViewDelegate
-(void)cellDidSelected:(UGMnemoesCollectionView *)collectionView SelectedObj:(NSString *)selectedObj{
    if (UG_CheckArrayIsEmpty(self.selectedArray)) {
        self.selectedArray = [[NSMutableArray alloc] init];
    }
    NSInteger index =[self.selectedArray  indexOfObject:selectedObj];
    if (collectionView.tag == TOPCOLLECTIONTAG) {
        if (index != NSNotFound) {
            //存在
            [self.selectedArray removeObjectAtIndex:index];
            [self.topCollectionView changeTitle:self.selectedArray];
            self.bottomCollectionView.selectedArray = self.selectedArray;
        }
    }else{
        if (index != NSNotFound) {
            //存在
             [self.selectedArray removeObjectAtIndex:index];
             [self.topCollectionView changeTitle:self.selectedArray];
             self.bottomCollectionView.selectedArray = self.selectedArray;
        }else{
            
            if (self.isfromRegister) {
                if (self.selectedArray.count < [self.size integerValue]) {
                    //不存在
                    [self.selectedArray addObject:selectedObj];
                    [self.topCollectionView changeTitle:self.selectedArray];
                    self.bottomCollectionView.selectedArray = self.selectedArray;
                }
                else
                {
                    [self.view ug_showToastWithToast: [NSString stringWithFormat:@"请选择%@个词组作为您的助记词",self.size]];
                }
            }
            else
            {
                //不存在
                [self.selectedArray addObject:selectedObj];
                [self.topCollectionView changeTitle:self.selectedArray];
                self.bottomCollectionView.selectedArray = self.selectedArray;
            }
        }
    }
}

-(UIButton *)createBtn{
    if (!_createBtn) {
        _createBtn = [[UIButton alloc] init];
        [_createBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_createBtn setTitleColor:UG_WhiteColor forState:UIControlStateNormal];
        [_createBtn setBackgroundColor:HEXCOLOR(0x6684c7)];
        _createBtn.titleLabel.font = UG_AutoFont(16);
        [_createBtn addTarget:self action:@selector(createButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
}

#pragma mark- 创建
-(void)createButton{
    if (self.selectedArray.count <=0) {
        [self.view ug_showToastWithToast : @"请选择您的助记词"];
        return;
    }

    if (self.isfromRegister && self.selectedArray.count != [self.size doubleValue]) {
        [self.view ug_showToastWithToast: [NSString stringWithFormat:@"请选择%@个词组作为您的助记词",self.size]];
        return;
    }
    NSString *string = [self.selectedArray componentsJoinedByString:@","];
    if (self.isfromRegister) {
        NSString *des = [NSString stringWithFormat:@"您的助记词顺序为%@，请您确认已完成记忆，确认后将自动保存到相册，无法重新选择",string];
        __weak typeof(self) weakSelf = self;
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"助记词确认" message:des cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                if (buttonIndex == 1) {
                    [weakSelf.view ug_showMBProgressHudOnKeyWindow];
                    UGSubmitUserAuxiliariesApi *api = [UGSubmitUserAuxiliariesApi new];
                    api.userAuxiliaries = string;
                    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
                        [weakSelf.view ug_hiddenMBProgressHudOnKeyWindow];
                        if (object) {
                            [weakSelf.view ug_showToastWithToast:@"助记词提交成功"];
                            //自动保存助记词到手机相册
                            [weakSelf saveAuxiliaries];
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                if (weakSelf.isRegister) {
                                    weakSelf.isSeting = YES;
                                    [weakSelf.navigationController popViewControllerAnimated:NO];
                                } else {
                                    if (self.backlClick) {
                                        weakSelf.isSeting = YES;
                                    }
                                    [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
                                }
                            });
                        }else{
                            [weakSelf.view ug_showToastWithToast:apiError.desc];
                        }
                    }];
                }
        }];
    }else{
        UGCheckUserAuxiliariesApi *api = [UGCheckUserAuxiliariesApi new];
        api.userAuxiliaries = string;
        api.username = self.username;
        __weak typeof(self) weakSelf = self;
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (object) {
                  [weakSelf.view ug_showToastWithToast:@"校验成功"];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self gotoNext];
                });
            }else{
                 [weakSelf.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }
}

- (void) saveAuxiliaries{
    //定义相册保存模板
    UIImage *img = [UG_MethodsTool getContentImageWithTargetView:[self createAuxiliariesUI]];
    if (img) {
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    };
}

//保存完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [self.view ug_showToastWithToast:@""];
    }
}

-(UIView *)createAuxiliariesUI{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(375))/2.0, (UG_SCREEN_HEIGHT-UG_AutoSize(485)) / 2.0, UG_AutoSize(375), UG_AutoSize(485))];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, UG_AutoSize(200))];
    image.image = [UIImage imageNamed:@"auxiliaries_bg"];
    [backView addSubview:image];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+UG_AutoSize(15), backView.frame.size.width, UG_AutoSize(35))];
    title.font = UG_AutoFont(22);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UG_BlackColor;
    title.text = @"UG钱包助记词";
    [backView addSubview:title];
    
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(24), CGRectGetMaxY(title.frame)+UG_AutoSize(15), backView.frame.size.width, UG_AutoSize(20))];
    subtitle.font = UG_AutoFont(15);
    subtitle.textColor = [UIColor colorWithHexString:@"666666"];
    subtitle.text =[NSString stringWithFormat:@"账号：%@",[UGManager shareInstance].hostInfo.userInfoModel.member.registername];
    [backView addSubview:subtitle];
    
    UILabel *subtitle2 = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(24), CGRectGetMaxY(subtitle.frame)+UG_AutoSize(10), backView.frame.size.width, UG_AutoSize(20))];
    subtitle2.font = UG_AutoFont(15);
    subtitle2.textColor = [UIColor colorWithHexString:@"666666"];
    subtitle2.text =@"您的助记词：";
    [backView addSubview:subtitle2];
    
    if ( ! UG_CheckArrayIsEmpty(self.selectedArray) && self.selectedArray.count>0) {
        for (NSInteger i = 0; i < self.selectedArray.count; i ++) {
            NSString *obj = self.selectedArray[i];
            NSInteger X = i % 4;
            NSInteger Y = i / 4;
            NSInteger kMagin = UG_AutoSize(6);
            CGFloat width = (backView.frame.size.width - 3* kMagin-2*UG_AutoSize(24)) / 4;
            CGFloat height = UG_AutoSize(33);
            UILabel *labe = [[UILabel alloc] initWithFrame: CGRectMake(UG_AutoSize(24)+ (kMagin + width) * X , CGRectGetMaxY(subtitle2.frame) + UG_AutoSize(15) + (kMagin + height) * Y, width, height)];
            labe.font = UG_AutoFont(13);
            labe.numberOfLines = 0;
            labe.textColor = UG_MainColor;
            labe.layer.borderWidth = 1;
            labe.layer.borderColor = UG_MainColor.CGColor;
            labe.layer.cornerRadius = 6;
            labe.layer.masksToBounds = YES;
            labe.text = obj;
            labe.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:labe];
        }
    }
    UILabel *bottomtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subtitle2.frame)+3*UG_AutoSize(33)+2*UG_AutoSize(6)+UG_AutoSize(20), backView.frame.size.width, UG_AutoSize(20))];
    bottomtitle.font = UG_AutoFont(14);
    bottomtitle.textColor = [UIColor colorWithHexString:@"666666"];
    bottomtitle.text =@"请您妥善保管";
    bottomtitle.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:bottomtitle];
    return backView;
}


-(void)gotoNext{
    if ( self.isPayPassword) {
        //支付密码
        UGReviseWalletPasswordVC *vc = [UGReviseWalletPasswordVC new];
        vc.topVC = self.topVC;
        vc.isAuxiliaries = YES;
        NSString *string = [self.selectedArray componentsJoinedByString:@","];
        vc.auxiliaries = string;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self resetLoginPasswordConfirmAction];
    }
}

-(void)dealloc{
    if (self.isSeting) {
        if (self.backlClick) {
            self.backlClick();
        }
    }
    if (self.isBack) {
        [[UGManager shareInstance] signout:^{
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"注册返回成功" object:nil userInfo: self.isUserName ?  @{@"type" : @"1"} : @{@"type" : @"0"}];
    }
}

@end
