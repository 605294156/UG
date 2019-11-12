//
//  OTCComplaintViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCComplaintViewController.h"
#import "OTCComplaintingViewController.h"
#import "OTCComplaintInputTextFieldCell.h"
#import "OTCComplaintInputTextViewCell.h"
#import "OTCComplaintPhotoCell.h"
#import "UGButton.h"
#import "OTCComplaintModel.h"
#import "UGOTCAppealApi.h"
#import "UGUploadImageRequest.h"
#import "OTCComplaintSelectedCountryCell.h"
#import "UGCountryPopView.h"
#import "UGGetAreaCodeApi.h"
#import "UGAreaModel.h"
#import "UGAnewAppealApi.h"

@interface OTCComplaintViewController ()

@property (nonatomic, strong) dispatch_queue_t uploatHeadImageQueue;
@property(nonatomic,assign)NSInteger popSelectedIndex;
@property(nonatomic,copy)NSString *popSelectedTitle;
@property(nonatomic,strong)NSArray *areaArray;//区号数组
@property(nonatomic,strong)NSMutableArray *areaTitles;
@property(nonatomic,strong)UGCountryPopView *countryPopView;
@property(nonatomic,assign)BOOL hasShow;
@property (nonatomic,strong)OTCComplaintSelectedCountryCell *selectedCountryCell;
@end

@implementation OTCComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申诉";
    [self registerNibCell:@[[OTCComplaintInputTextFieldCell class], [OTCComplaintInputTextViewCell class], [OTCComplaintPhotoCell class],[OTCComplaintSelectedCountryCell class]]];
    [self initDataSource];
    self.uploatHeadImageQueue = dispatch_queue_create("com.bibei.uploatComplaintImageQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    self.popSelectedIndex = 0;

    self.popSelectedTitle = self.reApeal ? self.orderDetailModel.appeal.country :[UGManager shareInstance].hostInfo.userInfoModel.member.country;
    
    [self getAreaRequest];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
}
    
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   CGRect frame = CGRectMake(14, 60+[UG_MethodsTool navigationBarHeight], UG_SCREEN_WIDTH-28, 60);
    [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
    if (self.selectedCountryCell) {
            [self.selectedCountryCell.countryBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
    }
    self.hasShow = NO;
}

-(void)getAreaRequest{
    
    [self loadAreaDataFromCache];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UGGetAreaCodeApi *api = [[UGGetAreaCodeApi alloc] init];
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (object) {
                [UG_MethodsTool toCreateUGAreacodePlistWith:object];
                self.areaArray = [UGAreaModel mj_objectArrayWithKeyValuesArray:object];
                [self reSetAreaArrayData];
                
            }else{
                
                [self loadAreaDataFromCache];
            }
        }];
    });

}

#pragma mark - 从缓存读取国家国家列表数据
-(void)loadAreaDataFromCache
{
    if ([UG_MethodsTool GetAreacodeArrayFromPlist].count)
    {
        NSArray *array = [UG_MethodsTool GetAreacodeArrayFromPlist];
        self.areaArray = [UGAreaModel mj_objectArrayWithKeyValuesArray:array];
        [self reSetAreaArrayData];
    }
}

#pragma mark - 设置areaArrays的数据
-(void)reSetAreaArrayData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.areaArray.count > 0) {
            UGAreaModel *model = self.areaArray[0];
            NSString *countryStr =self.reApeal ? self.orderDetailModel.appeal.country : [UGManager shareInstance].hostInfo.userInfoModel.member.country;
            self.popSelectedTitle = ! UG_CheckStrIsEmpty(countryStr) ? countryStr : model.zhName;
            for (OTCComplaintModel *models in self.dataSource) {
                if ([models.title isEqualToString:@"国家/地区"]) {
                    models.value = self.popSelectedTitle;
                }
                if ([models.placeholder isEqualToString:@"请输入您的手机号"]) {
//                    models.title = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
                }
            }
        }
        self.areaTitles = [[NSMutableArray alloc] init];
        if (self.areaArray.count>0) {
            for (UGAreaModel *item in self.areaArray) {
                [self.areaTitles addObject:item.zhName];
            }
        }
    });

}

-(void)hidenTextField{
    [self.view endEditing:NO];
}
    
