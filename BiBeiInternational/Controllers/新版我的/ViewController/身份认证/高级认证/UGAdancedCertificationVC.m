//
//  UGAdancedCertificationVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdancedCertificationVC.h"
#import "UGButton.h"
#import "UGAdancedCertificationCell.h"
#import "UGAdancedCertificationModel.h"
#import "UGHighValidApi.h"
#import "UGCertificationUploadImageApi.h"
#import "MJPhotoBrowser.h"
#import "UGContentInsetLabel.h"

#import "UGAdancedCertificationOneCell.h"
#import "UGAdancedCertificationTwoCell.h"
#import "UGAdancedCertificationThreeCell.h"

@interface UGAdancedCertificationVC ()

@property (nonatomic, strong) dispatch_queue_t uploatHeadImageQueue;

@property (nonatomic, strong) UGButton *submitButton;

@end

@implementation UGAdancedCertificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"高级认证";
    self.tableView.rowHeight = 148.0f;
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAdancedCertificationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAdancedCertificationCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAdancedCertificationOneCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAdancedCertificationOneCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAdancedCertificationTwoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAdancedCertificationTwoCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAdancedCertificationThreeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAdancedCertificationThreeCell class])];
    [self initData];
    self.uploatHeadImageQueue = dispatch_queue_create("com.bibei.uploatHighValidImageQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    //非认证通过
    if (![[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"2"]) {
        [self setupTableViewHeadView];
    }
}

- (void)initData {
    self.dataSource = [UGAdancedCertificationModel mj_objectArrayWithFile:[[NSBundle mainBundle] pathForResource:@"UGAdancedCertification" ofType:@"plist"]].copy;
    //已经提交过认证
    if ([UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus != nil) {
        UGApplication *applicationModel = [UGManager shareInstance].hostInfo.userInfoModel.application;
        NSArray *list = @[applicationModel.identityCardImgFront ? : @"", applicationModel.identityCardImgReverse ? : @"", applicationModel.identityCardImgInHand ? : @""];
        [self.dataSource enumerateObjectsUsingBlock:^(UGAdancedCertificationModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.submitImageUrlStr = list[idx];
        }];
    }
    
    //隐藏认证按钮
    self.submitButton.hidden = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"0"] || [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"2"];
}

- (void)setupTableView {
    self.submitButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleBlue];
    [self.submitButton setTitle: [self adancedCertificationFailure] ? @"重新认证" : @"提交认证" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-20 - UG_SafeAreaBottomHeight);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(240, 46));
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(self.submitButton.mas_top).mas_offset(-20);
    }];
}

- (void)setupTableViewHeadView {
   UGContentInsetLabel *titleLabel = [UGContentInsetLabel new];
    titleLabel.ug_contentInset = UIEdgeInsetsMake(16, 14, 16, 14);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self adancedCertificationFailure] ? [NSString stringWithFormat:@"审核失败原因：%@",[UGManager shareInstance].hostInfo.userInfoModel.application.rejectReason]  :  @"后台将在1-3个工作日完成审核，请您耐心等待！";
    titleLabel.textColor = [UIColor colorWithHexString:@"F96A0E"];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:13];
    CGSize sizeToFit = [titleLabel sizeThatFits:CGSizeMake(self.view.frame.size.width-36, MAXFLOAT)];
    titleLabel.frame = CGRectMake(36, 0, sizeToFit.width, sizeToFit.height);
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, sizeToFit.height)];
    viewBack.backgroundColor = [UIColor colorWithHexString:@"FAF6CB"];
    [viewBack addSubview:titleLabel];
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(28, (sizeToFit.height-15) / 2.0, 15, 15)];
    imag.image = [UIImage imageNamed:@"verify_tishi"];
    [viewBack addSubview:imag];
    self.tableView.tableHeaderView = viewBack;
}


/**
 高级认证是否失败

 @return 认证结果
 */
