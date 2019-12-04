//
//  OTCComplaintingViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCComplaintingViewController.h"
#import "UGPayMethodView.h"
#import "MJPhotoBrowser.h"
#import "OTCComplaintViewController.h"
#import "UGCancelAppealApi.h"

@interface OTCComplaintingViewController ()

//顶部信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;//订单名 例如：出售BTC
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//交易数量 例如：9999.00 UG
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态 例如：已付款
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImage;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

//@property (weak, nonatomic) IBOutlet UIView *orderStatusView;//订单状态View 红色圆圈view
@property (weak, nonatomic) IBOutlet UILabel *topPriceLabel;//顶部单价 例如：单价：1 UG = 1 CNY

//申诉人信息
@property (weak, nonatomic) IBOutlet UILabel *complainantLabel;//申诉人
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//申诉人电话

//订单信息
@property (weak, nonatomic) IBOutlet UILabel *orderAmountLabel;//订单金额 例如：100 CNY
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：1.675.03 CNY/BTC
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//数量 例如：0.87557 BTC
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;//订单号 例如：0875456433
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;//订单时间 例如：2018-10-09 17:21:34

//申诉理由
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;

//申诉图片容器
@property (weak, nonatomic) IBOutlet UIView *appealPhotosContainer;
//申诉图片容器高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appealPhotosHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouxuHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shouxuTop;
@property (weak, nonatomic) IBOutlet UILabel *shouxuLabel;

@property(nonatomic, strong) UGOrderDetailModel *orderDetailModel;//订单详细信息模型

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

//申诉添加
@property (weak, nonatomic) IBOutlet UILabel *remindLabel; //顶部申诉驳回提醒
@property (weak, nonatomic) IBOutlet UIView *remindView;
@property (weak, nonatomic) IBOutlet UIButton *reApealBtn; //重新申诉
@property (weak, nonatomic) IBOutlet UIButton *giveUpBtn; //放弃申诉
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultlab;

@property (weak, nonatomic) IBOutlet UIImageView *tsLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation OTCComplaintingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"申诉中";
//    self.tsLine.image = [self drawLineOfDashByImageView:self.tsLine];
    
    [self drawLineOfDashByCAShapeLayer:self.tsLine lineLength:5 lineSpacing:3 lineColor:HEXCOLOR(0xefefef) lineDirection:YES];
    if (@available(iOS 11.0, *)) {
        self.sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    if (!IS_IPHONE_X) {
        self.bottomConstraint.constant = 0;
    }
}

//客服聊天
- (IBAction)onChatWith:(id)sender {
    [self pushToChatViewController];
}

//重新申诉
- (IBAction)reApeal:(id)sender {
    //进入申诉表单提交页面   需要带当前的e申诉y信息过去
    OTCComplaintViewController *complaintVC = [OTCComplaintViewController new];
    complaintVC.orderSn = self.orderDetailModel.orderSn;
    complaintVC.reApeal = YES;
    complaintVC.reSubmit = YES;
    complaintVC.orderDetailModel = self.orderDetailModel;
    [self.navigationController pushViewController:complaintVC animated:YES];
}

//放弃申诉
- (IBAction)giveUp:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[UGAlertPopView shareInstance] showAlertPopViewWithTitle:@"放弃申诉" andMessage:@"您确定要放弃当前申诉吗？" andCancelButtonTittle:@"取消" andConfirmlButtonTittle:@"确认" cancelBlock:^{
    } confirmBlock:^{
        //确定放弃申诉   调接口放弃
        [weakSelf cancelAppeal];
    }];
}

-(void)cancelAppeal{
    UGCancelAppealApi *api = [UGCancelAppealApi  new];
    api.orderSn =  self.orderSn;
    [MBProgressHUD ug_showHUDToKeyWindow];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
             [self.view ug_showToastWithToast:@"放弃申诉成功 ! "];
            @weakify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                @strongify(self);
                [self pustToOTCOrderDetailsWithOrderSn:self.orderSn];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark - Request

- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel {
    self.orderDetailModel = orderDetailModel;
    [self updateViewsData];
}

#pragma mark - 更新view上的数据
- (void)updateViewsData {
    //顶部信息
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailModel.hisAvatar]];
    //用户名
    self.nameLabel.text = self.orderDetailModel.otherSide;
    //出售BTC
    self.orderNameLabel.text = [NSString stringWithFormat:@"%@%@", [self.orderDetailModel typeConvertToString], self.orderDetailModel.unit];
    //9999.00 UG
    self.amountLabel.text = [NSString stringWithFormat:@"%@ UG",self.orderDetailModel.amount];
    //顶部单价
    self.topPriceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元",self.orderDetailModel.price];
    //手续费的处理 根据当前是否返回手续费显示  广告方有手续费
    BOOL show = [self.orderDetailModel.commission doubleValue] > 0;
    self.shouxuHeight.constant = show ? 16.0f : 0.0f;
    self.shouxuTop.constant = show ? 10.0f : 0.0f;
    self.shouxuLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.commission,   self.orderDetailModel.unit];
    //对方收款方式
    UGPayInfoModel *payInfos = [UGPayInfoModel new];
    if (self.orderDetailModel.alipay) {
        payInfos.alipay = self.orderDetailModel.alipay;
    }
    if (self.orderDetailModel.bankInfo) {
        payInfos.bankInfo = self.orderDetailModel.bankInfo;
    }
    if (self.orderDetailModel.wechatPay) {
        payInfos.wechatPay = self.orderDetailModel.wechatPay;
    }
    if (self.orderDetailModel.unionPay) {
        payInfos.unionPay = self.orderDetailModel.unionPay;
    }
    self.payModeView.payInfoModel = payInfos;

    //订单状态
    self.orderStatusLabel.text = [self.orderDetailModel statusConvertToString];
    self.orderStatusImage.image = [UIImage imageNamed:[self.orderDetailModel statusConvertToImageStr]];

    //申诉人信息
    if (self.orderDetailModel.appeal) {
        self.complainantLabel.text = self.orderDetailModel.appeal.initiatorRealName;
        self.phoneLabel.text = [NSString stringWithFormat:@"+%@   %@",self.orderDetailModel.appeal.areaCode,self.orderDetailModel.appeal.mobile];
    }
    //订单详细信息
    //订单金额 例如：100 CNY
    self.orderAmountLabel.text = [NSString stringWithFormat:@"%@ 元", self.orderDetailModel.money] ;
    //单价 例如：1.675.03 CNY/BTC
    self.priceLabel.text = [NSString stringWithFormat:@"%@ 元 / %@",[self.orderDetailModel.price ug_amountFormat], self.orderDetailModel.unit];
    //数量 例如：0.87557 BTC
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@",self.orderDetailModel.amount, self.orderDetailModel.unit];
    //订单号 例如：0875456433
    self.orderNumberLabel.text = self.orderDetailModel.orderSn;
    //订单时间 例如：2018-10-09 17:21:34
    self.orderTimeLabel.text = self.orderDetailModel.createTime;
    //申诉理由
    self.remarksLabel.text = self.orderDetailModel.appeal != nil ? self.orderDetailModel.appeal.remark : @"";
    //申诉图片
    [self setupAppealPhotos];
