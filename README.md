##  本文目录
>+ 效果图
>+ 框架思维导图
>+ 使用教程

##  效果图
1. 模版模式 - 骨架
2. 普通模式 - 闪光灯
3. 普通模式 - 骨架
4. 普通模式 -  经典动画

![template.gif](https://upload-images.jianshu.io/upload_images/5632003-a96a8e0115482406.gif?imageMogr2/auto-orient/strip)

![闪光灯动画.gif](https://upload-images.jianshu.io/upload_images/5632003-173bc0f48ec284fa.gif?imageMogr2/auto-orient/strip)

![只有骨架屏.gif](https://upload-images.jianshu.io/upload_images/5632003-3de95600a5475720.gif?imageMogr2/auto-orient/strip)

![经典动画.gif](https://upload-images.jianshu.io/upload_images/5632003-4d40e7dd162ae383.gif?imageMogr2/auto-orient/strip)


####  v1.9.1 推出模版模式

[介绍模版使用详情文章地址](https://www.jianshu.com/p/aac3df2fd46e)

##  本项目思维导图

![思维导图.JPG](https://upload-images.jianshu.io/upload_images/5632003-05cfe2aafc075a1c.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####  交流群
为了方便进行交流和解决问题，可以加入TABAnimated交流群，保证只进行技术问题的讨论，群号：304543771

####  原理概述

> 一般情况下，移动端在展示服务器端数据时需要经历
  `创建视图 - 请求数据 - 得到数据并展示` 三个步骤
    本框架在未获得到数据的这段空档期内，根据视图已有的位置信息，映射出一组相同的CALayer视图以及部分动画，在获取到数据后，开发者主动结束动画时一并移除掉。

####  使用流程
**第一步：Install**

**CocoaPods**
> 搜索：pod search TABAnimated
> 安装：pod 'TABAnimated'

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
> 2. Shimmer和OnlySkeleton的动画，不需要为子视图指定动画类型，将默认设置为`TABAnimationTypeOnlySkeleton`.
(1.9.0版本可以设置TABAnimationTypeRemove将组件从队列中移除)

选择设置其他TABAnimated的属性:

| 属性名称| 适用模式 | 含义| 默认值|
| ------ | ------ | ------ | ------ |
| animatedColor | 所有模式 | 动画颜色 | 0xEEEEEE |
| animatedDuration | 经典动画模式 | 伸展来回时长 | 0.4 |
| longToValue | 经典动画模式 | 伸展变长时长度 | 1.6 |
| shortToValue | 经典动画模式 | 伸展变短时长度 | 0.6 |
| animatedDurationShimmer | 闪光灯模式 | 闪光灯移动时长 | 1.5 |
|animatedHeightCoefficient|所有模式|动画高度系数|0.8|
|isRemoveLabelText|所有模式|动画时置空text|NO|
|isRemoveButtonTitle|所有模式|动画时置空title|NO|
|isRemoveImageViewImage|所有模式|动画时置空image|NO|

**第三步，父视图需要的操作**：开启动画
```
[self.view addSubview:self.mainTV];
[self.mainTV tab_startAnimation];   // 开启动画
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
       _mainTV.animatedCount = 3;    // 设置动画row的数量
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTV;
}
```

**第四步，子视图需要的操作 (只有经典动画模式，包括自定义模式下的经典动画需要此操作)**：

> 1. 将**需要动画**的组件的属性`loadStyle`，设置为需要的类型（**不需要动**的组件不用做额外的操作）
> 2.（尽量不要使用）属性`tabViewWidth`，`tabViewHeight`，其为动画时组件的宽度,高度，有默认值。
默认是根据你布局时生成的组件的宽高，该属性用于特殊情况。

```

// 经典动画枚举
typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationDefault = 0,         // default,没有动画
    TABViewLoadAnimationShort,               // 动画先变短再变长
    TABViewLoadAnimationLong,                // 动画先变长再变短
    TABViewLoadAnimationWithOnlySkeleton,    // 骨架层
    
    TABViewLoadAnimationRemove,              // 从动画队列中移出
};
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
/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    for (int i = 0; i < 20; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是赛事标题%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }

    // 停止动画,并刷新数据
    [self.mainTV tab_endAnimation];
}
```

**表格使用细节**：

以下均针对UITableView组件和UICollectionView组件

1. 在加载动画的时候，即未获得数据时，不要设置对应的数值
    当然这样的话耦合度高，下面说明当前解决方案。
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (!_mainTV.isAnimating) {
        [cell initWithData:dataArray[indexPath.row]];
    }

    return cell;
}
```
2. 一般情况下刷新数据源的时候，大家都用`cellForRowAtIndexPath`代理方法，
解决方案就是加载视图使用`cellForRowAtIndexPath`代理方法，
刷新数据源使用`willDisplayCell`代理方法，如下：
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *myCell = (TestTableViewCell *)cell;
    [myCell initWithData:dataArray[indexPath.row]];
}
```
3. 多section通过新增表格代理方法解决
`UITableViewAnimatedDelegate`和`UICollectionViewAnimatedDelegate`
```
_mainTV.animatedDelegate = self;
```
```
- (NSInteger)tableView:(UITableView *)tableView numberOfAnimatedRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 3;
}
```
4. 对于嵌套表格组件，需要被嵌套在内的表格组件的`isNest`属性设为`YES`
```
_collectionView.isNest = YES;
```

##### 再啰嗦一下：

1. 本文只是简单的引导作用，你可以用本框架订制更精美的效果，具体例子github上代码都有哦～
2. 遇到问题先去[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)上看看有没有使用示例，实在不行联系我～

#### 最后：

> + 欢迎在下方讨论，如果觉得对你有所帮助的话，能在github上star一下就更好了～
> + 如有问题，加入交流群:304543771
> + github地址：https://github.com/tigerAndBull/LoadAnimatedDemo-ios
     




     
