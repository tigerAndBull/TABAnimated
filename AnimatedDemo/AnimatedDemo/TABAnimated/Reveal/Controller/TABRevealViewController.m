//
//  RevealViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/31.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealViewController.h"
#import "TABPreviewViewController.h"

#import "TABRevealTableViewCell.h"
#import "TABRevealAddChainView.h"

#import "TABRevealChainModel.h"
#import "TABRevealChainManager.h"
#import "TABRevealModel.h"

#import "TABPopViewController.h"

#import "TABRevealKeepDataUtil.h"

@interface TABRevealViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
TABButtonProtocol
>

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UITextField *classNameTF;

@property (nonatomic, strong) UILabel *widthLab;
@property (nonatomic, strong) UITextField *widthTF;

@property (nonatomic, strong) UILabel *heightLab;
@property (nonatomic, strong) UITextField *heightTF;

@property (nonatomic, strong) NSArray <NSString *> *buttonNameArray;
@property (nonatomic, strong) NSMutableArray <UIButton *> *headerButtonArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *importChainCodeTF;

@property (nonatomic, strong) TABRevealModel *revealModel;

@end

@implementation TABRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"实时预览";
    
    if ((_revealModel = [TABRevealKeepDataUtil getCacheData]) == nil) {
        _revealModel = TABRevealModel.new;
    }
    
    [self initUI];
    [self initData];
    
    [self.revealModel addObserver:self forKeyPath:@"chainManagerCount" options:NSKeyValueObservingOptionNew context:nil];
    [self.classNameTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.widthTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.heightTF addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.tableView reloadData];
}

#pragma mark - Public Method

