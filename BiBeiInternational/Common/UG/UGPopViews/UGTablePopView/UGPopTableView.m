//
//  UGPopTableView.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGPopTableView.h"
#import "TRComplexChooseView.h"
#import "PopView.h"

static const void *SelectedHandleKey = &SelectedHandleKey;

@interface UGPopTableView ()

@property (nonatomic , strong)TRComplexChooseView *chooseView;

@property(nonatomic, copy) NSArray <NSString *>*titles;

@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic, assign) BOOL show;

@property(nonatomic, strong)PopView *popView;

@end

@implementation UGPopTableView


- (instancetype)initWithTtles:(NSArray <NSString *>*)titles selectedIndex:(NSInteger)selectedIndex handle:(void(^) (NSString *title, NSInteger index))handle {
    self = [[UGPopTableView alloc] initWithFrame:CGRectMake(0, 0, UG_SCREEN_WIDTH, 34 * titles.count)];
    if (self) {
        objc_setAssociatedObject(self, SelectedHandleKey, handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.selectedIndex = selectedIndex;
        self.titles = titles;
    }
    return self;
}

- (TRComplexChooseView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[TRComplexChooseView alloc] initWithFrame:self.bounds titles:self.titles selectedIndex:self.selectedIndex];
        _chooseView.backgroundColor = [UIColor whiteColor];
        @weakify(self);
        _chooseView.clickHanlder = ^(NSString *title, NSInteger index) {
            @strongify(self);
            void(^selectedHandle)(NSString *title, NSInteger index) = objc_getAssociatedObject(self, SelectedHandleKey);
            [PopView hidenPopView];
            if (selectedHandle) {
                selectedHandle(title, index);
            }
        };
    }
    return _chooseView;
}


- (void)showPopViewOnView:(UIView *)onView removedFromeSuperView:(void (^)(void))handle {
    if (self.show) {   [PopView hidenPopView]; return; }
    self.show = YES;
    self.popView = [PopView popSideContentView:self.chooseView belowView:onView];
    self.popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    @weakify(self);
    self.popView.didRemovedFromeSuperView = ^{
        @strongify(self);
        self.chooseView = nil;
        self.show = NO;
        if (handle) {
            handle();
        }
    };
}

- (void)hiddenPopView {
    [PopView hidenPopView];
    @weakify(self);
    self.popView.didRemovedFromeSuperView = ^{
        @strongify(self);
        self.chooseView = nil;
        self.show = NO;
    };
}

- (void)dealloc {
    NSLog(@"UGPopTableView释放了.......");
}


@end
