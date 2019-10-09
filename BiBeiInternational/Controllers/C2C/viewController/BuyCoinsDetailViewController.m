//
//  BuyCoinsDetailViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BuyCoinsDetailViewController.h"
#import "SearchViewController.h"
#import "BuyCoinsDetail1TableViewCell.h"
#import "BuyCoinsDetail2TableViewCell.h"
#import "OrderConfirmAlterView.h"
#import "C2CNetManager.h"
#import "BuyOrSellCoinInfo.h"
#import "MineViewController.h"
#import "AppDelegate.h"
#import "UGTabBarController.h"


@interface BuyCoinsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BuyCoinsDetail2TableViewCellDelegate>{
    OrderConfirmAlterView *_orderComfirmAlterView;
}
@property (weak, nonatomic) IBOutlet UIButton *buyButton;//购买按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewheight;
@property (nonatomic,strong)BuyOrSellCoinInfo *model;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)NSString *coinType1Num;//货币1数量
@property(nonatomic,copy)NSString *coinType2Num;//货币2数量
@property(nonatomic,copy)NSString *mode;//计算方式，金额/价格=数量为0，数量*价格=金额为1

@property(nonatomic,strong)UITextField*coinType1NumTF;
@property(nonatomic,strong)UITextField*coinType2NumTF;
@property(nonatomic,strong)NSArray*payArray;//付款方式
@end

@implementation BuyCoinsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.flagindex == 1) {
        //对我而言出售
        self.title = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"sell"),self.unit];
        [self.buyButton setTitle:LocalizationKey(@"sell") forState:UIControlStateNormal];
    }else{
        //对我而言购买
        self.title = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"buy"),self.unit];
        [self.buyButton setTitle:LocalizationKey(@"buy") forState:UIControlStateNormal];
    }
    //[self setNavBarUI];
    [self.view addSubview:self.tableView];
    self.bottomViewheight.constant = SafeAreaBottomHeight;
    // Do any additional setup after loading the view from its nib.
    self.coinType2Num = @"";
    self.coinType1Num = @"";
    [self getBuyAdvertiseInfo];
}
//MARK:--获取购买的交易信息
-(void)getBuyAdvertiseInfo{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [C2CNetManager buyOrSelladvertiseInfoForid:_advertisingId CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"--data--%@",resPonseObj);
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                BuyOrSellCoinInfo *model = [BuyOrSellCoinInfo mj_objectWithKeyValues:resPonseObj[@"data"]];
                self.model = model;
                self.payArray=[model.payMode componentsSeparatedByString:@","];
                [self.tableView reloadData];
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

//MARK:--购买的点击事件
- (IBAction)buyBtnClick:(UIButton *)sender {

    if ([self.coinType1Num isEqualToString:@""] ||[self.coinType2Num isEqualToString:@""]) {
        if (self.flagindex == 1) {
            //对我而言出售
            [self.view ug_showToastWithToast:LocalizationKey(@"inputSellNum")];
        }else{
          [self.view ug_showToastWithToast:LocalizationKey(@"inputBuyNum")];
        }
        return;
    }
    [self orderConfirmAlterView];
}
//MARK:--点击购买弹出的提示框
-(void)orderConfirmAlterView{
    
    if (!_orderComfirmAlterView) {
        _orderComfirmAlterView =  [[NSBundle mainBundle] loadNibNamed:@"OrderConfirmAlterView" owner:nil options:nil].firstObject;
        _orderComfirmAlterView.frame=[UIScreen mainScreen].bounds;
        [_orderComfirmAlterView.cancelButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_orderComfirmAlterView.certainButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    if (self.flagindex == 1) {
        //对我而言出售
        _orderComfirmAlterView.titleLabel1.text= LocalizationKey(@"sellPrice");
        _orderComfirmAlterView.titleLabel2.text= LocalizationKey(@"sellNum") ;
        _orderComfirmAlterView.titleLabel3.text= LocalizationKey(@"sellTotalPrice");
    }else{
        _orderComfirmAlterView.titleLabel1.text= LocalizationKey(@"buyPrice");
        _orderComfirmAlterView.titleLabel2.text= LocalizationKey(@"buyNum");
        _orderComfirmAlterView.titleLabel3.text= LocalizationKey(@"buyTotalPrice");
    }
    _orderComfirmAlterView.buyPrice.text = [NSString stringWithFormat:@"%@元",self.model.price];
    _orderComfirmAlterView.buyNum.text = [NSString stringWithFormat:@"%@%@",self.coinType2Num,self.model.unit];
    _orderComfirmAlterView.buyTotal.text = [NSString stringWithFormat:@"%@元",self.coinType1Num];
    _orderComfirmAlterView.remindContent.text = [NSString stringWithFormat:@"%@%@%@", LocalizationKey(@"placeOrderTip1"),self.model.unit,LocalizationKey(@"placeOrderTip2")];
    CGAffineTransform translates = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    _orderComfirmAlterView.boardView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity,0,_orderComfirmAlterView.boardView.height);
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self->_orderComfirmAlterView.boardView.transform = translates;
        
    } completion:^(BOOL finished) {
        
    }];

    [UIApplication.sharedApplication.keyWindow addSubview:_orderComfirmAlterView];
}
-(void)push:(UIButton*)sender{
    [_orderComfirmAlterView removeFromSuperview];
    if (sender.tag == 1) {
        //取消
        NSLog(@"取消");
    }else if (sender.tag == 2){
        //确定
        NSLog(@"确定");
        [self certainBillAndSubmit];
    }else{
        //其他
    }
}
//MARK:--下单确认提交
-(void)certainBillAndSubmit{
   [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSString *urlStr = @"";
    if (self.flagindex == 1) {
        //对我来说出售
        urlStr = @"otc/order/sell";
    }else{
        //对我来说购买
        urlStr = @"otc/order/buy";
    }
    [C2CNetManager coinSellOrBuyForUrlString:urlStr withAdvertisingId:self.advertisingId withCoinId:self.model.otcCoinId withPrice:self.model.price withMoney:self.coinType1Num withAmount:self.coinType2Num withRemark:self.model.remark withMode:self.mode CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                    [self.navigationController popViewControllerAnimated:YES];
                    
#warning Need To Fix 需要修改，需要放到UGTabBarController里面处理
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    UGTabBarController *tabViewController = (UGTabBarController *) appDelegate.window.rootViewController;
                    [tabViewController setSelectedIndex:3];
                    
//                    MyBillViewController *billVC = [[MyBillViewController alloc] init];
//                    [[tabViewController selectedViewController] pushViewController:billVC animated:YES];
                    
                    
                });
            }else{
               [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-SafeAreaBottomHeight-50-SafeAreaTopHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 68;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"BuyCoinsDetail1TableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BuyCoinsDetail1TableViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:@"BuyCoinsDetail2TableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([BuyCoinsDetail2TableViewCell class])];
       
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BuyCoinsDetail1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BuyCoinsDetail1TableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.headImage == nil || [self.headImage isEqualToString:@""]) {
            cell.headImage.image = [UIImage imageNamed:@"header_defult"];
        }else{
            NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PicHOST,self.headImage]];
            
            [cell.headImage sd_setImageWithURL:headUrl];
        }
        cell.userName.text = self.model.username;
        cell.tradingNum.text = [NSString stringWithFormat:@" %@:%@   ",LocalizationKey(@"tradingNum"),self.model.transactions];
        cell.limitNum.text = [NSString stringWithFormat:@"   %@%@-%@元   ",LocalizationKey(@"limit"),self.model.minLimit,self.model.maxLimit];
        cell.coinNum.text = [NSString stringWithFormat:@"%@ 元 / %@",[self.model.price ug_amountFormat],self.model.unit];
        cell.message.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"advertisingMessage"),self.model.remark];
        cell.remainAmountLabel.text=[NSString stringWithFormat:@" %@:%@   ", LocalizationKey(@"numberRemaining"),[ToolUtil judgeStringForDecimalPlaces:self.remainAmount]];
        [cell configLabelWithArray:self.payArray];
        return cell;
    }else {
        BuyCoinsDetail2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BuyCoinsDetail2TableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = LocalizationKey(@"tradingRemindTip");
        cell.delegate = self;
        if (self.flagindex == 1) {
            //买币 对我而言就是出售
            cell.tipstring.text = LocalizationKey(@"sellNumTip");
        }else {
             //卖币 对我而言就是购买
            cell.tipstring.text = LocalizationKey(@"buyNumTip");
        }
        cell.coinType1.text = @"元";
        cell.coinType2.text = self.model.unit;
        cell.coinType1Num.text = self.coinType1Num;
        cell.coinType2Num.text = self.coinType2Num;
        self.coinType1NumTF= cell.coinType1Num;
        self.coinType2NumTF= cell.coinType2Num;
        return cell;
    }
}

