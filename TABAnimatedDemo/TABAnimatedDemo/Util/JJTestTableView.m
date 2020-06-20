//
//  JJTestTableView.m
//  AnimatedDemo
//
//  Created by Joey Chan on 2018/10/24.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "JJTestTableView.h"
#import "TestTableViewCell.h"
#import "TABAnimated.h"

@interface JJTestTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JJTestTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.animatedStyle = TABTableViewAnimationStart;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (self.animatedStyle != TABTableViewAnimationStart) {
        [cell initWithData:self.dataArray[indexPath.row]];
        if (indexPath.section == 0) {
            cell.backgroundColor = [UIColor redColor];
        } else if (indexPath.section == 1) {
            cell.backgroundColor = [UIColor blueColor];
        } else if (indexPath.section == 2) {
            cell.backgroundColor = [UIColor greenColor];
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