- (void)reloadWithCacheModel:(TABRevealModel *)model {
    self.revealModel = model;
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Private Method

- (void)initData {
    self.classNameTF.text = self.revealModel.targetClassString;
    if (self.revealModel.targetHeight != 0.) {
        self.heightTF.text = [NSString stringWithFormat:@"%.1lf",self.revealModel.targetHeight];
    }else {
        self.heightTF.text = @"";
    }
    if (self.revealModel.targetWidth != 0.) {
        self.widthTF.text = [NSString stringWithFormat:@"%.1lf",self.revealModel.targetWidth];
    }else {
        self.widthTF.text = @"";
    }
}

- (void)preview:(NSString *)className
         height:(CGFloat)height
          width:(CGFloat)width {
    
    Class class = NSClassFromString(className);
    if (class == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入正确类名!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"done" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    TABPreviewViewController *vc = [[TABPreviewViewController alloc] init];
    vc.targetClass = class;
    vc.targetWidth = width;
    vc.targetHeight = height;
    vc.chainManagerArray = self.revealModel.chainManagerArray.mutableCopy;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Target Method

- (void)clickAction:(UIButton *)button {
    
    // 预览效果
    if (button.tag == 0) {
        NSString *className = self.classNameTF.text;
        [self preview:className
               height:[self.heightTF.text floatValue]
                width:[self.widthTF.text floatValue]];
    }
    
    // 拷贝代码
    if (button.tag == 1) {
        NSString *resultString = @"";
        for (TABRevealChainManager *manager in self.revealModel.chainManagerArray) {
            resultString = [resultString stringByAppendingString:manager.cacheCodeString];
        }
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = resultString;
    }
    
    // 重置参数
    if (button.tag == 2) {
        [self reloadWithCacheModel:TABRevealModel.new];
    }
    
    // 添加链式语法
    if (button.tag == 3) {
        
        TABRevealAddChainView *chainView = [[TABRevealAddChainView alloc] initWithFrame:CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width - 20*2, [UIScreen mainScreen].bounds.size.height - 80*2)];
        chainView.currentController = self;
        __weak typeof(self) weakSelf = self;
        chainView.addDoneBlock = ^(TABRevealChainManager * _Nonnull chainManager) {
            [weakSelf.revealModel managerAddObject:chainManager];
            [weakSelf.tableView reloadData];
        };
        
        [[TABPopViewController sharePopView] pushPopViewWithSuperController:self
                                                                    popView:chainView
                                                               TABPopViewIn:TABPopViewInBottom
                                                             TABPopViewStop:TABPopViewStopCenter
                                                              TABPopViewOut:TABPopViewOutBottom
                                                        TABPopViewStopFrame:CGRectZero
                                                               BgViewCancel:NO];
    }
    
    // 导入链式语法
    if (button.tag == 4) {
        
        NSMutableArray *managerArray = @[].mutableCopy;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"导入链式语法代码" preferredStyle:UIAlertControllerStyleAlert];

        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        __weak typeof(self) weakSelf = self;
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            
            NSString *str = weakSelf.importChainCodeTF.text;
            
            if (str == nil || str.length <= 0) {
                return ;
            }
            
            // 拆解字符串
            NSArray <NSString *> *managerStringArray = [str componentsSeparatedByString:@";"];
            for (NSString *managerString in managerStringArray) {
                
                NSArray <NSString *> *chainStringArray = [managerString componentsSeparatedByString:@")."];
                
                // 组装数据
                if (chainStringArray.count > 2) {
                    
                    TABRevealChainManager *managerModel = TABRevealChainManager.new;
                    managerModel.reEdit = YES;
                    
                    for (int i = 0; i < chainStringArray.count; i++) {
                        
                        NSString *chainStr = chainStringArray[i];
                        
                        if (![chainStr containsString:@"("]) {
                            continue;
                        }
                        
                        NSRange range = [chainStr rangeOfString:@"("];
                        NSString *functionName = [chainStr substringToIndex:range.location];
                        NSString *valueStr = [chainStr substringWithRange:NSMakeRange(range.location+1, chainStr.length-1-range.location)];
                        
                        if (i == 0) {
                            NSString *str = @"manager.";
                            if ([chainStr containsString:str]) {
                                NSRange range = [chainStr rangeOfString:str];
                                chainStr = [chainStr substringFromIndex:range.location+range.length];
                            }
                            chainStr = [chainStr stringByAppendingString:@")"];
                            managerModel.prefixString = chainStr;
                            if ([functionName containsString:@"manager.animation"]) {
                                managerModel.managerType = TABRevealChainManagerOne;
                            }else {
                                if ([functionName containsString:@"manager.animations"]) {
                                    managerModel.managerType = TABRevealChainManagerMoreAndContinuous;
                                }else {
                                    managerModel.managerType = TABRevealChainManagerMoreNotContinuous;
                                }
                            }
                            managerModel.targetString = valueStr;
                        }else {
                            TABRevealChainModel *model = TABRevealChainModel.new;
                            model.chainName = functionName;
                            model.chainType = [TABRevealChainModel getChainModelTypeByString:functionName];
                            switch (model.chainType) {
                                case TABRevealChainCGFloat:{
                                    CGFloat floatValue = [valueStr floatValue];
                                    if (floatValue != 0.) {
                                        model.chainValue = @([valueStr floatValue]);
                                    }
                                }
                                    break;
                                case TABRevealChainNSInteger:{
                                    NSInteger value = [valueStr integerValue];
                                    if (value != 0) {
                                        model.chainValue = @(value);
                                    }
                                }
                                    break;
                                case TABRevealChainString:{
                                    if (valueStr != nil &&
                                        valueStr.length != 0) {
                                        model.chainValue = valueStr;
                                    }
                                }
                                    break;
                                case TABRevealChainVoid:
                                    
                                    break;
                                case TABRevealChainColor:
                                    if (valueStr != nil &&
                                        valueStr.length != 0) {
                                        model.chainValue = valueStr;
                                    }
                                    break;
                            }
                            [managerModel.chainModelArray addObject:model];
                        }
                    }
                    [managerArray addObject:managerModel];
                }
            }
            
            TABRevealModel *revealModel = TABRevealModel.new;
            revealModel.targetClassString = self.classNameTF.text;
            revealModel.targetWidth = [self.widthTF.text floatValue];
            revealModel.targetHeight = [self.heightTF.text floatValue];
            revealModel.chainManagerArray = managerArray;
            [self reloadWithCacheModel:revealModel];
        }]];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"粘贴代码，一键导入";
            weakSelf.importChainCodeTF = textField;
        }];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

