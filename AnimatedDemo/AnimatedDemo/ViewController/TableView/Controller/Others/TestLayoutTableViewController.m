//
//  TestLayoutTableViewController.m
//  AnimatedDemo
//
//  Created by Dianshi on 2019/5/24.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TestLayoutTableViewController.h"
#import "Game.h"
#import "TABAnimated.h"
#import <TABKit/TABKit.h>
#import "Masonry.h"

@interface TestLayoutTableViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TestLayoutTableViewController

- (instancetype)init {
    if (self = [super init]) {
        [self tableView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
}

- (void)reloadViewAnimated {
    _tableView.tabAnimated.canLoadAgain = YES;
    [_tableView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    [dataArray removeAllObjects];
    // 模拟数据
    for (int i = 0; i < 10; i ++) {
        NSInteger times = arc4random()%3;
        NSString *titleStr = @"这里是测试数据";
        for (int idx = 0; idx < times; idx ++) {
            titleStr = [NSString stringWithFormat:@"%@\n这里是测试数据%d",titleStr,idx+1];
        }
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = titleStr;
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    // 停止动画,并刷新数据
    [self.tableView tab_endAnimation];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestLayoutCell";
    TestLayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestLayoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell initWithData:dataArray[indexPath.row]];
    return cell;
}

#pragma mark - Initize Methods

/**
 load data
 加载数据
 */
- (void)initData {
    dataArray = [NSMutableArray array];
}

/**
 initize view
 视图初始化
 */
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView tab_startAnimation];   // 开启动画
}

#pragma mark - Lazy Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        // 设置tabAnimated相关属性
        // 可以不进行手动初始化，将使用默认属性
        // 自适应高度需要在cell中用假数据撑开，不能保证撑开的完全没有问题，而且高度不能调整，目前没有确定最终的适配方案
        _tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[TestLayoutCell class] cellHeight:100];
        _tableView.tabAnimated.animatedSectionCount = 1;
        _tableView.tabAnimated.animatedCount = 8;
        _tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(0).line(3);
        };
    }
    return _tableView;
}

@end

@interface TestLayoutCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;

@end


@implementation TestLayoutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.timeLab];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.contentView.mas_leftMargin);
        make.right.mas_equalTo(self.contentView.mas_rightMargin);
    }];
    
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
        make.left.mas_equalTo(self.titleLab);
        make.bottom.mas_equalTo(-10);
    }];
    
}

- (void)initWithData:(Game *)game {
    self.titleLab.text = game.title;
    self.timeLab.text = @"发布时间：2018-09-12";
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setFont:kFont(15)];
        [_titleLab setTextColor:[UIColor blackColor]];
        
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setFont:kFont(12)];
    }
    return _timeLab;
}
@end
