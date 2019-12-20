//
//  UGSaveOfficialWebsiteGuideController.m
//  BiBeiInternational
//
//  Created by keniu on 2019/7/10.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSaveOfficialWebsiteGuideController.h"
#import "AppDelegate.h"
#import "UGGuideViewCell.h"

@interface UGSaveOfficialWebsiteGuideController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *backBut;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (assign, nonatomic) BOOL isNavHidden;

@end

@implementation UGSaveOfficialWebsiteGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarHidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGGuideViewCell" bundle:nil] forCellReuseIdentifier:@"UGGuideViewCell"];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"161980"];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    if (IS_IPHONE_X) {
        self.navHeight.constant = 88.0;
    }
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if (object == self.tableView) {
        //如果是这个对象就可以获得contentOffset的值然后判断是正或者负，来判断上拉下拉。
        CGPoint point = [((NSValue *)[self.tableView  valueForKey:@"contentOffset"]) CGPointValue];
        CGFloat offsetY = 158.0 - self.navHeight.constant;
        if (point.y > offsetY) {
            if (self.isNavHidden) {
                @weakify(self);
                [UIView animateWithDuration:0.3 animations:^{
                    @strongify(self);
                    self.isNavHidden = NO;
                    self.navView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0];
                    [self.backBut setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
                    self.titleLab.textColor = [UIColor colorWithHexString:@"333333"];
                    [self setNeedsStatusBarAppearanceUpdate];
                }];
            }
        }else{
            if (!self.isNavHidden) {
                @weakify(self);
                [UIView animateWithDuration:0.3 animations:^{
                    @strongify(self);
                    self.isNavHidden = YES;
                    self.navView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
                    [self.backBut setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
                    self.titleLab.textColor = [UIColor colorWithHexString:@"fefffe"];
                    [self setNeedsStatusBarAppearanceUpdate];
                }];
            }
        }

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UGGuideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGGuideViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //220 图片以外的原始高度， 10 cell 上下留边高度
    return 220 + 3*(((UG_SCREEN_WIDTH-75.0f)/2)*(16.0f/9.0f))+10+10;
}

#pragma mark - 返回
- (IBAction)goBackHomeVCAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存官网到桌面
- (IBAction)addDesktopShortcut:(id)sender
{
    NSString *URLString = [self upDataMessage:@"ugWebUrl" WithMessage:@"https://ugcoin.pro"];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"phone_template" ofType:@"mobileconfig"];/*读取app内的文件*/
    //动态生成一个包含正确官网的地址的描述文件
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary * config = [data mutableCopy];
    NSMutableDictionary * content = config[@"PayloadContent"][0];
    [content setObject:URLString forKey:@"URL"];
    //0快捷方式不可移除  1快捷方式可移除
    [content setValue:@(0) forKey:@"IsRemovable"];
    //不同的手机型号使用不同规格的Icon
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ugDesktopShortcut"]);
    [content setObject:imageData forKey:@"Icon"];
    NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:@"New_template.mobileconfig"];
    [config writeToFile:filename atomically:YES];
    //目标位置
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"profile.mobileconfig"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:filename toPath:path error:nil];
    __weak AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UInt16 port = appDelegate.httpServer.port;
    if (success) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%u/profile.mobileconfig", port]]];
}

#pragma mark - 状态栏控制
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.isNavHidden) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

@end
