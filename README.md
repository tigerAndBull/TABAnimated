## 本文目录

>+ 效果图
>+ 版本更新记录
>+ 使用教程

## 效果图

上面为 闪光灯动画
下面为 经典动画

![闪光灯动画.gif](https://upload-images.jianshu.io/upload_images/5632003-173bc0f48ec284fa.gif?imageMogr2/auto-orient/strip)

![经典动画.gif](https://upload-images.jianshu.io/upload_images/5632003-4d40e7dd162ae383.gif?imageMogr2/auto-orient/strip)

## 版本更新记录

**2018 - 11 - 22 新增闪光灯动画类型**
>1. 当前最新版本为1.8.0
>2. 新增两个初始化方法，全局切换闪光灯动画

*******************************

**2018 - 11 - 17 此次更新主要是优化库**
>1. 当前最新版本为1.7.0
>2. 之前在cell中只对`self.contentView`中的view生效 ==> 现在`self 和 self.contentView`均可以
>3. 之前cell中使用`封装好的组件`无法显示动画 ==> 现在支持多次嵌套组件
>4. 之前需要先设置delegate，然后再设置dataSource才有动画 ==> 现在已修复，`无优先级区分`
>5. 之前UIView控制动画时，结束动画时必须手动调用layoutSubView重新布局 ==> 现在不需要此操作

**2018 - 11 - 11,12 更新**

>1. 当前最新版本为1.6.0
>2. 确定修复与第三方库crash的情况，以及UIColletionView无效果情况
>3. 希望大家看看10系统一下是否有效果，可能是同一种错误导致

*******************************

**2018 - 10 - 29 更新 及补充说明**

1.  新增初始化方法,可以设置动画执行时伸展时的宽度
```
/**
to set your animations' toValue

 @param duration back and forth
 @param color backgroundcolor
 @param longToValue toValue for LongAnimation
 @param shortToValue toValue for ShortAnimation
 */
- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color
                 withLongToValue:(CGFloat)longToValue
                withShortToValue:(CGFloat)shortToValue;
```
2.  self.delegate = self，暂时不支持这种情况，很抱歉(当然建议不要自己代理自己)
3. 安全性更新，放心使用UICollectionView相关，有问题可以私聊我
4. pod更新，建议下载最新版本 1.4.0，向下兼容
5. delegate和dataSource 需要先设置delegate，后续会进行优化

*******************************

**2018 - 10 - 22 重要更新！**

>1. 支持多行文本～
>2. loadStyle 新增 TABViewLoadAnimationWithOnlySkeleton
      意为：组件设置该属性后，可以暴露骨架，但不会产生动画
>3. 解决多个section失效问题
>4. 解决静态tableView崩溃问题
（后面效果图已更新）

*******************************

**2018 - 10 - 15 重要更新！**

>1. 支持组件UICollectionView，后面有效果图～
>2. 自适应动画长度
>3. 解决利用runtime特性的库与库之间操作冲突导致的程序崩溃问题

使用`注意点`已更新(主要是避免你踩坑)，见文章最后。

*******************************

**2018 - 10 - 08 示例更新**

最近有童鞋反馈xib没有示例，多个UITableView没有效果，针对这个问题将示例代码进行了完善，请持续关注哦～

>1. 新增xib创建示例
>2. 多个UIView，多个UITableView的示例

*******************************

**2018 - 09 - 22 重大更新！你一定会爱上这个库！！！**
**你或许只需要干2件事，就可以让所有组件在网络卡顿时动起来！！！**

>1. 注册需要动画的组件
>2. 父视图控制动画的开关

*******************************

**2018 - 09 - 20 重要更新**
**更新内容：**

>1. 动画支持所有继承自UIView的组件，以前仅支持UITableView
>2. 需要动的组件仍需注册一个属性
>3. 可以全局定义动画时长，动画背景色，由类方法改为单例模式

*******************************

### 说明
>1. 本文主要讲解如何将[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)集成到你的项目中，并使用，同时也算是抛砖引玉了，大佬们要是有更好的封装方法，求之不得。
>2. 均为个人思考，转载请注明出处，谢谢🙏
### 主要使用的技术
>AOP，即IOS的`Runtime`运行机制的黑魔法

## 使用教程
**第一步：Install it**

**CocoaPods**

>pod search TABAnimated

最新版本为1.6.0

**第二步（可选）**：可以选择在appDelegate的`didFinishLaunchingWithOptions`方法全局设置动画属性，设有默认属性，为上面示例图的样子
```
// 设置TABAnimated相关属性
[[TABViewAnimated sharedAnimated]initWithAnimatedDuration:0.3 withColor:tab_kBackColor];
```
**第三步**：在需要动画的view上，将属性`animatedStyle`设置为`TABTableViewAnimationStart`,不需要动画的view不用做额外的操作
```
// UIView和UICollectionView枚举
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,               // 默认,没有动画
    TABViewAnimationStart,                     // 开始动画
    TABViewAnimationRuning,                    // 动画中
    TABViewAnimationEnd,                       // 结束动画
    TABCollectionViewAnimationStart,           // CollectionView 开始动画
    TABCollectionViewAnimationRunning,         // CollectionView 动画中
    TABCollectionViewAnimationEnd              // CollectionView 结束动画
};

// UITableView枚举
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,    // 没有动画，默认
    TABViewAnimationStart,          // 开始动画
    TABViewAnimationEnd             // 结束动画
};

```
```
// UITableView例子
- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mainTV.animatedStyle = TABTableViewAnimationStart;  // 开启动画
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

// UIView例子
- (TestHeadView *)headView {
    if (!_headView) {
        _headView = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, 90)];
        _headView.animatedStyle = TABViewAnimationStart;  //开启动画
    }
    return _headView;
}
```
**第四步**：
>1. 将**需要动**的组件的属性`loadStyle`，设置为需要的类型（**不需要动**的组件不用做额外的操作）
>2. （可选）新增属性`tabViewWidth`，其为动画开启时该组件的宽度,有较为合理默认值
```
typedef enum {
    TABViewLoadAnimationDefault = 0, //默认没有动画
    TABViewLoadAnimationShort,       //动画先变短再变长
    TABViewLoadAnimationLong         //动画先变长再变短
}TABViewLoadAnimationStyle;          //view动画类型枚举
```
```
{
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(15)];
        lab.loadStyle = TABViewLoadAnimationLong;
        lab.tabViewWidth = 100;
        [lab setTextColor:[UIColor blackColor]];
        [lab setText:@""];
        
        titleLab = lab;
        [self.contentView addSubview:lab];
 }
```
**第五步**：在获取到数据后，停止动画，如下:
```
//停止动画,并刷新数据
_mainTV.animatedStyle = TABTableViewAnimationEnd;
[_mainTV reloadData];
    
_headView.animatedStyle = TABViewAnimationEnd;
[_headView initWithData:headGame];
```
**注意点（重要）**：
1. 对于UITableView组件，在加载动画的时候，即未获得数据时，不要设置对应的数值
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
2. 对于UICollectionView组件：
```
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TestCollectionViewCell";
    TestCollectionViewCell *cell = (TestCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // 需要重新布局
    [cell setNeedsLayout];
    
    // 在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (_collectionView.animatedStyle != TABCollectionViewAnimationStart) {
        [cell initWithData:dataArray[indexPath.row]];
    }
    return cell;
}
```
3.特别注意UIView和UICollectionView用的是同一枚举

4.没有默认高度，如果高度为0，则没有动画

## 本文起引导作用，具体例子github上代码都有哦～

## 最后：

> + 欢迎在下方谈论，同时，如果觉得对你有所帮助的话，star一下就更好了
> + 如有问题，可以联系我，qq:1429299849
> + 简书地址：https://www.jianshu.com/p/6a0ca4995dff
