//
//  TABRevealAddChainView.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealAddChainView.h"
#import "TABPopViewController.h"

#import "TABRevealChainManager.h"
#import "TABRevealChainModel.h"

@interface TABRevealAddChainView()
<
UIAlertViewDelegate
>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UIButton *chainManagerTypeBtn;
@property (nonatomic, strong) UITextField *chainManagerTargetTF;

@property (nonatomic ,strong) NSMutableArray <UILabel *> *labelArray;
@property (nonatomic ,strong) NSMutableArray <UITextField *> *tfArray;

@property (nonatomic ,strong) NSArray <NSString *> *inputNameArray;
@property (nonatomic ,strong) NSArray <NSNumber *> *inputTypeArray;
@property (nonatomic ,strong) NSArray <NSString *> *placeholderNameArray;

@property (nonatomic ,strong) NSArray <NSString *> *selectNameArray;
@property (nonatomic ,strong) NSArray <NSString *> *selectFunctionNameArray;
@property (nonatomic ,strong) NSMutableArray <UIButton *> *selectButtonArray;

@property (nonatomic ,strong) NSMutableArray <UILabel *> *nameLabelArray;
@property (nonatomic ,strong) NSMutableArray <UITextField *> *valueTFArray;

@property (nonatomic, strong) TABRevealChainManager *chainManager;

@end

@implementation TABRevealAddChainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColor.whiteColor;
        self.layer.cornerRadius = 5.;
        _labelArray = @[].mutableCopy;
        _tfArray = @[].mutableCopy;
        
        _selectButtonArray = @[].mutableCopy;
        
        CGFloat left = 20;
        CGFloat top = 8;
        CGFloat labelWidth = 60;
        CGFloat labelHeight = 20;
        CGFloat tfWidth = (self.frame.size.width - left*2 - labelWidth*2)/2.;
        
        [self addSubview:self.closeBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.doneBtn];
        self.titleLabel.frame = CGRectMake(0, top+5, self.frame.size.width, labelHeight);
        
        [self addSubview:self.chainManagerTypeBtn];
        [self addSubview:self.chainManagerTargetTF];
        self.chainManagerTypeBtn.frame = CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+top, 40, 20);
        [_chainManagerTypeBtn sizeToFit];

        for (int i = 0; i < self.inputNameArray.count; i++) {
            
            UILabel *lab = UILabel.new;
            if (i % 2 != 0) {
                lab.frame = CGRectMake(left+(left+30+60)*(i%2), 30+(top+labelHeight)*(2+i/2), labelWidth, labelHeight);
            }else {
                lab.frame = CGRectMake(left+(left+labelWidth+tfWidth)*(i%2), 30+(top+labelHeight)*(2+i/2), labelWidth, labelHeight);
            }
            lab.font = [UIFont systemFontOfSize:14.];
            lab.textColor = UIColor.blackColor;
            lab.text = [NSString stringWithFormat:@"%@:",self.inputNameArray[i]];
            [lab sizeToFit];
            [_labelArray addObject:lab];
            [self addSubview:lab];

            UITextField *tf = UITextField.new;
            if (i % 2 == 0) {
                tf.frame = CGRectMake(CGRectGetMaxX(lab.frame)+5, CGRectGetMinY(lab.frame)-1, 70, labelHeight);
            }else {
                tf.frame = CGRectMake(CGRectGetMaxX(lab.frame)+5, CGRectGetMinY(lab.frame)-1, tfWidth, labelHeight);
            }
            tf.font = [UIFont systemFontOfSize:14.];
            tf.placeholder = self.placeholderNameArray[i];
            [_tfArray addObject:tf];
            [self addSubview:tf];
        }
        
        for (int i = 0; i < self.selectNameArray.count; i++) {
            UIButton *btn = UIButton.new;
            btn.tag = i;
            
            CGFloat mLeft = 15;
            CGFloat buttonWidth = 60;
            CGFloat buttonHeight = 30;
            CGFloat buttonSpace = 10;
            
            if (i != self.selectNameArray.count - 1) {
                btn.frame = CGRectMake(mLeft+i*(buttonSpace+buttonWidth), CGRectGetMaxY([self.labelArray lastObject].frame)+20, buttonWidth, buttonHeight);
            }else {
                btn.frame = CGRectMake(mLeft, CGRectGetMaxY([self.labelArray lastObject].frame)+20+buttonHeight+10, buttonWidth+20, buttonHeight);
            }
            [btn setTitle:[NSString stringWithFormat:@" %@ ",self.selectNameArray[i]] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = UIColor.grayColor.CGColor;
            btn.layer.cornerRadius = 4.;
            
            [btn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
            [btn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
            [btn sizeToFit];
            
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_selectButtonArray addObject:btn];
        }
    }
    return self;
}

#pragma mark - Public Methods