- (BOOL)adancedCertificationFailure {
    return [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
}

- (BOOL)hasHeadRefresh {
    return NO;
}

- (BOOL)hasFooterRefresh {
    return NO;
}

#pragma mark - 提交认证

- (void)clickSubmit:(UGButton *)sender {
    
    for (UGAdancedCertificationModel *mode in self.dataSource) {
        if (mode.value.length == 0 ) {
            [self.view ug_showToastWithToast:[NSString stringWithFormat:@"请上传%@！",mode.title]];
            return;
        }
    }
    //上传图片
    [self updateImagesRequest];
    
}


#pragma mark - Request
//上传图片
- (void)updateImagesRequest {
    
    [MBProgressHUD ug_showHUDToKeyWindow];
    
    dispatch_async(self.uploatHeadImageQueue, ^{
        
        dispatch_group_t uploadGroup = dispatch_group_create();
        
        __block NSMutableDictionary *imageUlrDict = [NSMutableDictionary new];
        
        for (int i = 0; i < self.dataSource.count; i ++) {
            
            dispatch_group_enter(uploadGroup);
            
            dispatch_group_async(uploadGroup, self.uploatHeadImageQueue, ^(){
                
                UGAdancedCertificationModel *mode = self.dataSource[i];

                //文件名
//                NSString *fileName = [mode.title containsString:@"正面"] ? @"frontImg" : [mode.title containsString:@"反面"] ? @"behindImg" : @"inHandImg";
                 NSString *fileName = [mode.title containsString:@"正面"] ? @"verify_defultImage1" : [mode.title containsString:@"反面"] ? @"verify_defultImage2" : @"verify_defultImage3";
                //上传图片到服务器拿到图片URL
                UGCertificationUploadImageApi *uploadImageApi =  [[UGCertificationUploadImageApi alloc] initWithImage:[UIImage imageWithData:mode.value] fileName:fileName];
                
                //手持身份证需要保存到服务器
                if ([mode.title containsString:@"手持"]) {
                    uploadImageApi.saveInServer = YES;
                }
                [uploadImageApi  ug_startWithCompletionBlock:^(UGApiError * _Nonnull apiError, id  _Nonnull object) {
                    if (object && [object isKindOfClass:[NSDictionary class]]) {
                        [imageUlrDict addEntriesFromDictionary:object];
                    } else {
                        NSLog(@"高级认证上传图片失败：%@",apiError.desc);
                    }
                    dispatch_group_leave(uploadGroup);
                }];
                
            });

        }

        dispatch_group_notify(uploadGroup, self.uploatHeadImageQueue, ^(){
            if (imageUlrDict.count == 3) {
//                [self sendRequsetWithUrl:imageUlrDict[@"inHandImg"] frontImg:imageUlrDict[@"frontImg"] behindImg:imageUlrDict[@"behindImg"]];
                 [self sendRequsetWithUrl:imageUlrDict[@"verify_defultImage3"] frontImg:imageUlrDict[@"verify_defultImage1"] behindImg:imageUlrDict[@"verify_defultImage2"]];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD ug_hideHUDFromKeyWindow];
                    [self.view ug_showToastWithToast:@"上传图片失败，重新提交！"];
                });
            }

        });
    });
    
}

