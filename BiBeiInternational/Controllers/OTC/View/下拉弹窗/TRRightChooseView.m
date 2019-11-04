//
//  TRRightChooseView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//


#import "TRRightChooseView.h"
#import "PopView.h"
#import "UGButton.h"
#import "TRFilterInputCollectionViewCell.h"
#import "TRFilterHeaderReusableView.h"

@implementation MoreChooseItemModel
@end

@implementation MoreChooseDataModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"items" : [MoreChooseItemModel class]
             };
}

@end



@interface MoreChooseViewCellectionCell:UICollectionViewCell

@property (nonatomic ,strong) UIButton *btn;
@property (nonatomic ,strong) MoreChooseItemModel *itemModel;

@end

@implementation MoreChooseViewCellectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = self.bounds;
        [self.contentView addSubview:self.btn];
        [self.btn setTitleColor:[UIColor colorWithHexString:@"9a9fa7"] forState:UIControlStateNormal];
        [self.btn setTitleColor:HEXCOLOR(0x6684c7) forState:UIControlStateSelected];
        self.btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
//        self.btn.layer.cornerRadius = 2;
        self.btn.layer.borderColor = [UIColor colorWithHexString:@"6684c7"].CGColor;
        self.btn.layer.borderWidth = 1.0f;
        self.btn.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setItemModel:(MoreChooseItemModel *)itemModel{
    _itemModel = itemModel;
    [self.btn setTitle:itemModel.itemName forState:UIControlStateNormal];
    self.btn.selected = itemModel.selected;
    self.btn.layer.borderColor = itemModel.selected ? HEXCOLOR(0x6684c7).CGColor : [UIColor clearColor].CGColor;
    [self.btn setBackgroundColor:itemModel.selected ? [UIColor clearColor] : HEXCOLOR(0xf7f7fa)];
    @weakify(self);
    [itemModel bk_addObserverForKeyPath:@"selected" options:NSKeyValueObservingOptionNew task:^(MoreChooseItemModel *obj, NSDictionary *change) {
        @strongify(self);
        self.btn.selected = obj.selected;
        self.btn.layer.borderColor = [UIColor colorWithHexString: obj.selected ? @"6684c7" : @"dddddd"].CGColor;
    }];
}

- (void)dealloc {
    [self.itemModel bk_removeAllBlockObservers];
}

@end

@interface TRRightChooseView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic ,strong)UICollectionView *collectionView;
@property(nonatomic ,strong) UIView *toolView;

@end

@implementation TRRightChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.toolView];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MoreChooseDataModel *dataModel = self.dataArr[section];
    if ([dataModel.type isEqualToString:@"1"]) {
        return dataModel.items.count;
    }
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreChooseDataModel *dataModel = self.dataArr[indexPath.section];
    if ([dataModel.type isEqualToString:@"1"]) {
        MoreChooseViewCellectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoreChooseViewCellectionCell" forIndexPath:indexPath];
        cell.itemModel = dataModel.items[indexPath.row];
        return cell;
    }
    TRFilterInputCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TRFilterInputCollectionViewCell class]) forIndexPath:indexPath];
    cell.chooseDataModel = dataModel;
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MoreChooseDataModel *dataModel = self.dataArr[indexPath.section];
        TRFilterHeaderReusableView *headerReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([TRFilterHeaderReusableView class]) forIndexPath:indexPath];
        headerReusableView.titleLabel.text = dataModel.name;
        return headerReusableView;
    }
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
    UIView *lineView = [view viewWithTag:12];
    if (lineView == nil) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 14, 1)];
        lineView.tag = 12;
        [view addSubview:lineView];
    }
    if (indexPath.section == self.dataArr.count-1) {
        [lineView removeFromSuperview];
    }else{
        lineView.backgroundColor =[UIColor colorWithHexString:@"DFDFDF"];
    }
    return view;
}

#pragma mark - UICollectionViewDelegate

