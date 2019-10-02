//
//  TestTableView.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/10.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TestTableView.h"
#import "TestBaseModel.h"
#import "BaseTableViewCell.h"

@interface TestTableView()
<UITableViewDelegate,
UITableViewDataSource
>

@end

@implementation TestTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        _dataArray = @[].mutableCopy;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL judgeSel = @selector(cellSizeByClass);
    SEL sel = @selector(cellHeightNumber);
    SuppressPerformSelectorLeakWarning(
                                       NSNumber *num = [NSClassFromString(self.cellName) performSelector:judgeSel];
                                       if([num boolValue]) {
                                           return [(NSNumber *)[NSClassFromString(self.cellName) performSelector:sel] floatValue];
                                       }
                                       );
    TestBaseModel *model = self.dataArray[indexPath.row];
    return model.viewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = @selector(cellFromTableView:);
    SuppressPerformSelectorLeakWarning(
                                       BaseTableViewCell *cell = [NSClassFromString(self.cellName)
                                                                  performSelector:sel
                                                                  withObject:tableView];
                                       [cell performSelector:@selector(updateWithModel:) withObject:self.dataArray[indexPath.row]];
                                       return cell;
    );
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

@end
