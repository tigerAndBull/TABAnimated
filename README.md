## 本文目录
>+ 效果图
>+ 框架思维导图
>+ 使用教程

## 效果图
1. 闪光灯模式
2. 骨架屏模式
3. 经典动画模式

![闪光灯动画.gif](https://upload-images.jianshu.io/upload_images/5632003-173bc0f48ec284fa.gif?imageMogr2/auto-orient/strip)

![只有骨架屏.gif](https://upload-images.jianshu.io/upload_images/5632003-3de95600a5475720.gif?imageMogr2/auto-orient/strip)

![经典动画.gif](https://upload-images.jianshu.io/upload_images/5632003-4d40e7dd162ae383.gif?imageMogr2/auto-orient/strip)

## 本项目思维导图

![思维导图.JPG](https://upload-images.jianshu.io/upload_images/5632003-05cfe2aafc075a1c.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 交流群

为了方便进行交流和解决问题，可以加入TABAnimated交流群，保证只进行技术问题的讨论，群号：304543771

#### 简要说明

> 一般情况下，移动端在展示服务器端数据时需要经历
  `创建视图 - 请求数据 - 得到数据并展示` 三个步骤
    本框架在未获得到数据的这段空档期内，根据视图已有的位置信息，映射出一组相同的CALayer视图以及部分动画，在获取到数据后，开发者主动结束动画时一并移除掉。
    
#### 使用流程

**第一步：Install**

**CocoaPods**

> 搜索：pod search TABAnimated

> 安装：pod 'TABAnimated', '~> x.x.x'

**第二步**：在AppDelegate的`didFinishLaunchingWithOptions`方法全局设置TABAnimated的相关属性

![初始化目录图.png](https://upload-images.jianshu.io/upload_images/5632003-e84dfac462f7f376.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

```
// 简单的示例
[[TABViewAnimated sharedAnimated]initWithOnlySkeleton];
```

| 初始化目录| 名称 | 是否全局|superAnimationType |
| ------ | ------ | ------ | ------ |
| Default Animation | 经典动画模式 | 是 |该属性无效|
| Shimmer Animation | 闪光灯模式 | 是 |该属性无效|
| OnlySkeleton | 骨架屏模式 | 是 |该属性无效|
| Custom Animation | 自定义模式 | 否 |该属性有效|

说明：

> 1. 全局：项目中所有视图的所有动画，都是你所指定的初始化方法的那一种
      非全局：父视图通过设置`superAnimationType`，指定该父视图下的所有子视图的动画类型（默认为经典动画类型）
**所以第四种初始化方式和`superAnimationType`属性的意义：使得项目中可以用两种以上动画类型**

> 2. Shimmer和OnlySkeleton的动画，不需要为子视图指定动画类型，将默认设置为`TABAnimationTypeOnlySkeleton`,您可以使用[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)查看效果（后面有提到）

选择设置其他TABAnimated的属性:

| 属性名称| 适用模式 | 含义| 默认值|
| ------ | ------ | ------ | ------ |
| animatedColor | 所有模式 | 动画颜色 | 0xEEEEEE |
| animatedDuration | 经典动画模式 | 伸展来回时长 | 0.4 |
| longToValue | 经典动画模式 | 伸展变长时长度 | 1.6 |
| shortToValue | 经典动画模式 | 伸展变短时长度 | 0.6 |
| animatedDurationShimmer | 闪光灯模式 | 闪光灯移动时长 | 1.5 |


**第三步，父视图需要的操作**：在需要动画的view上，将属性`animatedStyle`设置为`TABTableViewAnimationStart`,不需要动画的view不用做额外的操作
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

**第四步，子视图需要的操作 (只有经典动画模式，包括自定义模式下的经典动画需要此操作)**：

> 1. 将**需要动**的组件的属性`loadStyle`，设置为需要的类型（**不需要动**的组件不用做额外的操作）

> 2.（尽量不要使用）属性`tabViewWidth`，`tabViewHeight`，其为动画开启时该组件的宽度,高度，有默认值

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
        lab.tabViewWidth = 20;
        [lab setTextColor:[UIColor blackColor]];
      
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
    
    // 需要加上！！！
    [cell setNeedsLayout];
    
    // 在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (_collectionView.animatedStyle != TABCollectionViewAnimationStart) {
        [cell initWithData:dataArray[indexPath.row]];
    }
    return cell;
}
```

3. 特别注意UIView和UICollectionView用的是同一枚举


##### 再啰嗦一下：

1. 本文只是简单的引导作用，你可以用本框架订制更精美的效果，具体例子github上代码都有哦～

2. 遇到问题先去[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)上看看有没有使用示例，实在不行联系我～

#### 最后：

> + 欢迎在下方讨论，同时，如果觉得对你有所帮助的话，能在github上star一下就更好了～
> + 如有问题，可以联系我，wx:awh199833
> + github地址：https://github.com/tigerAndBull/LoadAnimatedDemo-ios
     