//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(50, 56);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(50, 1);
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MoreChooseDataModel *dataModel = self.dataArr[indexPath.section];
    if ([dataModel.type isEqualToString:@"1"]) {
        //交易量
        if (self.dataArr.count - 1 == indexPath.section || self.dataArr.count - 2 == indexPath.section) {
            return CGSizeMake((collectionView.size.width - 15 *2- 20) /2, 30);
        }
        return CGSizeMake((collectionView.size.width - 10 *2- 10*3) /3, 30);
    }
    return CGSizeMake( collectionView.size.width, 30);

}


//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreChooseDataModel *sectionItems = [self.dataArr objectAtIndex:indexPath.section];
    
    MoreChooseItemModel *chooseItem = [sectionItems.items objectAtIndex:indexPath.row];
    
    for (MoreChooseItemModel *item in sectionItems.items) {
        if ([chooseItem.itemName isEqualToString:@"全部"]) {
            item.selected = NO;
        }
        if ([item.itemName isEqualToString:@"全部"]) {
            item.selected = NO;
        }
        if ([chooseItem.itemName isEqualToString:@"数量升序"] && ! [item.itemName isEqualToString:@"数量升序"]) {
            item.selected = NO;
        }
        
        if ([chooseItem.itemName isEqualToString:@"数量降序"] && ! [item.itemName isEqualToString:@"数量降序"]) {
            item.selected = NO;
        }
        if ([chooseItem.itemName isEqualToString:@"交易量升序"] && ! [item.itemName isEqualToString:@"交易量升序"]) {
            item.selected = NO;
        }
        if ([chooseItem.itemName isEqualToString:@"交易量降序"] && ! [item.itemName isEqualToString:@"交易量降序"]) {
            item.selected = NO;
        }
    }
    if ([chooseItem.itemName isEqualToString:@"数量升序"] || [chooseItem.itemName isEqualToString:@"数量降序"]) {
        if (indexPath.section+1<self.dataArr.count) {
            MoreChooseDataModel *sectionItemsNext = [self.dataArr objectAtIndex:indexPath.section+1];
            for (MoreChooseItemModel *items in sectionItemsNext.items) {
                items.selected = NO;
            }
        }
    }
    if ([chooseItem.itemName isEqualToString:@"交易量升序"] || [chooseItem.itemName isEqualToString:@"交易量降序"]) {
        MoreChooseDataModel *sectionItemsNext = [self.dataArr objectAtIndex:indexPath.section-1];
        for (MoreChooseItemModel *items in sectionItemsNext.items) {
                 items.selected = NO;
        }
    }
    chooseItem.selected = !chooseItem.selected;
}

#pragma mark - 重置

- (void)resetClick{
    for (MoreChooseDataModel *sectionsModel in self.dataArr) {
        if ([sectionsModel.type isEqualToString:@"0"]) {//双输入框
            sectionsModel.minString = @"";
            sectionsModel.maxString = @"";
        }
        for (MoreChooseItemModel *model in sectionsModel.items) {
            model.selected = NO;
        }
    }
}

#pragma mark - 确定

- (void)sureClick{
    
    BOOL hasSelected = NO;
    for (MoreChooseDataModel *sectionsModel in self.dataArr) {
        if ([sectionsModel.type isEqualToString:@"0"]) {//双输入框
            if (sectionsModel.minString.length > 0 || sectionsModel.maxString.length > 0 ) {
                hasSelected = YES;
                break;
            }
        }
        for (MoreChooseItemModel *model in sectionsModel.items) {
            if (model.selected) {
                hasSelected = YES;
                break;
            }
        }
    }
    if (self.clickSure) {
        self.clickSure(hasSelected, [self selectedFilterModel]);
    }
    [PopView hidenPopView];
}


#pragma mark - Getter Method