- (void)paddingDataWithManager:(TABRevealChainManager *)manager {
    manager.reEdit = YES;
    self.chainManager = manager;
    
    switch (self.chainManager.managerType) {
        case 0:
            // animation(index)
            [self.chainManagerTypeBtn setTitle:@"animation:" forState:UIControlStateNormal];
            break;
        case 1:
            // animations(startIndex,length)
            [self.chainManagerTypeBtn setTitle:@"animations:" forState:UIControlStateNormal];
            break;
        case 2:
            // animationWithIndexs(index1,index2,index3)
            [self.chainManagerTypeBtn setTitle:@"animationsWithIndexs:" forState:UIControlStateNormal];
            break;
    }
    
    [self.chainManagerTypeBtn sizeToFit];
    self.chainManagerTargetTF.frame = CGRectMake(CGRectGetMaxX(self.chainManagerTypeBtn.frame)+5, CGRectGetMinY(self.chainManagerTypeBtn.frame)+1, 200, 30);
    self.chainManagerTargetTF.text = manager.targetString;
    self.chainManagerTargetTF.hidden = NO;
    
    for (int i = 0; i < self.inputNameArray.count; i++) {
        for (TABRevealChainModel *model in manager.chainModelArray) {
            if ([model.chainName isEqualToString:self.inputNameArray[i]]) {
                self.tfArray[i].text = [NSString stringWithFormat:@"%@",model.chainValue];
            }
        }
    }
    
    for (int i = 0; i < self.selectFunctionNameArray.count; i++) {
        for (TABRevealChainModel *model in manager.chainModelArray) {
            if ([model.chainName isEqualToString:self.selectFunctionNameArray[i]]) {
                [self.selectButtonArray[i] setSelected:YES];
            }
        }
    }
}

#pragma mark - Target Methods

- (void)closeAction {
    [[TABPopViewController sharePopView] dissPopView];
}

- (void)clickAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        button.layer.borderColor = UIColor.redColor.CGColor;
    }else {
        button.layer.borderColor = UIColor.grayColor.CGColor;
    }
}

- (void)selectAction {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择类型"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"cancel"
                                              otherButtonTitles:
                              @"animation(index)",
                              @"animations(startIndex, length)",
                              @"animationsWithIndexs(i1, i2, i3)", nil];
    alertView.tag = 1001;
    [alertView show];
#pragma clang diagnostic pop
}

- (void)doneAction {
    
    if (self.chainManagerTargetTF.text.length == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请选择类型并按规定格式输入"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"done"
                                                  otherButtonTitles:nil];
        alertView.tag = 1000;
        [alertView show];
#pragma clang diagnostic pop
        return;
    }
    
    [self closeAction];
    
    if (self.chainManager.chainModelArray != nil) {
        [self.chainManager.chainModelArray removeAllObjects];
    }else {
        self.chainManager.chainModelArray = @[].mutableCopy;
    }
    self.chainManager.targetString = self.chainManagerTargetTF.text;
    
    switch (self.chainManager.managerType) {
        case TABRevealChainManagerOne:
            self.chainManager.prefixString = @"animation";
            break;
        case TABRevealChainManagerMoreAndContinuous:
            self.chainManager.prefixString = @"animations";
            break;
        case TABRevealChainManagerMoreNotContinuous:
            self.chainManager.prefixString = @"animationsWithIndexs";
            break;
    }

    self.chainManager.prefixString = [self.chainManager.prefixString stringByAppendingString:[NSString stringWithFormat:@"(%@)",self.chainManagerTargetTF.text]];
    
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < self.tfArray.count; i++) {
        
        TABRevealChainModel *model = TABRevealChainModel.new;
        model.chainName = self.inputNameArray[i];
        model.chainType = [self.inputTypeArray[i] integerValue];
        
        switch (model.chainType) {
            case TABRevealChainCGFloat:{
                CGFloat floatValue = [self.tfArray[i].text floatValue];
                if (floatValue != 0.) {
                    model.chainValue = @([self.tfArray[i].text floatValue]);
                    [array addObject:model];
                }
            }
                break;
            case TABRevealChainNSInteger:{
                NSInteger value = [self.tfArray[i].text integerValue];
                if (value != 0) {
                    model.chainValue = @(value);
                    [array addObject:model];
                }
            }
                break;
            case TABRevealChainString:{
                if (self.tfArray[i].text != nil &&
                    self.tfArray[i].text.length != 0) {
                    model.chainValue = self.tfArray[i].text;
                    [array addObject:model];
                }
            }
                break;
            case TABRevealChainVoid:
                
                break;
            case TABRevealChainColor:
                if (self.tfArray[i].text != nil &&
                    self.tfArray[i].text.length != 0) {
                    model.chainValue = self.tfArray[i].text;
                    [array addObject:model];
                }
                break;
        }
    }
    
    for (int i = 0; i < self.selectButtonArray.count; i++) {
        UIButton *btn = self.selectButtonArray[i];
        if (btn.isSelected) {
            TABRevealChainModel *model = TABRevealChainModel.new;
            model.chainName = self.selectFunctionNameArray[i];
            model.chainType = TABRevealChainVoid;
            [array addObject:model];
        }
    }
    
    [self.chainManager installChainStatementByModelArray:array.mutableCopy];
    if (self.addDoneBlock) {
        self.addDoneBlock(self.chainManager);
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1001) {
        if (buttonIndex != 0) {
            if (!self.chainManager) {
                self.chainManager = TABRevealChainManager.new;
            }
            self.chainManager.managerType = buttonIndex-1;
            self.chainManagerTargetTF.hidden = NO;
        }
        
        switch (buttonIndex) {
            case 1:
                // animation(index)
                [self.chainManagerTypeBtn setTitle:@"animation:" forState:UIControlStateNormal];
                self.chainManagerTargetTF.placeholder = @"单个下标，格式：1";
                self.chainManager.prefixString = @"animation";
                break;
            case 2:
                // animations(startIndex,length)
                [self.chainManagerTypeBtn setTitle:@"animations:" forState:UIControlStateNormal];
                self.chainManagerTargetTF.placeholder = @"开始下标和长度，格式：1,2";
                self.chainManager.prefixString = @"animations";
                break;
            case 3:
                // animationWithIndexs(index1,index2,index3)
                [self.chainManagerTypeBtn setTitle:@"animationsWithIndexs:" forState:UIControlStateNormal];
                self.chainManagerTargetTF.placeholder = @"多个下标，格式：1,2,3";
                self.chainManager.prefixString = @"animationsWithIndexs";
                break;
        }
        [self.chainManagerTypeBtn sizeToFit];
        self.chainManagerTargetTF.frame = CGRectMake(CGRectGetMaxX(self.chainManagerTypeBtn.frame)+5, CGRectGetMinY(self.chainManagerTypeBtn.frame)+1, 200, 30);
    }
}
#pragma clang diagnostic pop

