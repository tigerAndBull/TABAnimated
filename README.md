**2018-09-20晚 更新一次**
**更新内容**
>1. 动画支持所有继承自UIView的组件，以前仅支持UITableView
>2. 需要动的组件仍需注册一个属性
>3. 可以全局定义动画时长，动画背景色，由类方法改为单例模式
*******************************
## 先上效果图
![111.gif](https://upload-images.jianshu.io/upload_images/5632003-ae63936557384e9d.gif?imageMogr2/auto-orient/strip)

## 说明
>1. 本文主要讲解如何将[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)集成到你的项目中，并使用，同时也算是抛砖引玉了，大佬们要是有更好的封装方法，求之不得。
>2. 均为个人思考，转载请注明出处，谢谢🙏

## 主要使用的技术
>AOP，即IOS的`Runtime`运行机制的黑魔法

## 使用方法

**第一步**：将demo的文件夹引入到你的项目中，并在合适位置

导入头文件`TABAnimated.h`，建议在`.pch`文件下全局引用
![库文件.png](https://upload-images.jianshu.io/upload_images/5632003-9477775513a22e13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**第二步**：在appDelegate的`didFinishLaunchingWithOptions`方法全局设置动画属性，默认属性为上面示例图的样子

```
//设置TABAnimated相关属性
[[TABViewAnimated sharedAnimated]initWithAnimatedDuration:0.3 withColor:tab_kBackColor];
```

**第三步**：在需要动画的view上，将属性`animatedStyle`设置为`TABTableViewAnimationStart`,不需要动画的view不用做额外的操作
```
//UIView枚举
typedef NS_ENUM(NSInteger,TABTableViewAnimationStyle) {
    TABTableViewAnimationDefault = 0,     //没有动画，默认
    TABTableViewAnimationStart,           //开始动画
    TABTableViewAnimationEnd              //结束动画
};

//UITableView枚举
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,    //没有动画，默认
    TABViewAnimationStart,          //开始动画
    TABViewAnimationEnd             //结束动画
};

```
```
//UITableView例子
- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mainTV.animatedStyle = TABTableViewAnimationStart;  //开启动画
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.rowHeight = 100;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTV;
}

//UIView例子
- (TestHeadView *)headView {
    if (!_headView) {
        _headView = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, 90)];
        _headView.animatedStyle = TABViewAnimationStart;  //开启动画
    }
    return _headView;
}
```

**第四步**：将**需要动**的组件的属性`loadStyle`，设置为需要的类型，下面贴代码，**不需要动**的组件不用做额外的操作

```
typedef enum {
    TABViewLoadAnimationDefault = 0, //默认没有动画
    TABViewLoadAnimationShort,       //动画先变短再变长
    TABViewLoadAnimationLong         //动画先变长再变短
}TABViewLoadAnimationStyle;          //view动画类型枚举
```

**第五步(非常重要，决定了你愿不愿意使用此封装方法)**：贴部分代码，并讲解

```
//获取对应组件文本大小
CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:kFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
//设置frame
titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 10, titleSize.width>0?self.frame.size.width-(CGRectGetMaxX(gameImg.frame)+15):130, 25);
```

请把注意力放在组件`宽`上，想必你已经看到了，当文本为空的时候，计算出来的大小是0，但是这个时候设置一个默认的宽，并设置背景色，就能达到了让用户看到布局架构的效果，使用此封装方法的工作量也就在这个地方，接下来只要让它动起来就可以了

**第六步**：在cell/view的`layoutSubviews`方法的末尾加上`[[[TABViewAnimated sharedAnimated]startOrEndTableAnimated:self];`或`[[TABViewAnimated sharedAnimated]startOrEndViewAnimated:self];`

```
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //获取对应组件文本大小
    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:kFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    CGSize timeSize = [TABMethod tab_getSizeWithText:timeLab.text sizeWithFont:kFont(12) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    
    //布局
    gameImg.frame = CGRectMake(15, 10, (self.frame.size.height-20)*1.5, (self.frame.size.height-20));
    gameImg.layer.cornerRadius = 5;
    
    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 10, titleSize.width>0?self.frame.size.width-(CGRectGetMaxX(gameImg.frame)+15):130, 25);
    timeLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(titleLab.frame)+5, timeSize.width>0?self.frame.size.width-(CGRectGetMaxX(gameImg.frame)+15):200, 15);
    statusBtn.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(timeLab.frame)+5+5,70, 20);
    
    if ( timeSize.width > 0 ) {
        statusBtn.layer.cornerRadius = 5;
    }
    
    //运行动画/移除动画
    [[TABViewAnimated sharedAnimated]startOrEndViewAnimated:self];
}
```

**第七步**：在获取到数据后，停止动画，如下:

```
//停止动画,并刷新数据
_mainTV.animatedStyle = TABTableViewAnimationEnd;
[_mainTV reloadData];
    
_headView.animatedStyle = TABViewAnimationEnd;
[_headView initWithData:headGame];
[_headView layoutSubviews];
```

**注意点**：对于table组件，在加载动画的时候，即未获得数据时，不要设置对应的数值

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (_mainTV.animatedStyle != TABTableViewAnimationStart) {
        [cell initWithData:dataArray[indexPath.row]];
    }

    return cell;
}
```

## 最后：
> + 欢迎在下方谈论，同时，如果觉得对你有所帮助的话，能在github上star一下就更好了
> + 如有问题，可以联系我，qq:1429299849
> + 简书地址：https://www.jianshu.com/p/6a0ca4995dff