#pragma mark -选择国家
- (void)selectedCountry{
    [self hidenTextField];
    if (self.areaTitles.count>0) {
        if (! UG_CheckStrIsEmpty(self.popSelectedTitle)) {
            for (int i = 0 ; i<self.areaTitles.count ;  i++) {
                if ([self.areaTitles[i] isEqualToString:self.popSelectedTitle]) {
                    self.popSelectedIndex = i;
                }
            }
        }
        CGRect frame = CGRectMake(14, 60+[UG_MethodsTool navigationBarHeight], UG_SCREEN_WIDTH-28, 60);
        if (!self.hasShow) {
            @weakify(self);
            if (!self.countryPopView) {
                self.countryPopView = [[UGCountryPopView alloc] initWithFrame:frame WithArr:self.areaTitles WithIndex:self.popSelectedIndex WithHandle:^(NSString * _Nonnull title, NSInteger index){
                    @strongify(self);
                    self.popSelectedIndex = index;
                    self.popSelectedTitle = title;
                    for (OTCComplaintModel *model in self.dataSource) {
                     if ([model.title isEqualToString:@"国家/地区"]) {
                            model.value = title;
                        }
                        if ([model.placeholder isEqualToString:@"请输入您的手机号"]) {
//                            model.title = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
                            model.value = @"";
                        }
                    }
                    self.hasShow = NO;
                    [self.selectedCountryCell.countryBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:self.countryPopView];
            }else{
                [self.countryPopView showDropDownMenuWithBtnFrame:frame];
            }
            self.countryPopView.index = self.popSelectedIndex;
            [self.selectedCountryCell.countryBtn setImage:[UIImage imageNamed:@"selectedcountry"] forState:UIControlStateNormal];
            self.hasShow = YES;
        }else{
            [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
            [self.selectedCountryCell.countryBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
            self.hasShow = NO;
        }
    }
    else
    {
        [self getAreaRequest];
    }
}

-(NSString *)returenAreaCode:(NSString *)country{
    for (UGAreaModel *item in self.areaArray) {
        if ([item.zhName isEqualToString:country]) {
            return item.areaCode;
        }
    }
    return @"";
}

- (void)initDataSource {
    NSArray *array = [OTCComplaintModel mj_objectArrayWithFilename:@"XList.plist"];
    //默认且不让更改
    for (OTCComplaintModel *model in array) {
        if ([model.title isEqualToString:@"姓名"]) {
            model.value = self.reApeal ? self.orderDetailModel.appeal.initiatorRealName : [UGManager shareInstance].hostInfo.userInfoModel.member.realName;
        } else if ([model.title isEqualToString:@"申诉订单"]) {
            model.value = self.orderSn;
        }else if ([model.title isEqualToString:@"国家/地区"]) {
            model.value = self.reApeal ? self.orderDetailModel.appeal.country : [UGManager shareInstance].hostInfo.userInfoModel.member.country;
        }else if ([model.placeholder isEqualToString:@"请输入您的手机号"]) {
//            model.title = [NSString stringWithFormat:@"+%@",self.reApeal ? self.orderDetailModel.appeal.areaCode : [UGManager shareInstance].hostInfo.userInfoModel.member.areaCode];
            model.value = self.reApeal ? self.orderDetailModel.appeal.mobile : [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone;
        }else if ([model.title isEqualToString:@"申诉描述"] && self.reApeal) {
            model.value = self.orderDetailModel.appeal.remark;
        }else if ([model.title isEqualToString:@"上传凭证"] && self.reApeal) {
            NSArray *photos = [NSArray new];
            if (self.orderDetailModel.appeal && ! UG_CheckStrIsEmpty(self.orderDetailModel.appeal.imgUrls)) {
                photos = [self.orderDetailModel.appeal.imgUrls componentsSeparatedByString:@","];
            }
            if (photos.count >0) {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (NSString *url in photos) {
                    NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    UIImage *img = [UIImage imageWithData:resultData];
                    [arr addObject:img];
                }
                model.imagelist = [NSArray arrayWithArray:arr];
            }
        }
    }
    self.dataSource = array.copy;
}

- (void)registerNibCell:(NSArray * )cellList {
    for (Class aClass in cellList) {
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(aClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(aClass)];
    }
}

- (void)setupTableView {
    UGButton *submitButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleBlue];
    [submitButton setTitle:@"提交申诉" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitComplaint:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-10 - UG_SafeAreaBottomHeight);
//        make.centerX.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(240, 44));
        make.height.equalTo(@44);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(submitButton.mas_top).mas_offset(-20);
    }];
    [self.view bringSubviewToFront:submitButton];
}

- (BOOL)hasHeadRefresh {
    return NO;
}

- (BOOL)hasFooterRefresh {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OTCComplaintModel *mode = self.dataSource[indexPath.section];
    
    if ([mode.cellType isEqualToString:@"1"]) {
        OTCComplaintInputTextViewCell *textViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OTCComplaintInputTextViewCell class]) forIndexPath:indexPath];
        textViewCell.model = mode;
        return textViewCell;
        
    } else if ([mode.cellType isEqualToString:@"2"]) {
        OTCComplaintPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OTCComplaintPhotoCell class]) forIndexPath:indexPath];
        photoCell.model = mode;
        @weakify(self);
        photoCell.tapPhotosHandle = ^(UIButton * _Nonnull addButton) {
            @strongify(self);
            if (mode.imagelist.count== 3) { [self.view  ug_showToastWithToast:@"图片最多选取3张"]; return;}
            [self showTakePhotoChooseWithMaxCount:3 - mode.imagelist.count WithPoto:YES handle:^(NSArray <UIImage *>*imageList) {
                if (imageList) {
                    //内部使用了KVO，改动数据源即可
                    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:imageList];
                    [array addObjectsFromArray:mode.imagelist];
                    mode.imagelist = array;
                }
            }];

        };
        return photoCell;
    }