-(void)textFieldTag:(NSInteger)index TextFieldString:(NSString *)textString{
    if (index == 1) {
        NSLog(@"货币种类1数量");
        self.coinType1Num = textString;
        self.coinType2Num = [NSString stringWithFormat:@"%.8f",[textString doubleValue]/[self.model.price doubleValue]];
        self.mode = @"0";
        self.coinType1NumTF.text= textString;
        self.coinType2NumTF.text= self.coinType2Num;
    }else{
        NSLog(@"货币种类2数量");
        self.coinType2Num = textString;
        self.coinType1Num = [NSString stringWithFormat:@"%.2f",[textString doubleValue]*[self.model.price doubleValue]];
        self.mode = @"1";
        self.coinType1NumTF.text= self.coinType1Num ;
        self.coinType2NumTF.text= textString;
    }
   // [self.tableView reloadData];
}
//MARK:--导航栏的设置
-(void)setNavBarUI{
    
    UIButton *rightButton1 = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    [rightButton1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton1.tag = 1;
    [rightButton1 setImage:[UIImage imageNamed:@"searchImage"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc]initWithCustomView:rightButton1];
    UIButton *rightButton2 = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 60, 15)];
    [rightButton2 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton2.tag = 2;
    [rightButton2 setImage:[UIImage imageNamed:@"pullImage.png"] forState:UIControlStateNormal];
    [rightButton2 setTitle:@"--" forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton2 = [[UIBarButtonItem alloc]initWithCustomView:rightButton2];
//    self.navigationItem.leftBarButtonItem = rightBarButton;
    self.navigationItem.rightBarButtonItems = @[rightBarButton2,rightBarButton1];
}
//MARK:--选择国家的点击事件
-(void)BtnClick:(UIButton *)button{
    
    if (button.tag == 1) {
        //搜索点击事件
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        [self.navigationController pushViewController:searchVC animated:YES];
    }else if (button.tag == 2){
        //国家点击事件
       
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