#pragma mark - TABButtonProtocol

- (void)clickButton:(UIButton *)button
        targetClass:(Class)targetClass
          indexPath:(NSIndexPath *)indexPath {
    
    if (targetClass == TABRevealTableViewCell.class) {
        
        if (button.tag == 1000) {
            TABRevealAddChainView *chainView = [[TABRevealAddChainView alloc] initWithFrame:CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width - 20*2, [UIScreen mainScreen].bounds.size.height - 80*2)];
            chainView.currentController = self;
            [chainView paddingDataWithManager:self.revealModel.chainManagerArray[indexPath.row]];
            __weak typeof(self) weakSelf = self;
            chainView.addDoneBlock = ^(TABRevealChainManager * _Nonnull chainManager) {
                if (!chainManager.reEdit) {
                    [weakSelf.revealModel managerAddObject:chainManager];
                }else {
                    [weakSelf.revealModel updateArrayToCache];
                }
                
                [weakSelf.tableView reloadData];
                
                dispatch_queue_t queue = dispatch_queue_create("com.github.tigerAndBull", DISPATCH_QUEUE_CONCURRENT);
                dispatch_async(queue, ^{
                    [TABRevealKeepDataUtil writeDataToFile:weakSelf.revealModel];
                });
            };

            [[TABPopViewController sharePopView] pushPopViewWithSuperController:self
                                                                        popView:chainView
                                                                   TABPopViewIn:TABPopViewInBottom
                                                                 TABPopViewStop:TABPopViewStopCenter
                                                                  TABPopViewOut:TABPopViewOutBottom
                                                            TABPopViewStopFrame:CGRectZero
                                                                   BgViewCancel:NO];
        }
        
        if (button.tag == 1001) {
            [self.revealModel managerRemoveObject:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([object isEqual:self.classNameTF]) {
        self.revealModel.targetClassString = self.classNameTF.text;
    }
    if ([object isEqual:self.widthTF]) {
        self.revealModel.targetWidth = [self.widthTF.text floatValue];
    }
    if ([object isEqual:self.heightTF]) {
        self.revealModel.targetHeight = [self.heightTF.text floatValue];
    }
    
    dispatch_queue_t queue = dispatch_queue_create("com.github.tigerAndBull", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [TABRevealKeepDataUtil writeDataToFile:self.revealModel];
    });
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.revealModel.chainManagerArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"TABRevealTableViewCell";
    TABRevealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TABRevealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.delegate = self;
    }
    
    TABRevealChainManager *manager = self.revealModel.chainManagerArray[indexPath.row];
    cell.textLabel.text = manager.prefixString;
    return cell;
}

#pragma mark - Init Methods

