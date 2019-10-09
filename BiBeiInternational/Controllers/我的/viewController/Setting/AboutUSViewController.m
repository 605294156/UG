//
//  AboutUSViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AboutUSViewController.h"
#import "MineNetManager.h"
#import "AboutUSModel.h"

@interface AboutUSViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"aboutUS");
    self.bottomViewHeight.constant = SafeAreaBottomHeight+20;
    self.serviceLabel.text = [NSString stringWithFormat:@"%@：40000000",LocalizationKey(@"serviceTel")];
    self.webLabel.text = [UGURLConfig oldMyApi];
    //[self loadData];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.appVersion.text=[NSString stringWithFormat:@"%@  %@",app_Name,app_Version];
}
-(void)loadData{
     [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager aboutUSInfo:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                
                NSLog(@"---%@",resPonseObj);
                AboutUSModel *model = [AboutUSModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                [self arrangeData:model];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 || [resPonseObj[@"code"] integerValue] == 4000 ){
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
-(void)arrangeData:(AboutUSModel*)model{
   
    if ([model.addressIcon isEqualToString:@""] && model.addressIcon!= nil) {
        [self.logoImage sd_setImageWithURL:[NSURL URLWithString:model.addressIcon] placeholderImage:[UIImage imageNamed:@"aboutIconImage"]];
    }
    if (![model.copyright isEqualToString:@""] && model.copyright != nil) {
         self.appVersion.text = [NSString stringWithFormat:@"%@ %@",model.name,model.copyright];
    }

    if (![model.contact isEqualToString:@""] && model.contact != nil) {
        self.serviceLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"serviceTel"),model.contact];
    }
    if (![model.url isEqualToString:@""] && model.url != nil) {
        self.webLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"webSite"),model.contact];
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
