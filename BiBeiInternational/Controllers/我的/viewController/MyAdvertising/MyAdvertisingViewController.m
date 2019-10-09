//
//  MyAdvertisingViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/3/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyAdvertisingViewController.h"
#import "MyAdvertisingTableViewCell.h"
#import "MineNetManager.h"
#import "MyAdvertisingModel.h"
#import "MyAdvertisingAlterView.h"
#import "MyAdvertisingDetailModel.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"

@interface MyAdvertisingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    MyAdvertisingAlterView *_myAdvertisingAlterView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,strong)NSMutableArray *myAdvertisingArr;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,strong)MyAdvertisingModel *infoModel;
@property(nonatomic,strong)MyAdvertisingDetailModel *detailModel;
@property(nonatomic,strong)NSIndexPath *deleteIndex;//删除交易的index
@property(nonatomic,assign)NSInteger pageNo;
@end

@implementation MyAdvertisingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"myAdvertising");
//    [self backBtnNoNavBar:NO normalBack:YES];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyAdvertisingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyAdvertisingTableViewCell class])];
    self.userName = [UGManager shareInstance].hostInfo.username;
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noAdvertisingTip") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
    [self setupRefesh];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageNo = 1;
    [self getData];
}

//MARK:--设置刷新头尾
- (void)setupRefesh {
    @weakify(self);
    [self.tableView setupHeaderRefesh:^{
        @strongify(self);
        [self refreshHeaderAction];
    }];
    
    [self.tableView setupNomalFooterRefesh:^{
        @strongify(self);
        [self refreshFooterAction];
    }];
}


//MARK:--上拉加载
- (void)refreshFooterAction{
    [self getData];
}

//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1;
    [self getData];
}
//MARK:--获取交易数据信息
-(void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    [MineNetManager getMyAdvertisingForPageNo:pageNoStr withPageSize:@"10" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                if (self->_pageNo == 1) {
                    [self.myAdvertisingArr removeAllObjects];
                }
                NSLog(@"--%@",resPonseObj);
                NSArray *dataArr = [MyAdvertisingModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"content"]];
                //结束刷新状态
                [self.tableView endRefreshingWithNoMoreData: self.pageNo == 0 ? NO : ( dataArr.count >0 ?  : NO)];
                [self.myAdvertisingArr addObjectsFromArray:dataArr];
                [self.tableView reloadData];
                //页码++
                self.pageNo++;
                
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                [self.tableView endRefreshingWithNoMoreData:NO];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
            [self.tableView endRefreshingWithNoMoreData:NO];
        }
    }];
}
- (NSMutableArray *)myAdvertisingArr {
    if (!_myAdvertisingArr) {
        _myAdvertisingArr = [NSMutableArray array];
    }
    return _myAdvertisingArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myAdvertisingArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAdvertisingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAdvertisingTableViewCell class]) forIndexPath:indexPath];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyAdvertisingModel *model = _myAdvertisingArr[indexPath.row];
    cell.userName.text = self.userName;
    cell.payMode.text = @"";
    if ([model.advertiseType isEqualToString:@"0"]) {
        //购买
        cell.advertisingType.text = LocalizationKey(@"buy");
        cell.advertisingType.backgroundColor=GreenColor;
    }else{
        cell.advertisingType.text = LocalizationKey(@"sell");
        cell.advertisingType.backgroundColor=RedColor;
    }
    if ([model.status isEqualToString:@"0"]) {
        cell.statusLabel.text=LocalizationKey(@"grounding");
    }else{
        cell.statusLabel.text=LocalizationKey(@"shelved");
    }
    cell.limitNum.text = [NSString stringWithFormat:@"%@%@-%@CNY",LocalizationKey(@"limit"),model.minLimit,model.maxLimit];
    cell.coinNum.text = [NSString stringWithFormat:@"%@%@",[ToolUtil formartScientificNotationWithString:model.remainAmount],model.coin.unit];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAdvertisingModel *model = _myAdvertisingArr[indexPath.row];
    self.infoModel = model;
    [self myAdvertisingAlterView];
}
// UITableViewDataSource协议中定义的方法。该方法的返回值决定某行是否可编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// 自定义左滑显示编辑按钮
- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:LocalizationKey(@"delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"删除");
        self.deleteIndex = indexPath;
        
        MyAdvertisingModel *model = self->_myAdvertisingArr[indexPath.row];
        if ([model.status isEqualToString:@"0"]) {
            //上架交易，可以下架
            [self.view ug_showToastWithToast:LocalizationKey(@"deleteShelvesAdvertiseTip")];
        }else{
            //删除交易
            [self deleteAdvertiseInfo:model.ID];
        }
        //取消编辑状态
        [tableView setEditing:NO animated:YES];
    }];
    NSArray *arr = @[rowAction];
    return arr;
}

