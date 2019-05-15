//
//  DoubanNormalViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "DoubanNormalViewController.h"
#import <TABKit/TABKit.h>
#import "TABAnimated.h"

#define imgWidth (100)

@interface DoubanNormalViewController ()

@property (nonatomic,strong) UIView *mainView;

@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *firstInfoLab;
@property (nonatomic,strong) UILabel *secondInfoLab;

@property (nonatomic,strong) UIButton *commitBtn;

@end

@implementation DoubanNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    // 假设3秒后，获取到数据
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
}

- (void)dealloc {
    NSLog(@"==========  dealloc  ==========");
}

- (void)afterGetData {
    [self.mainView tab_endAnimation];
    
    _topImg.image = [UIImage imageNamed:@"test.jpg"];
    _titleLab.text = @"您不会没有骨架过渡吧？";
    _firstInfoLab.text = @"快用TABAnimated，为您解决烦恼";
    _secondInfoLab.text = @"加群更好解决问题：304543771";
    [_commitBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    
    _commitBtn.layer.borderColor = UIColor.redColor.CGColor;
    _commitBtn.layer.borderWidth = 1.0;
}

#pragma mark - Init Method

- (void)initUI {
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainView];
    
    [self.mainView addSubview:self.topImg];
    [self.mainView addSubview:self.titleLab];
    [self.mainView addSubview:self.firstInfoLab];
    [self.mainView addSubview:self.secondInfoLab];
    [self.mainView addSubview:self.commitBtn];
    
    self.mainView.tabAnimated = TABViewAnimated.new;
    self.mainView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeDrop;
    self.mainView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
        view.animation(0).dropStayTime(0.6);
        view.animation(1).width(200);
        view.animation(2).width(220);
        view.animation(3).width(180);
    };
    [self.mainView tab_startAnimation];
}

#pragma mark - Lazy Method

- (UIImageView *)topImg {
    if (!_topImg) {
        _topImg = [[UIImageView alloc] init];
        _topImg.frame = CGRectMake((kScreenWidth - imgWidth)/2.0, kNavigationHeight + (60), imgWidth, imgWidth);
        _topImg.layer.cornerRadius = imgWidth/2.0;
        _topImg.layer.masksToBounds = YES;
        _topImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.frame = CGRectMake(0, CGRectGetMaxY(self.topImg.frame)+(30), kScreenWidth, (30));
        _titleLab.font = kFont(20);
        _titleLab.textColor = UIColor.blackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)firstInfoLab {
    if (!_firstInfoLab) {
        _firstInfoLab = [[UILabel alloc] init];
        _firstInfoLab.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+(60), kScreenWidth, (20));
        _firstInfoLab.font = kFont(16);
        _firstInfoLab.textColor = UIColor.grayColor;
        _firstInfoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _firstInfoLab;
}

- (UILabel *)secondInfoLab {
    if (!_secondInfoLab) {
        _secondInfoLab = [[UILabel alloc] init];
        _secondInfoLab.frame = CGRectMake(0, CGRectGetMaxY(self.firstInfoLab.frame)+(8), kScreenWidth, (20));
        _secondInfoLab.font = kFont(16);
        _secondInfoLab.textColor = UIColor.grayColor;
        _secondInfoLab.textAlignment = NSTextAlignmentCenter;
    }
    return _secondInfoLab;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        _commitBtn.frame = CGRectMake(kWidth(28), CGRectGetMaxY(self.secondInfoLab.frame)+(80), kScreenWidth - kWidth(28)*2, 55);
        [_commitBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = 5.0f;
        [_commitBtn.titleLabel setFont:kFont(16)];
    }
    return _commitBtn;
}

@end