- (void)initUI {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - Lazy Methods

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3*(15+30)+15+30+10+30)];
        
        [_headerView addSubview:self.nameLab];
        [_headerView addSubview:self.classNameTF];
        
        [_headerView addSubview:self.heightLab];
        [_headerView addSubview:self.heightTF];
        
        [_headerView addSubview:self.widthLab];
        [_headerView addSubview:self.widthTF];
        
        CGFloat mLeft = 15;
        CGFloat mTop = 15;
        CGFloat space = 10;
        CGFloat labWidth = 90;
        
        self.nameLab.frame = CGRectMake(mLeft, mTop, labWidth, 30);
        self.classNameTF.frame = CGRectMake(mLeft+labWidth+space, mTop, [UIScreen mainScreen].bounds.size.width-(mLeft+labWidth+space+mTop), 30);
        
        self.heightLab.frame = CGRectMake(mLeft, CGRectGetMaxY(self.nameLab.frame)+5, labWidth, 30);
        self.heightTF.frame = CGRectMake(mLeft+labWidth+space, CGRectGetMinY(self.heightLab.frame), [UIScreen mainScreen].bounds.size.width-(mLeft+labWidth+space+mTop), 30);
        
        self.widthLab.frame = CGRectMake(mLeft, CGRectGetMaxY(self.heightLab.frame)+5, labWidth, 30);
        self.widthTF.frame = CGRectMake(mLeft+labWidth+space, CGRectGetMinY(self.widthLab.frame), [UIScreen mainScreen].bounds.size.width-(mLeft+labWidth+space+mTop), 30);
        
        CGFloat buttonWidth = 50;
        CGFloat buttonHeight = 30;
        CGFloat buttonSpace = 30;
        
        _headerButtonArray = @[].mutableCopy;
        for (int i = 0; i < self.buttonNameArray.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i < self.buttonNameArray.count - 2) {
                btn.frame = CGRectMake(mLeft+i*(buttonSpace+buttonWidth), CGRectGetMaxY(self.widthLab.frame)+15, buttonWidth, buttonHeight);
            }else {
                btn.frame = CGRectMake(mLeft+(i%(self.buttonNameArray.count - 2))*(buttonSpace+buttonWidth+20+10), CGRectGetMaxY(self.widthLab.frame)+15+buttonHeight+10, buttonWidth+20, buttonHeight);
            }
            
            [btn setTitle:self.buttonNameArray[i] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.]];
            btn.layer.cornerRadius = 6.;
            [btn sizeToFit];
            [btn setBackgroundColor:UIColor.redColor];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_headerView addSubview:btn];
            [_headerButtonArray addObject:btn];
        }
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (NSArray <NSString *> *)buttonNameArray {
    return @[
             @" 预览效果 ",
             @" 拷贝代码 ",
             @" 重置所有参数 ",
             @" 添加链式语法 ",
             @" 导入链式语法 ",
             ];
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = UILabel.new;
        _nameLab.font = [UIFont boldSystemFontOfSize:15.];
        _nameLab.text = @"className: ";
        _nameLab.textColor = UIColor.blackColor;
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

- (UITextField *)classNameTF {
    if (!_classNameTF) {
        _classNameTF = UITextField.new;
        _classNameTF.font = [UIFont systemFontOfSize:14.];
        _classNameTF.placeholder = @"请输入工程中存在的类名";
    }
    return _classNameTF;
}

- (UILabel *)heightLab {
    if (!_heightLab) {
        _heightLab = UILabel.new;
        _heightLab.font = [UIFont boldSystemFontOfSize:15.];
        _heightLab.text = @"height: ";
        _heightLab.textColor = UIColor.blackColor;
        _heightLab.textAlignment = NSTextAlignmentCenter;
    }
    return _heightLab;
}

- (UITextField *)heightTF {
    if (!_heightTF) {
        _heightTF = UITextField.new;
        _heightTF.font = [UIFont systemFontOfSize:14.];
        _heightTF.placeholder = @"必选";
        _heightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _heightTF;
}

- (UILabel *)widthLab {
    if (!_widthLab) {
        _widthLab = UILabel.new;
        _widthLab.font = [UIFont boldSystemFontOfSize:15.];
        _widthLab.text = @"width: ";
        _widthLab.textColor = UIColor.blackColor;
        _widthLab.textAlignment = NSTextAlignmentCenter;
    }
    return _widthLab;
}

- (UITextField *)widthTF {
    if (!_widthTF) {
        _widthTF = UITextField.new;
        _widthTF.font = [UIFont systemFontOfSize:14.];
        _widthTF.placeholder = @"可选，默认为屏幕宽度";
        _widthTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _widthTF;
}

@end