//  self.platformBacklabel.hidden = ! [self.orderDetailModel.sysBuy isEqualToString:@"1"];
    if ([self.orderDetailModel.appeal.isSuccess isEqualToString:@"2"]) {
        self.remindView.hidden = NO;
        self.remindLabel.hidden = NO;
        self.resultLabel.hidden = NO;
        self.resultlab.hidden = NO;
        self.resultlab.text = self.orderDetailModel.appeal.adminRemark;
    }else{
        self.remindView.hidden = YES;
        self.remindLabel.hidden = YES;
        self.resultLabel.hidden = YES;
        self.resultlab.hidden = YES;
        self.resultlab.text = @"";
    }
}

#pragma mark - 收到新消息

- (void)receiveNewIMMessage:(BOOL)hasNewMessage {
    UIImage *image = hasNewMessage ? [UIImage imageNamed:@"OTC_message-1"] : [UIImage imageNamed:@"OTC_news"];
    [self.chatBtn setImage:image forState:UIControlStateNormal];
}

- (void)setupAppealPhotos {
    
    NSArray *photos = [NSArray new];
    if (self.orderDetailModel.appeal && ! UG_CheckStrIsEmpty(self.orderDetailModel.appeal.imgUrls)) {
         photos = [self.orderDetailModel.appeal.imgUrls componentsSeparatedByString:@","];
    }
    if (photos.count<=0) {
        return;
    }
//    CGFloat height = (SCREEN_WIDTH_S - 28 *2 - 8 *(photos.count - 1)) / 3.0;
//    self.appealPhotosHight.constant = height;
    CGFloat gap = 13.f;
    CGFloat ww = (self.appealPhotosContainer.mj_w-gap*2)/3;
    UIView * tempView = nil;
    
    for (int i = 0; i < photos.count; i ++) {
        UIImageView *photoImageView = [self careatImageViewWithImage:photos[i]];
        photoImageView.tag = 9999 + i;
        [self.appealPhotosContainer addSubview:photoImageView];
        if (i == 0) {
            [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.appealPhotosContainer);
                make.centerY.equalTo(self.appealPhotosContainer);
                make.top.height.equalTo(self.appealPhotosContainer);
                make.width.equalTo(@(ww));
            }];
            
        } else if (i == 2) {
            [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.appealPhotosContainer.mas_right);
                make.centerY.equalTo(self.appealPhotosContainer);
                make.top.height.equalTo(self.appealPhotosContainer);
                make.width.equalTo(@(ww));
            }];
            
        } else {
            [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(tempView.mas_right).offset(gap);
                make.centerX.equalTo(self.appealPhotosContainer.mas_centerX);
                make.centerY.equalTo(tempView);
                make.height.width.equalTo(tempView);
            }];
        }
        tempView = photoImageView;
    }
}

- (UIImageView *)careatImageViewWithImage:(NSString *)imageUrl {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    imageView.userInteractionEnabled = YES;
    @weakify(self);
    UITapGestureRecognizer *tapPressGestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        NSArray *photos = [NSArray new];
        if (self.orderDetailModel.appeal && ! UG_CheckStrIsEmpty(self.orderDetailModel.appeal.imgUrls) ) {
            photos = [self.orderDetailModel.appeal.imgUrls componentsSeparatedByString:@","];
        }
        if (photos.count>0) {
            NSInteger index = sender.view.tag - 9999;
            [MJPhotoBrowser showOnlineImages:photos currentItem:index < photos.count ? photos[index] : 0];
        }
    }];
    [imageView addGestureRecognizer:tapPressGestureRecognizer];
    return imageView;
}

@end
