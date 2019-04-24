+
###### 在您决定使用本库之前，请仔细阅读使用文档，本人接受在TABAnimated交流群内部进行任何指导，希望您先认真阅读文档，谢谢。
+
## 最新版 2.0.2
## 2.0.0升级须知

从去年9月份左右至今，**TABAnimated**原生骨架库历经了多次迭代，不断进步的同时离不开每一位开发者的建议。
而这一次是较为重要和重大的变更，所以采用了版本的跳跃。

使用方式也有一定的变化，提醒老用户谨慎升级。

#### 写在前面

TABAnimated的由来，最初是仿简书的动画效果。
而此次更新，为了降低耦合度，优化底层逻辑，去除了该效果，
后续可能推出一种新的使用方式。
同时也加入了新的呼吸灯动画，有兴趣的开发者可以看后面的效果图。

首先说一下基本原理的变动，
如果你是新的使用者，可以选择跳过。

#### 底层实现优化 一：

**历史版本的原理**：基于subViews的位置映射出一组CALayer，且CALayer是加到每个subView上的

**现版本原理**：基于subViews的位置映射出一个TABLayer，TABLayer是加到父视图或者表格组件的每个cell上的。

这个优化解决了什么？
> + 内存消耗更小，加载动画速度更快
> + 移除动画更快
> + 易拓展，且直接解决了很多历史补丁版本解决的问题，如：`isButtonTitle`等属性，已经不再需要

#### 底层实现优化 二：

使用自动布局的subViews，当约束条件不充足时，位置信息frame是无法满足TABAnimated去构建动画的。

本次更新，在加载动画前，加入了填充数据的逻辑，那么frame信息则会恢复正常，但这个操作在视觉效果上并不能完完全全地满足所有的需要，意思就是宽度可能不是你所理想状态的。

所以，保留了UIView的`tabViewWidth`和`tabViewHeight`的扩展属性，以便设置动画时组件的宽高。

#### 其他优化：

1. 动画枚举调整，
默认是骨架屏，BinAnimation是新加入的呼吸灯动画，去除了经典动画。
```
typedef NS_ENUM(NSInteger,TABAnimationType) {
    TABAnimationTypeOnlySkeleton = 0,    // onlySkeleton for all views in your project.
    TABAnimationTypeBinAnimation,        // default animation for all registered views in your project.
    TABAnimationTypeShimmer              // shimmer animation for all views in your project.
};
```
后面两种，其实是在骨架屏上的拓展动画。

2. 
> + 新增全局圆角属性
> + 新增全局模版属性
> + 模版模式内置默认全局模版，只需开启，关闭动画两步操作
> + 模版模式使用方式变化，具体看下文
> + 模版不推荐使用动画代理，原因使用繁琐，耦合度高，对于模版来说，重点是没必要用😂😂

##  下文目录

>+ 效果图
>+ 模版模式使用步骤
>+ 普通模式使用步骤

##  效果图

1. 卡片投影式
2. 模版模式 - 带下拉演示
3. 模版模式 - 骨架（展示的是内置的默认模版）
4. 普通模式 - 骨架
5. 呼吸灯
6. 闪光灯
7. 分段