- (OTCFilterModel *)selectedFilterModel {
    
    OTCFilterModel *filterModel = [OTCFilterModel new];
    
    NSMutableArray <NSString *>*payWays = [NSMutableArray new];//支付方式
    NSMutableArray <NSString *>*countrys = [NSMutableArray new];//国家或地区

    
    for (MoreChooseDataModel *sectionsModel in self.dataArr) {
        if ([sectionsModel.type isEqualToString:@"0"]) {//双输入框
            NSString *low = sectionsModel.minString;
            NSString *high = sectionsModel.maxString;
            if ([sectionsModel.name containsString:@"价格"]) {
                filterModel.minLimitCount = low;
                filterModel.MaxLimitCount = high;
            } else if ([sectionsModel.name containsString:@"数量"]) {
                filterModel.lowAmount = low;
                filterModel.highAmount = high;
            }
        }
        
        for (MoreChooseItemModel *model in sectionsModel.items) {
            if (model.selected) {
                if ([sectionsModel.name containsString:@"支付"]) {
                    [payWays addObject:model.itemName];
                } else if ([sectionsModel.name containsString:@"国家"]) {
                    [countrys addObject:model.itemName];
                } else if ([sectionsModel.name containsString:@"交易量"])  {
                    if ([model.itemName isEqualToString:@"交易量降序"]) {
                        filterModel.orderByClause = @"achieve desc";
                    }else if ([model.itemName isEqualToString:@"交易量升序"]) {
                        filterModel.orderByClause = @"achieve asc";
                    }
                }else if ([sectionsModel.name containsString:@"数量排序"])  {
                    if ([model.itemName isEqualToString:@"数量降序"]) {
                        filterModel.orderByClause = @"number desc";
                    }else if ([model.itemName isEqualToString:@"数量升序"]) {
                        filterModel.orderByClause = @"number asc";
                    }
                }
            }
        }
    }
    if ([payWays containsObject:@"全部"]) {
        [payWays removeAllObjects];
        [payWays addObjectsFromArray:@[@"银行卡",@"支付宝", @"微信",@"云闪付"]];
    }
    if ([countrys containsObject:@"全部"]) {
        [countrys removeAllObjects];
        [countrys addObjectsFromArray:@[@"--", @"日本", @"美国"]];
    }
    
    filterModel.payModes = payWays;
    filterModel.countrys = countrys;
    
    return filterModel;
}

- (UIView *)toolView{
    if (_toolView == nil) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - (60 + SafeAreaBottomHeight), self.bounds.size.width, 60 + SafeAreaBottomHeight)];
        
        UGButton *resetBtn = [[UGButton  alloc] initWithUGStyle:UGButtonStyleLightblue];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [resetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
        [resetBtn setTitleColor:HEXCOLOR(0x9a9fa7) forState:UIControlStateNormal];
        resetBtn.layer.cornerRadius = 0;
        [_toolView addSubview:resetBtn];
        
        [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self->_toolView).mas_offset(0);
            make.bottom.mas_equalTo(self->_toolView.mas_bottom).mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(self.toolView.mj_w/2, 40));
        }];
        
        UGButton *sureBtn = [[UGButton  alloc] initWithUGStyle:UGButtonStyleBlue];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.layer.cornerRadius = 0;
        [_toolView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self->_toolView);
            make.bottom.mas_equalTo(resetBtn.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(self.toolView.mj_w/2, 40));
        }];
        
        UIImageView *line = UIImageView.new;
        line.backgroundColor = HEXCOLOR(0xdddddd);
        [_toolView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(resetBtn.mas_top);
            make.height.equalTo(@1);
            make.width.equalTo(resetBtn.mas_width);
            make.left.equalTo(@0);
        }];
        
    }
    return _toolView;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 15, 20, 15);
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, UG_StatusBarAndNavigationBarHeight - 24, self.bounds.size.width, self.bounds.size.height - self.toolView.bounds.size.height - UG_StatusBarAndNavigationBarHeight - UG_SafeAreaBottomHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerClass:[MoreChooseViewCellectionCell class] forCellWithReuseIdentifier:@"MoreChooseViewCellectionCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TRFilterInputCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TRFilterInputCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionReusableView"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TRFilterHeaderReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([TRFilterHeaderReusableView class])];
    }
    return _collectionView;
}


@end