//MARK:--删除交易接口
-(void)deleteAdvertiseInfo:(NSString *)advertiseId{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager deleteAdvertiseForAdvertiseId:advertiseId CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSLog(@"--%@",resPonseObj);
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->_myAdvertisingArr removeObjectAtIndex:self.deleteIndex.row];
                        [self->_tableView reloadData];
                    });
                });
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
           [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}

//MARK:--点击交易弹出的提示框
-(void)myAdvertisingAlterView{
    if (!_myAdvertisingAlterView) {
        _myAdvertisingAlterView = [[NSBundle mainBundle] loadNibNamed:@"MyAdvertisingAlterView" owner:nil options:nil].firstObject;
        _myAdvertisingAlterView.frame=[UIScreen mainScreen].bounds;
        [_myAdvertisingAlterView.cancelButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_myAdvertisingAlterView.changeButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_myAdvertisingAlterView.backOnButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([self.infoModel.status isEqualToString:@"0"]) {
        //上架交易，可以下架
        [_myAdvertisingAlterView.backOnButton setTitle:LocalizationKey(@"shelves") forState:UIControlStateNormal];
    }else{
        [_myAdvertisingAlterView.backOnButton setTitle:LocalizationKey(@"Added") forState:UIControlStateNormal];
    }
    _myAdvertisingAlterView.limitNum.text = [NSString stringWithFormat:@"%@-%@CNY",self.infoModel.minLimit,self.infoModel.maxLimit];
    _myAdvertisingAlterView.totalNum.text = [NSString stringWithFormat:@"%@%@",self.infoModel.remainAmount,self.infoModel.coin.unit];
   [UIApplication.sharedApplication.keyWindow addSubview:_myAdvertisingAlterView];
    
}
-(void)push:(UIButton*)button{
    
    [_myAdvertisingAlterView removeFromSuperview];
    if (button.tag == 1) {
        //修改
        if ([self.infoModel.status isEqualToString:@"0"]) {
            //上架
            [self.view ug_showToastWithToast:LocalizationKey(@"shelvesTip")];
            return ;
        }else{
            //修改
            [self changeAdvertising];
        }
    }else if (button.tag == 2){
        if ([self.infoModel.status isEqualToString:@"0"]) {
            //下架交易
            [self downAdvertising];
        }else{
            //上架交易
            [self upAdvertising];
        }
    }else if (button.tag == 3){
        //取消
        //[_myAdvertisingAlterView hideView];
    }
}
//MARK:--修改交易
-(void)changeAdvertising{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getMyAdvertisingDetailInfoForAdvertisingId:self.infoModel.ID CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSLog(@"--%@",resPonseObj);
                self.detailModel = [MyAdvertisingDetailModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                [self->_myAdvertisingAlterView removeFromSuperview];
                if ([self.detailModel.advertiseType isEqualToString:@"0" ]) {
                    //购买交易  进入购买交易编辑界面
                    AdvertisingBuyViewController *buyVC = [[AdvertisingBuyViewController alloc] init];
                    buyVC.index = 1;
                    buyVC.detailModel = self.detailModel;
                    [self.navigationController pushViewController:buyVC animated:YES];
                }else{
                    //出售交易  进入出售交易编辑界面
                    AdvertisingSellViewController *sellVC = [[AdvertisingSellViewController alloc] init];
                    sellVC.index = 1;
                    sellVC.detailModel = self.detailModel;
                    [self.navigationController pushViewController:sellVC animated:YES];
                }
            }else{
                [UIApplication.sharedApplication.keyWindow ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [UIApplication.sharedApplication.keyWindow ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//MARK:--上架交易
-(void)upAdvertising{
    [EasyShowLodingView showLodingText:LocalizationKey(@"AddingAdvertiseTip")];
    [MineNetManager upMyAdvertisingForAdvertisingId:self.infoModel.ID CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view ug_showToastWithToast:LocalizationKey(@"addAdvertiseSuccessTip")];
                [self->_myAdvertisingAlterView removeFromSuperview];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getData];
                    });
                });
                
            }else{
                [UIApplication.sharedApplication.keyWindow ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [UIApplication.sharedApplication.keyWindow ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//MARK:--下架交易
-(void)downAdvertising{
    [EasyShowLodingView showLodingText:LocalizationKey(@"shelvesAdvertiseTip")];
    [MineNetManager downMyAdvertisingForAdvertisingId:self.infoModel.ID CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.view ug_showToastWithToast:LocalizationKey(@"shelvesAdvertiseSuccessTip")];
                [self->_myAdvertisingAlterView removeFromSuperview];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self getData];
                    });
                });
            }else{
                [UIApplication.sharedApplication.keyWindow ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [UIApplication.sharedApplication.keyWindow ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