//    else if ([mode.cellType isEqualToString:@"3"]) {
//        self.selectedCountryCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OTCComplaintSelectedCountryCell class]) forIndexPath:indexPath];
//        self.selectedCountryCell.model = mode;
//        [ self.selectedCountryCell.countryFiled setEnabled:NO];
//        @weakify(self);
//        self.selectedCountryCell.tapBtnsHandle = ^{
//            @strongify(self);
//            [self selectedCountry];
//        };
//        return  self.selectedCountryCell;
//    }
    OTCComplaintInputTextFieldCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OTCComplaintInputTextFieldCell class]) forIndexPath:indexPath];
    textFieldCell.model = mode;
    return textFieldCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0:
        case 1:
        case 2:
//        case 3:
            height = 44.0f;
            break;
        case 3:
            height = 182.0f;
            break;
        default:
            height = 134.0f;
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3 || section == 4) {
        return 10.0f;
    }
    return section == 5 ? CGFLOAT_MIN : 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0 || section==3) {
        return 10.f;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == 3 || section == 4) {
        view.backgroundColor = [UIColor clearColor];
    } else{
        view.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    return view;
}

//提交申诉
- (void)submitComplaint:(UGButton *)sender {
    
    BOOL fishied = YES;
    NSString *desc = @"";
    for (OTCComplaintModel *mode in self.dataSource) {
        //不是图片选取类型
        BOOL mustInput = ![mode.cellType isEqualToString:@"2"];
//        if (mustInput && [mode.placeholder isEqualToString:@"请输入您的手机号"] && mode.value.length > 0 && ![UG_MethodsTool checkPhone:mode.value]) {
//            fishied = NO;
//            desc = @"请输入正确的手机号";
//            break;
//        }else
        if (mustInput && mode.value.length == 0) {
            fishied = NO;
            desc = mode.placeholder;
            break;
        }
    }
    
    if (fishied == NO) {
        [self.view ug_showToastWithToast:desc];
        return;
    }
    
    //用户选取的图片
    OTCComplaintModel *mode = self.dataSource.lastObject;
    NSArray <UIImage *>*imageList = mode.imagelist;
    
    if (imageList.count <= 0) {
        [self.view ug_showToastWithToast:@"请上传您的图片凭证"];
        return;
    }
    
    //填写信息
    NSString *appealRealName = ((OTCComplaintModel *)self.dataSource[0]).value;
    //申诉人联系电话
    NSString *appealMobile = ((OTCComplaintModel *)self.dataSource[2]).value;
    //申诉描述
    NSString *appealRemark = ((OTCComplaintModel *)self.dataSource[4]).value;
    
    //有图片先传图片
    if (imageList.count > 0) {
        [self uploadImages:imageList appealRealName:appealRealName appealMobile:appealMobile appealRemark:appealRemark];
    } else {
        //无图片直接调接口
        if (self.reSubmit) {
             [self reSendRequest:nil appealRealName:appealRealName appealMobile:appealMobile appealRemark:appealRemark];
        }else{
          [self sendRequest:nil appealRealName:appealRealName appealMobile:appealMobile appealRemark:appealRemark];
        }
    }
}


