//
//  UGFindLinkManVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGFindLinkManVC.h"
#import "UGFindLinkCell.h"
#import "UGLinkManDetailVC.h"
#import "UGCreateRelationApi.h"
#import "UGLinkModel.h"
#import "UGRelationDetailApi.h"

@interface UGFindLinkManVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *findTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UITableView *bottomTabView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation UGFindLinkManVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"查找联系人";
    
    self.findTextFiled.delegate = self;
    self.findTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.bottomTabView.delegate = self;
    self.bottomTabView.dataSource = self;
    [self.bottomTabView registerNib:[UINib nibWithNibName:NSStringFromClass([UGFindLinkCell class]) bundle:nil] forCellReuseIdentifier:@"UGFindLinkCell"];
    [self.bottomTabView reloadData];
}

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    
    return _dataArray;
}

-(void)searchData{
    if (self.findTextFiled.text.length <= 0) {
        self.reminderLabel.hidden = YES;
        [self.view ug_showToastWithToast:@"请输入内容查找"];
        return;
    }
    [self.dataArray removeAllObjects];
    [self.view ug_showMBProgressHudOnKeyWindow];
    UGRelationDetailApi *api = [UGRelationDetailApi new];
    api.username = self.findTextFiled.text;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            UGLinkModel *model = [UGLinkModel mj_objectWithKeyValues:object];
               self.reminderLabel.hidden = NO;
            if (model.memberId.length<=0) {
                if (self.dataArray.count <= 0) {
                    self.reminderLabel.text = @"账号不存在";
                    [self.bottomTabView reloadData];
                }
            }else{
                self.reminderLabel.text = @"您可能想找";
                [self.dataArray addObject:model];
                [self.bottomTabView reloadData];
            }
        }
        else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.findTextFiled.text.length <= 0) {
        [self.view ug_showToastWithToast:@"请输入用户名查找"];
        return NO;
    }else{
        [self searchMan:nil];
    }
    return YES;
}

#pragma mark - 查找联系人
- (IBAction)searchMan:(id)sender {
    [self.view endEditing:YES];
    [self searchData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UGFindLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGFindLinkCell"];
    if (self.dataArray.count>0) {
        UGLinkModel *model = self.dataArray[indexPath.section];
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:nil];
        cell.nameLabel.text = model.username;
        @weakify(self);
        cell.headClick = ^{
            @strongify(self);
            UGLinkManDetailVC *vc = [UGLinkManDetailVC new];
            vc.memberId = model.memberId;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.addClick = ^{
            @strongify(self);
            [self addCreate:model];
        };
    }
    return cell;
}

-(void)addCreate:(UGLinkModel *)model{
    [self.view ug_showMBProgressHudOnKeyWindow];
    UGCreateRelationApi *api = [UGCreateRelationApi new];
    api.relationId = model.memberId;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            [self.view ug_showToastWithToast:@"添加成功 ！"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"添加联系人成功" object:nil];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回首页 刷新UG钱包数据
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count>0) {
        UGLinkModel *model = self.dataArray[indexPath.section];
        UGLinkManDetailVC *vc = [UGLinkManDetailVC new];
        vc.memberId = model.memberId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
