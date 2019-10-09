//
//  UIViewController+expand.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UIViewController+expand.h"
#import <objc/runtime.h>

static const void *BKBarButtonItemBlockKey = &BKBarButtonItemBlockKey;//单个按钮

static const void *BKBarItemsBlockKey = &BKBarItemsBlockKey;//多个按钮

static const void *CustomItem = &CustomItem;

@implementation UIViewController (expand)

#pragma mark - Public Mehtod

/**
 图片添加barbuttonItems 一次性添加左、右按钮多个
 
 @param imageList 图片列表
 @param type 左边还是右边，指定全部按钮的位置
 @param callBack 回调
 @return 点击的UIBarButtonItem对象
 */
- (NSArray <UIButton *>*)setupBarButtonItemsWithImageList:(NSArray <NSString*>*)imageList type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item, NSInteger index, UIButton *btn))callBack {
    
    NSMutableArray <UIButton *>*buttons = [self creatBarButtonItemsWithIsImage:YES dataSource:imageList type:type callBack:callBack];

    return buttons;
}

/**
 文字添加barbuttonItems 一次性添加左、右按钮多个
 默认白色文字
 @param type 左边还是右边，指定全部按钮的位置
 @param titleList 按钮名称数组
 @param callBack 响应block
 @return customView的数组列表
 */
- (NSArray <UIButton*> *)setupBarButtonItemsWithTitleList:(NSArray <NSString*>*)titleList type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item, NSInteger index, UIButton *btn))callBack {
    
    NSMutableArray <UIButton *>*buttons = [self creatBarButtonItemsWithIsImage:NO dataSource:titleList type:type callBack:callBack];

    return buttons;
}


- (UIButton *)setupBarButtonItemWithImageName:(NSString *)imageName type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item))callBack {
    UIBarButtonItem *item = [self creatBarButtonItemWithImageName:imageName type:type];
    objc_setAssociatedObject(item, BKBarButtonItemBlockKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (type == UGBarImteTypeLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
    return item.customView;
}


- (UIButton *)setupBarButtonItemWithTitle:(NSString *)title type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item))callBack {
    UIButton *btn = [self setupBarButtonItemWithTitle:title type:type titleColor:[UIColor whiteColor] callBack:^(UIBarButtonItem * _Nonnull item) {
        if (callBack) {
            callBack(item);
        }
    }];
    return btn;
}

- (UIButton *)setupBarButtonItemWithTitle:(NSString *)title type:(UGBarImteType )type titleColor:(UIColor *)titleColor callBack:(void(^)(UIBarButtonItem *item))callBack {

    UIBarButtonItem *item = [self creatBarButtonItemWithTitle:title titleColor:titleColor];
    objc_setAssociatedObject(item, BKBarButtonItemBlockKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (type == UGBarImteTypeLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
    return item.customView;
}

#pragma mark - Private Mehtod

- (NSMutableArray <UIButton *>*)creatBarButtonItemsWithIsImage:(BOOL)isImage dataSource:(NSArray *)dataSource type:(UGBarImteType )type callBack:(void(^)(UIBarButtonItem *item, NSInteger index, UIButton *btn))callBack {
    NSMutableArray <UIBarButtonItem *>*items = [NSMutableArray new];
    NSMutableArray <UIButton *>*buttons = [NSMutableArray new];
    
    for (NSString *str in dataSource) {
        UIBarButtonItem *item;
        //图片类型
        if (isImage) {
            
            item = [self creatBarButtonItemWithImageName:str type:type];
            
        } else  { //标题
  
            item = [self creatBarButtonItemWithTitle:str titleColor:[UIColor whiteColor]];
        }
        if (item) {
            objc_setAssociatedObject(item, BKBarItemsBlockKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
            [buttons addObject:item.customView];
            [items addObject:item];
        }
    }
    if (type == UGBarImteTypeLeft && items.count > 0) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        //需要倒序排列，不然按钮的顺序是倒序
        self.navigationItem.rightBarButtonItems = [[items reverseObjectEnumerator] allObjects];
    }
    return buttons;
}

- (UIBarButtonItem *)creatBarButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    UIFont *titleFont = [UIFont systemFontOfSize:16];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(100, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil];
    CGFloat textW = rect.size.width < 30 ? 30 : (rect.size.width > 70 ? 50 :  rect.size.width);
    btn.size = CGSizeMake(textW, rect.size.height < 44 ? 44 : rect.size.height);
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    objc_setAssociatedObject(btn, CustomItem, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return  item;
}

- (UIBarButtonItem *)creatBarButtonItemWithImageName:(NSString *)imageName type:(UGBarImteType )type {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.size = CGSizeMake(30, 44);
    [btn setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    CGFloat imageWith = (30 - btn.imageView.image.size.width) > 0 ? (30 - btn.imageView.image.size.width) : 0;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, type == UGBarImteTypeRight ? imageWith/2 : 0, 0, type == UGBarImteTypeRight ? 0 : imageWith/2);
    [btn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    objc_setAssociatedObject(btn, CustomItem, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return  item;
}


#pragma mark - UIControlEvents

- (void)itemClick:(UIButton *)sender {
    
    UIBarButtonItem *item = objc_getAssociatedObject(sender, CustomItem);
    
    void(^callBack)(UIBarButtonItem *item) = objc_getAssociatedObject(item, BKBarButtonItemBlockKey);
    if (callBack) {
        callBack(item);
    }
    
    void(^itemsCallBack)(UIBarButtonItem *item, NSInteger index, UIButton *btn) = objc_getAssociatedObject(item, BKBarItemsBlockKey);
    if (itemsCallBack) {
        NSInteger index = [self.navigationItem.leftBarButtonItems indexOfObject:item];
        if (index == NSNotFound) {
            //不倒序右边按钮的，index获取为倒序的顺序
            NSMutableArray *rightButtons = [[NSMutableArray alloc] initWithArray:self.navigationItem.rightBarButtonItems];
            index = [[[rightButtons reverseObjectEnumerator]allObjects] indexOfObject:item];
        }
        itemsCallBack(item,index, sender);
    }
    
}


@end