//上传图片
- (void)uploadImages:(NSArray <UIImage *>*)imageList appealRealName:(NSString *)appealRealName appealMobile:(NSString *)appealMobile appealRemark:(NSString *)appealRemark {
    
    [MBProgressHUD ug_showHUDToKeyWindow];

    dispatch_async(self.uploatHeadImageQueue, ^{
        dispatch_group_t uploadGroup = dispatch_group_create();
       __block  NSMutableArray *urlArray = [NSMutableArray new];
        for (UIImage *image in imageList) {
            dispatch_group_enter(uploadGroup);
            dispatch_group_async(uploadGroup, self.uploatHeadImageQueue, ^(){
                //上传图片到服务器拿到图片URL
                [[[UGUploadImageRequest alloc] initWithImage:image] ug_startWithCompletionBlock:^(UGApiError * _Nonnull apiError, id  _Nonnull object) {
                    if (object && [object isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *dic = [NSMutableDictionary new];
                        [dic addEntriesFromDictionary:object];
                        NSArray *arr =[NSMutableArray arrayWithArray:[dic allValues]];
                        if (arr.count>0) {
                            [urlArray addObject:arr[0]];
                        }
                    }
                    dispatch_group_leave(uploadGroup);
                }];
            });
        }
        dispatch_group_notify(uploadGroup, self.uploatHeadImageQueue, ^(){
            if (self.reSubmit) {
                  [self reSendRequest:[urlArray componentsJoinedByString:@","] appealRealName:appealRealName appealMobile:appealMobile appealRemark:appealRemark];
            }else{
                  [self sendRequest:[urlArray componentsJoinedByString:@","] appealRealName:appealRealName appealMobile:appealMobile appealRemark:appealRemark];
            }
        });
    });
}

//申诉接口
- (void)sendRequest:(NSString *)imageUrls appealRealName:(NSString *)appealRealName appealMobile:(NSString *)appealMobile appealRemark:(NSString *)appealRemark {
    if (imageUrls == nil) {
        [MBProgressHUD ug_showHUDToKeyWindow];
    }
    UGOTCAppealApi *api = [UGOTCAppealApi new];
    api.imgUrls = imageUrls;
    api.orderSn = self.orderSn;
    api.appealRealName = appealRealName;
    api.mobile = appealMobile;
    api.remark = appealRemark;
    api.country = self.popSelectedTitle;
    api.areaCode = [self returenAreaCode:self.popSelectedTitle];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"申诉成功"];
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                OTCComplaintingViewController *vc =  [OTCComplaintingViewController new];
                vc.orderSn = self.orderSn;
                [self.navigationController pushViewController:vc animated:YES];
            });
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

//重新申诉接口
- (void)reSendRequest:(NSString *)imageUrls appealRealName:(NSString *)appealRealName appealMobile:(NSString *)appealMobile appealRemark:(NSString *)appealRemark {
    if (imageUrls == nil) {
        [MBProgressHUD ug_showHUDToKeyWindow];
    }
    UGAnewAppealApi *api = [UGAnewAppealApi new];
    api.imgUrls = imageUrls;
    api.orderSn = self.orderSn;
    api.appealRealName = appealRealName;
    api.mobile = appealMobile;
    api.remark = appealRemark;
    api.country = self.popSelectedTitle;
    api.areaCode = [self returenAreaCode:self.popSelectedTitle];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"重新申诉成功 ！"];
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                OTCComplaintingViewController *vc =  [OTCComplaintingViewController new];
                vc.orderSn = self.orderSn;
                [self.navigationController pushViewController:vc animated:YES];
            });
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}


- (void)dealloc {
    NSLog(@"OTCComplaintViewController释放了");
}

@end