//高级认证请求
- (void)sendRequsetWithUrl:(NSString *)inHandImg frontImg:(NSString *)frontImg behindImg:(NSString *)behindImg {
    UGHighValidApi *highValidApi = [UGHighValidApi new];
    highValidApi.inHandImg = inHandImg;
    highValidApi.frontImg = frontImg;
    highValidApi.behindImg = behindImg;
    [highValidApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
             [self.view ug_showToastWithToast:@"您的高级认证已提交成功，请耐心等待审核！"];
            //先更改本地数据，审核中
            [UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus = @"0";
            //更新用户数据
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                
            }];
            if (self.refeshData) {
                self.refeshData();
            }
           
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
//    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
         UGAdancedCertificationModel *mode = self.dataSource[indexPath.section];
        UGAdancedCertificationOneCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGAdancedCertificationOneCell class]) forIndexPath:indexPath];
        cell.model = mode;
        @weakify(self);
        cell.tapPhotosHandle = ^(UIImageView * _Nonnull imageView) {
            @strongify(self);
            [self showTakePhotoChooseWithMaxCount:1 WithPoto:YES handle:^(NSArray<UIImage *> * _Nonnull imageList) {
                if (imageList.count > 0) {
                    //Cell内部使用了KVO监听value不需要reloadData
                    mode.value = [UG_MethodsTool compressImageQuality: imageList.firstObject toByte:1024 * 1024]; //UIImagePNGRepresentation(imageList.firstObject);
                }
            }];
        };
        //放大显示图片
        cell.showPhotosHandle = ^(UIImage * _Nonnull image, BOOL isCheck) {
            if (!isCheck) {
                if (image) {
                    [MJPhotoBrowser showlocalImages:@[image] currentImage:image];
                } else {
                    [MJPhotoBrowser showOnlineImages:@[mode.submitImageUrlStr] currentItem:mode.submitImageUrlStr];
                }
            }else{
                if (image && ![UIImageJPEGRepresentation(image, 1.0)  isEqual:UIImageJPEGRepresentation([UIImage imageNamed:mode.defaultImageName],1.0)]) {
                    [MJPhotoBrowser showlocalImages:@[image] currentImage:image];
                }
            }
        };
        if (self.dataSource.count > 1) {
            UGAdancedCertificationModel *mode2 = self.dataSource[1];
            cell.model2 = mode2;
            @weakify(self);
            cell.tapPhotosTwoHandle = ^(UIImageView * _Nonnull imageView) {
                @strongify(self);
                [self showTakePhotoChooseWithMaxCount:1 WithPoto:YES handle:^(NSArray<UIImage *> * _Nonnull imageList) {
                    if (imageList.count > 0) {
                        //Cell内部使用了KVO监听value不需要reloadData
                        mode2.value = [UG_MethodsTool compressImageQuality: imageList.firstObject toByte:1024 * 1024]; //UIImagePNGRepresentation(imageList.firstObject);
                    }
                }];
            };
            //放大显示图片
            cell.showPhotosTwoHandle= ^(UIImage * _Nonnull image, BOOL isCheck) {
                if (!isCheck) {
                    if (image) {
                        [MJPhotoBrowser showlocalImages:@[image] currentImage:image];
                    } else {
                        [MJPhotoBrowser showOnlineImages:@[mode.submitImageUrlStr] currentItem:mode.submitImageUrlStr];
                    }
                }else{
                    if (image && ![UIImageJPEGRepresentation(image, 1.0)  isEqual:UIImageJPEGRepresentation([UIImage imageNamed:mode.defaultImageName],1.0)]) {
                        [MJPhotoBrowser showlocalImages:@[image] currentImage:image];
                    }
                }
            };
        }
        return cell;
    }else if(indexPath.section == 1){
        UGAdancedCertificationTwoCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGAdancedCertificationTwoCell class]) forIndexPath:indexPath];
        if (self.dataSource.count > 2) {
            UGAdancedCertificationModel *mode = self.dataSource[2];
            cell.model3 = mode;
            @weakify(self);
            cell.tapPhotosHandle = ^(UIImageView * _Nonnull imageView) {
                @strongify(self);
                [self showTakePhotoChooseWithMaxCount:1 WithPoto:NO handle:^(NSArray<UIImage *> * _Nonnull imageList) {
                    if (imageList.count > 0) {
                        //Cell内部使用了KVO监听value不需要reloadData
                        mode.value = [UG_MethodsTool compressImageQuality: imageList.firstObject toByte:1024 * 1024]; //UIImagePNGRepresentation(imageList.firstObject);
                    }
                }];
            };
            //放大显示图片
            cell.showPhotosHandle= ^(UIImage * _Nonnull image, BOOL isCheck) {
                if (!isCheck) {
                    if (image) {
                        [MJPhotoBrowser showlocalImages:@[image] currentImage:image];
                    } else {
                        [MJPhotoBrowser showOnlineImages:@[mode.submitImageUrlStr] currentItem:mode.submitImageUrlStr];
                    }
                }else{
                    if (image && ![UIImageJPEGRepresentation(image, 1.0)  isEqual:UIImageJPEGRepresentation([UIImage imageNamed:mode.defaultImageName],1.0)]) {
                        [MJPhotoBrowser showlocalImages:@[image] currentImage:image];
                    }
                }
            };
        }
        return cell;
    }else if(indexPath.section == 2){
        UGAdancedCertificationThreeCell  *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGAdancedCertificationThreeCell class]) forIndexPath:indexPath];
        return cell;
    }
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 165;
    }else if(indexPath.section == 1){
        return   135;
    }
    return 145;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return section == self.dataSource.count -1 ? CGFLOAT_MIN : 1.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor colorWithHexString:@"#EDEDED"];
//    return view;
//}


@end
