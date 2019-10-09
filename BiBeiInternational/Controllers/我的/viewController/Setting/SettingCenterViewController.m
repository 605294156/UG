//
//  SettingCenterViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "SettingCenterViewController.h"
#import "AccountSettingTableViewCell.h"
#import "LanguageSettingsViewController.h"
#import "FeedbackViewController.h"
#import "AboutUSViewController.h"
#import "LoginNetManager.h"
#import "ChangeAccountViewController.h"
#import "LoginNetManager.h"
#import "UGTabBarController.h"

@interface SettingCenterViewController ()<UITableViewDataSource,UITableViewDelegate,chatSocketDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
//国际化需要
@property (weak, nonatomic) IBOutlet UIButton *loginOutButton;

@end

@implementation SettingCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = LocalizationKey(@"settingCenter");
    [self.loginOutButton setTitle:LocalizationKey(@"loginOut") forState:UIControlStateNormal];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
    self.bottomViewHeight.constant = SafeAreaBottomHeight+120;
    self.tableView.scrollEnabled = NO;
}

//MARK:--国际化通知处理事件
- (void)languageChange{
    self.title = LocalizationKey(@"settingCenter");
    [self.loginOutButton setTitle:LocalizationKey(@"loginOut") forState:UIControlStateNormal];
    [self.tableView reloadData];
}


//MARK:--退出登录
- (IBAction)loginOutBtnClick:(UIButton *)sender {
    __weak SettingCenterViewController*weakSelf=self;
 
    [self addUIAlertControlWithString:LocalizationKey(@"certainLogOutTip") withActionBlock:^{
        [weakSelf logout];
    }andCancel:^{
    }];
    
//    [LoginNetManager LogoutForCompleteHandle:^(id resPonseObj, int code) {
//        [EasyShowLodingView hidenLoding];
//        NSLog(@"------%@",resPonseObj);
//        if (code) {
//             if ([resPonseObj[@"code"] integerValue]==0) {
//                 [[UGManager shareInstance] signout:nil];
//                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
//
//                 [self.navigationController popViewControllerAnimated:YES];
//             }else{
//                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
//             }
//        }else{
//            [self.view ug_showToastWithToast:@"网络异常,请检查网络!"];
//        }
//    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSArray *)getNameArr{
 
    NSArray * nameArr = @[
                          LocalizationKey(@"languageSettings"),
                          LocalizationKey(@"feedback"),
                          LocalizationKey(@"aboutUS")
                          ];
 
    return nameArr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
    cell.leftLabel.text = [self getNameArr][indexPath.row];
    cell.rightLabel.hidden = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
//        //切换账号
//        ChangeAccountViewController *changeVC = [[ChangeAccountViewController alloc] init];
//        [self.navigationController pushViewController:changeVC animated:YES];
        //语言设置
        LanguageSettingsViewController *languageVC = [[LanguageSettingsViewController alloc] init];
        [self.navigationController pushViewController:languageVC animated:YES];
        
    }else if (indexPath.row == 1){
        //反馈意见
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if (indexPath.row == 2){
        //关于我们
        AboutUSViewController *aboutUSVC = [[AboutUSViewController alloc] init];
        [self.navigationController pushViewController:aboutUSVC animated:YES];
    }else{
      //其他
    }
}

-(void)logout{
 
    [EasyShowLodingView showLodingText:LocalizationKey(@"logOutTip")];
 
    [LoginNetManager LogoutForCompleteHandle:^(id resPonseObj, int code) {
      [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[UGManager shareInstance].hostInfo.ID, @"uid",nil];
                    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//断开聊天socket
                    [ChatSocketManager share].delegate = self;
                   [[UGManager shareInstance] signout:nil];
                
#warning 需要修改，重设window.rootViewController不可取
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    APPLICATION.window.rootViewController= [UGTabBarController new];
                });
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
 
           [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
 
     NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
   if (cmd==UNSUBSCRIBE_GROUP_CHAT) {
       
    }
    NSLog(@"取消订阅聊天组-%@",endStr);
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [ChatSocketManager share].delegate = nil;
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