#pragma mark - Lazy Methods

- (UIButton *)chainManagerTypeBtn {
    if (!_chainManagerTypeBtn) {
        _chainManagerTypeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chainManagerTypeBtn setTitle:@" 点击选择类型（必选） " forState:UIControlStateNormal];
        [_chainManagerTypeBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_chainManagerTypeBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [_chainManagerTypeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.]];
    }
    return _chainManagerTypeBtn;
}

- (UITextField *)chainManagerTargetTF {
    if (!_chainManagerTargetTF) {
        _chainManagerTargetTF = UITextField.new;
        _chainManagerTargetTF.keyboardType = UIKeyboardTypeNumberPad;
        _chainManagerTargetTF.hidden = YES;
        _chainManagerTargetTF.font = [UIFont systemFontOfSize:14.];
    }
    return _chainManagerTargetTF;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        CGFloat width = 25;
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - width - 15, 10, width, 25)];
        [_closeBtn setImage:[UIImage imageNamed:@"tab_reveal_close"] forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.text = @"添加链式语法";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 40)/2, self.frame.size.height - 25 - 10, 40, 25)];
        [_doneBtn setTitle:@" done " forState:UIControlStateNormal];
        [_doneBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:15.]];
        _doneBtn.layer.cornerRadius = 5.;
        [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}

- (NSArray <NSString *> *)inputNameArray {
    return @[
             @"left",@"reducedWidth",
             @"right",@"reducedHeight",
             @"up",@"reducedRadius",
             @"down",@"line",
             @"width",@"placeholder",
             @"height",@"color",
             @"radius",@"dropIndex",
             @"x",@"dropFromIndex",
             @"y",@"dropStayTime",
             ];
}

- (NSArray <NSNumber *> *)inputTypeArray {
    return @[
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             @(TABRevealChainCGFloat),@(TABRevealChainNSInteger),
             @(TABRevealChainCGFloat),@(TABRevealChainString),
             @(TABRevealChainCGFloat),@(TABRevealChainColor),
             @(TABRevealChainCGFloat),@(TABRevealChainNSInteger),
             @(TABRevealChainCGFloat),@(TABRevealChainNSInteger),
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             ];
}

- (NSArray <NSString *> *)placeholderNameArray {
    return @[
             @"向左",@"减少的宽度",
             @"向右",@"减少的高度",
             @"向下",@"减少的圆角",
             @"向上",@"行数",
             @"宽度",@"占位图",
             @"高度",@"格式:r,g,b",
             @"圆角",@"单行豆瓣下标",
             @"横坐标",@"豆瓣多行下标",
             @"纵坐标",@"豆瓣停留时间",
             ];
}

- (NSArray <NSString *> *)selectNameArray {
    return @[
             @"移出队列",@"变长动画",@"变短动画",@"取消居中",@"移出豆瓣队列",
             ];
}

- (NSArray <NSString *> *)selectFunctionNameArray {
    return @[
             @"remove",@"toLongAnimation",@"toShortAnimation",@"cancelAlignCenter",@"removeOnDrop",
             ];
}

@end
