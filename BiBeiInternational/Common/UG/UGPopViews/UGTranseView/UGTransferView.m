//
//  UGTransferView.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTransferView.h"
#import "PopView.h"
#import "UGTransferCell.h"

#define titleHeight UG_AutoSize(50)
#define btnHeight UG_AutoSize(40)
#define space  UG_AutoSize(15)

#define Identifier  @"UGTransferCell"

@interface UGTransferView ()<UITableViewDelegate,UITableViewDataSource>
@property (copy, nonatomic) void(^clickHandle)(void);
@property(nonatomic, strong)PopView *popView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UGTransferModel *model;
- (instancetype)initWithWithModel:(UGTransferModel *)model clickItemHandle:(void(^)(void))clickHandle;
@end

@implementation UGTransferView
+ (void)showPopViewWithModel:(UGTransferModel *)model clickItemHandle:(void(^)(void))clickHandle{
    UGTransferView *centerView =[[UGTransferView alloc] initWithWithModel:model clickItemHandle:^{
        if (clickHandle) {
            clickHandle();
        }
    }];
    PopView *popView =[PopView popSideContentView:centerView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.didRemovedFromeSuperView = ^{
        [centerView removeFromSuperview];
    };
    popView.clickOutHidden = NO;
}

-(void)hidePopView{
    [PopView hidenPopView];
}

- (instancetype)initWithWithModel:(UGTransferModel *)model clickItemHandle:(void(^)(void))clickHandle
{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake(UG_AutoSize(45), (kWindowH-UG_AutoSize(300))/2, kWindowW-2*UG_AutoSize(45), UG_AutoSize(300));
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.model = model;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor whiteColor];
            self.layer.cornerRadius = 4;
            [self initUI];
        }
    }
    return self;
}

-(void)initUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"UGTransferCell" bundle:nil] forCellReuseIdentifier:Identifier];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark-UITableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (self.model) {
        cell.title.text = [self.model.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"收币" : @"转币";
        cell.sub.text =[NSString stringWithFormat:@"您当前通过%@%@ UG",[self.model.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"收币入账+" : @"转币扣款-",self.model.amount];
    }
    cell.click = ^{
        [self hidePopView];
    };
    return cell;                                                                                                           
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}

@end