![卡片.gif](https://upload-images.jianshu.io/upload_images/5632003-47f991e3d8729075.gif?imageMogr2/auto-orient/strip)

![模版.gif](https://upload-images.jianshu.io/upload_images/5632003-9ab844b612265f7b.gif?imageMogr2/auto-orient/strip)

![模版.gif](https://upload-images.jianshu.io/upload_images/5632003-ff6ac55f277d43af.gif?imageMogr2/auto-orient/strip)

![普通.gif](https://upload-images.jianshu.io/upload_images/5632003-7249862124eb2d76.gif?imageMogr2/auto-orient/strip)

![呼吸灯.gif](https://upload-images.jianshu.io/upload_images/5632003-f05eaec5e159df0d.gif?imageMogr2/auto-orient/strip)

![闪光灯.gif](https://upload-images.jianshu.io/upload_images/5632003-dc5980b6178839c5.gif?imageMogr2/auto-orient/strip)

![分段.gif](https://upload-images.jianshu.io/upload_images/5632003-f50be5a34e12dfd1.gif?imageMogr2/auto-orient/strip)


####  交流群

为了方便解决问题，可以加入TABAnimated交流群，群号：304543771

还有一个重点，就是模版cell的投稿，如果你有好的通用模版UI，可以内置到库中，开发者直接使用即可，方便快捷。

####  前置流程

**第一步：Install**

1. 使用**CocoaPods**集成
> 搜索：pod search TABAnimated
> 安装：pod 'TABAnimated'

2. 手动直接将`TABAnimated`文件夹拖入项目中

**第二步**：在AppDelegate的`didFinishLaunchingWithOptions`方法全局设置TABAnimated的相关属性

```
// 设置TABAnimated相关属性
[[TABViewAnimated sharedAnimated] initWithOnlySkeleton];
// demo选择普通模式的时候，将属性切回了普通模式
// 目前两种模式在不同视图上可以切换
[TABViewAnimated sharedAnimated].isUseTemplate = YES;
// 设置全局圆角
[TABViewAnimated sharedAnimated].animatedCornerRadius = 3.f;
```

| 初始化方法| 名称 | 
| ------ | ------ | 
| initWithOnlySkeleton | 骨架屏 | 
| initWithBinAnimation | 呼吸灯动画 | 
| initWithShimmerAnimated | 闪光灯动画 | 

如果控制视图的`superAnimationType`做了设置，那么将以`superAnimationType`声明的动画类型加载

选择设置其他TABAnimated的属性:

| 属性名称| 适用模式 | 适用动画 | 含义| 默认值|
| ------ | ------ |  ------ |  ------ | ------ |
| animatedColor| 通用 | 通用 | 动画颜色 | 0xEEEEEE |
| animatedDurationShimmer | 通用 | 闪光灯 | 移动时长 | 1.5 |
|animatedHeightCoefficient| 通用|通用|高度系数|0.75|
|animatedCornerRadius| 通用|通用|全局圆角|0.|
|templateTableViewCell| 模版|通用|全局圆角|0.|
|templateCollectionViewCell| 模版|通用|全局圆角|0.|

## 模版模式使用
模版模式只针对表格组件：`UITableView`和`UICollectionView`
如果你想迫不及待地想看到效果
```
// 获取到数据前
[self.tableView tab_startAnimation];   // 开启动画
// 获取到数据后
[self.tableView tab_endAnimation];    // 关闭动画
```
没错，只需要开启，关闭动画，内部其实是使用了内置的全局模版。
但是，事实上我们有很多种不同的table，那么就意味着要写不同的模版。

不过，你也看到，这种做法耦合度极低，特别利于阅读和维护。
所以，在此再次征集，有好的模版建议，欢迎加群投稿。

### 正常流程

1. 写你想要的模版
2. 设置tabAnimated相关属性
3. 开启动画
4. 关闭动画

#### 1.设置tabAnimated相关属性

```
_collectionView.tabAnimated = [TABAnimatedObject animatedWithTemplateClass:[TABTemplateCollectionViewCell class] animatedCount:4];
```
TABAnimatedObject内置两种初始化方式：

一种针对1个section，一种针对多个section
templateClass就是对应的模版类
animatedCount就是对应section展示的动画数量

```
/**
 单section表格组件初始化方式

 @param templateClass 模版cell
 @param animatedCount 动画时row值
 @return object
 */
+ (instancetype)animatedWithTemplateClass:(Class)templateClass
                            animatedCount:(NSInteger)animatedCount;

/**
 多section表格组件初始化方式

 @param templateClassArray 模版cell数组
 @param animatedCountArray 动画时row值的集合
 @return object
 */
+ (instancetype)animatedWithTemplateClassArray:(NSArray <Class> *)templateClassArray
                            animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;
```

用到了数组，当然做了一些安全处理：

当animatedCountArray数组数量大于section数量，多余数据将舍弃
当animatedCountArray数组数量小于seciton数量，剩余部分动画时row的数量为默认值
当模版数量不一致，则使用数组中的最后一个模版。

#### 2. 模版的制作

UITableViewCell的
> + 新建cell，继承自TABBaseTableViewCell
> + 重写`+ (NSValue *)cellSize` 声明模版cell高度
> + 初始化模版对应组件，设置对应frame，支持自动布局

UICollectionViewCell的
> + 新建cell，继承自TABBaseCollectionViewCell
> + 重写`+ (NSValue *)cellSize` 声明模版cell高度
> + 初始化模版对应组件，设置对应frame，支持自动布局

##### tips. 
1. TABAnimatedObject的其他属性，请自己查看demo注释
2. 模版可以用你项目中的cell，但是会产生耦合，请开发者自行抉择
## 普通模式使用

开关动画就不再强调了，和模版使用方式一样

1. 设置tabAnimated相关属性
```
// 可以不进行手动初始化，将使用默认属性
TABAnimatedObject *tabAnimated = TABAnimatedObject.new;
tabAnimated.animatedCount = 3;
_tableView.tabAnimated = tabAnimated;
```
2. 默认会将所有subViews加入动画队列，
可以使用`loadStyle`的`TABViewLoadAnimationRemove`将指定view移出

```
{
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(15)];
        lab.loadStyle = TABViewLoadAnimationRemove;   // 移除动画队列
        lab.tabViewWidth = 100;    // 作为保留属性，不建议使用，设置动画时宽
        lab.tabViewWidth = 20;      // 作为保留属性，不建议使用，设置动画时高
        [lab setTextColor:[UIColor blackColor]];
      
        titleLab = lab;
        [self.contentView addSubview:lab];
 }
```

**表格使用细节**

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
    
    // 较老版本有变动
    // 在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (!_mainTV.tabAnimated.isAnimating) {
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
3. 多section通过新增表格代理方法解决，模版也可以用
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
嵌套表格比较特殊，具体看demo
```
_collectionView.tabAnimated = [[TABAnimatedObject alloc] init];
_collectionView.tabAnimated.isNest = YES;
_collectionView.tabAnimated.animatedCount = 3;
```
##### 再啰嗦一下：

1. 本文也只是简单的引导作用，
你可以用本框架订制更精美的效果，解决大部分的视图骨架，
具体例子github上代码都有哦～
2. 遇到问题先去[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)上看看有没有使用示例

#### 最后：
> + 欢迎在下方讨论，如果觉得对你有所帮助的话，能在github上star一下就更好了～
> + 如模版投稿和其他使用问题，优化建议，加入交流群:304543771
> + github地址：https://github.com/tigerAndBull/LoadAnimatedDemo-ios
