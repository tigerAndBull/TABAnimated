<div style="align: center">
<img src="https://upload-images.jianshu.io/upload_images/5632003-14498d8a6c786224.png"/>
</div>

<p style="align: center">
    <a href="https://github.com/tigerAndBull/TABAnimated">
       <img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic">
    </a>
    <a href="https://github.com/tigerAndBull/TABAnimated">
       <img src="https://img.shields.io/badge/language-objective--c-blue.svg">
    </a>
    <a href="https://cocoapods.org/pods/TABAnimated">
       <img src="https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic">
    </a>
    <a href="https://github.com/tigerAndBull/TABAnimated">
       <img src="https://img.shields.io/badge/support-ios%208%2B-orange.svg">
    </a>
</p>

###### 最新版 2.1.5,  2.1.5为测试版，且新加和弃用了api，老用户谨慎升级

建议先花上几分钟，认真阅读本文。

其他相关文档：
- [历史更新文档](https://www.jianshu.com/p/e3e9ea295e8a)
- [解决动画下标问题，极大提高集成效率](https://www.jianshu.com/p/8c361ba5aa18)
- [豆瓣效果使用地址](https://www.jianshu.com/p/1a92158ce83a)
- [嵌套视图说明地址](https://www.jianshu.com/p/cf8e37195c11)

## TABAnimated 交流群
304543771

## 目录

* [关于 TABAnimated](#关于-TABAnimated)
* [实现原理](#实现原理)
* [优点](#优点)
* [演变过程](#演变过程)
* [效果图](#效果图)
* [安装](#安装)  
* [使用Cocoapods](#使用-CocoaPods)
* [手动导入](#手动导入)
* [使用步骤](#使用步骤)
* [扩展回调（动画预处理）](#扩展回调（动画预处理）)
* [Tips](#Tips)
* [属性相关](#属性相关)
* [强调](#强调)
* [最后](#最后)

## 关于 TABAnimated

`TABAnimated`的起源版本是模仿[简书](https://www.jianshu.com/)网页的骨架屏动态效果。
在v1.9探索过模版模式，但是重复的工作量并不利于快速构建，
而且两种模式的存在不合理，所以在v2.1删除了这种设定，但是模版模式的出现到删除，并不是没有收获，相反带来了更合理的实现方案，更便捷的构建方式。

## 实现原理

`TABAnimated` 需要一个控制视图，进行开关动画。该控制视图下的所有subViews都将加入动画队列。

`TABAnimated`通过控制视图的subViews的位置及相关信息创建`TABCompentLayer`。

普通控制视图，有一个`TABComponentManager`

表格视图，每一个cell都有一个`TABComponentManager`

`TABComponentManager`负责管理并显示所有的`TABCompentLayer`。

当使用约束进行布局时，约束不足且没有数据时，致使subViews的位置信息不能体现出来，TABAnimated会进行数据预填充。

## 优点

-  集成迅速
-  零耦合，易于将其动画逻辑封装到基础库
-  高性能，极少的内存损耗
-  链式语法，方便快捷，可读性高
-  完全自定制，适应99.99%的视图

## 演变过程
看不清楚可以放大一下
![原视图.png](https://upload-images.jianshu.io/upload_images/5632003-8a373e3d07820664.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**简单说明一下**：

第一张图：项目原来的视图, 有数据时的展示情况

第二张图：在该组件（控制视图）开启动画后，映射出的动画，相信你可以看出来，效果并不是很美观。

第三张图：针对这个不美观的动画组，通过回调结合链式语法，进行预处理，这点下文会进行说明。

## 效果图

| 动态效果 | 卡片投影 | 呼吸灯  | 
| ------ | ------ | ------ | 
| ![动态动画.gif](https://upload-images.jianshu.io/upload_images/5632003-56c9726a027ca5e2.gif?imageMogr2/auto-orient/strip) | ![卡片投影.gif](https://upload-images.jianshu.io/upload_images/5632003-fd01c795bb3f9e1a.gif?imageMogr2/auto-orient/strip) | ![呼吸灯.gif](https://upload-images.jianshu.io/upload_images/5632003-683062be0a23d5b8.gif?imageMogr2/auto-orient/strip) | 

| 闪光灯（v2.1.0重做）  | 分段视图 | 豆瓣效果 |
| ------ | ------ | ------ | 
| ![闪光灯改版.gif](https://upload-images.jianshu.io/upload_images/5632003-93ab2cf6950498ab.gif?imageMogr2/auto-orient/strip)| ![分段视图.gif](https://upload-images.jianshu.io/upload_images/5632003-4da2062be691cf0b.gif?imageMogr2/auto-orient/strip) | ![豆瓣.gif](https://upload-images.jianshu.io/upload_images/5632003-3ed9d6cc317891a3.gif?imageMogr2/auto-orient/strip) | 

## 安装

#### 使用 CocoaPods
```
pod 'TABAnimated'
```

#### 手动导入

将TABAnimated文件夹拖入工程

**PS: 你可以在github上下载demo，为了很好的模拟真实的应用场景，使用了一些大家都熟悉的第三方，但是TABAnimated自身不依赖他们。**

## 使用步骤

您只需要四步

1.  在 `didFinishLaunchingWithOptions` 中初始化 `TABAimated`

**老用户注意：
原TABViewAnimated已经改名为TABAnimated**
**如今的TABViewAnimated已经成为UIView的骨架对象**

```
// init `TABAnimated`, and set the properties you need.
[[TABAnimated sharedAnimated] initWithOnlySkeleton];
// open log
[TABAnimated sharedAnimated].openLog = YES;
```
**PS：还有其他的全局属性，下文会用表格呈现。**

2. 控制视图初始化tabAnimated
普通view:
```
self.mainView.tabAnimated = TABViewAnimated.new;
self.mainView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
    manager.animation(1).width(200);
    manager.animation(2).width(220);
    manager.animation(3).width(180);
};
```
表格组件：
```
_collectionView.tabAnimated = 
[TABCollectionAnimated animatedWithCellClass:[NewsCollectionViewCell class] 
cellSize:[NewsCollectionViewCell cellSize]];
_collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
    manager.animation(1).reducedWidth(20).down(2);
    manager.animation(2).reducedWidth(-10).up(1);
    manager.animation(3).down(5).line(4);
    manager.animations(4,3).radius(3).down(5);
    manager.animations(4,3).placeholder(@"placeholder.png");
};
```

3. 开启动画
```
[self.collectionView tab_startAnimation];  
```
4. 关闭动画
```
[self.collectionView tab_endAnimation];
```

UIView 对应 `TABViewAnimated`

UITableView 对应 `TABTableAnimated`

UICollectionView 对应 `TABCollectionAnimated`

还配有其他的初始化方式，开启关闭动画方式，同时支持多section，指定section。

一般情况下，注册的cell用原来的cell进行映射就可以了。

**特殊应用场景**：

举个例子，新浪微博帖子页面，有很多很多种类型，
这样复杂的页面，上升到动画层面肯定是设计一个统一的动画。

笔者提供两种方案：
1. 你可以动画预处理回调，高度修改原有映射出的组件，
2. 你可以重新写一个cell，然后注册到这个表格上，通过本框架映射出你想要的视觉效果，这个做法也是模版功能演变过来的。

## 扩展回调（动画预处理）
扩展回调将动画组给予开发者，开发者可以对其进行调整。
因为是调整，所以加入了链式语法，让开发者快速且方便地调整。
```
_collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
    manager.animation(1).reducedWidth(20).down(2);
    manager.animation(2).reducedWidth(-10).up(1);
    manager.animation(3).down(5).line(4);
    manager.animations(4,3).radius(3).down(5);
    manager.animations(4,3).placeholder(@"placeholder.png");
};
```

**参数说明**（框架中也有详细注释）

| 链式函数名称 | 含义 | 
| ------ |   ------ |
| view.animation(x) | 该view的指定下标的动画个体`TABCompentLayer`|
| view.animations(x,x) | 该view指定范围的动画个体数组, 用于统一调整 |
| up(x) | 向上移动多少 |
| down(x) | 向下移动多少 |
| left(x) | 向左移动多少 |
| right(x) | 向右移动多少 |
| height(x) | 修改高度 |
| width(x) | 修改宽度 |
| reducedWidth(x) | 宽度相比之前，减少多少 |
| reducedHeight(x) | 高度相比之前，减少多少 |
| radius(x) | 圆角 |
| remove() | 移出动画组 |
| toLongAnimation() | 赋予动态变长动画 |
| toShortAnimation() | 赋予动态变短动画 |
| placeHolder(x) | 为动画元素添加占位图 |

**需要特别说明的函数：**

line(x): 行数

space(x): 间距

lastScale(x): 最后一行和原宽度的比例系数，默认值0.5

如果是多行文本，根据会根据文本的`numberOfLines`数量相应赋值。
注意，普通的动画元素也可以通过设置这三个属性，达到多行的特殊效果。

特别提醒：
> + 在`TABAnimated.h`文件中，有全局动画参数
> + 在`TABViewAnimated.h`中，有该控制视图中所有动画的参数
> + 上面的链式语法，修改的是具体的动画个体

优先级：
动画个体参数配置 > 控制视图动画参数配置 > 全局动画参数配置

## Tips

1. 问：view.animation(x) ? 我的左上角文本的 x 是多少？？？
即哪个动画个体对应的是哪个组件？

答：

~~如果你使用纯代码构建，那么你添加的组件顺序对应的动画数组的下标,
比如第一个添加到cell上的，那么它对应的动画组件就是：view.animation(0)
依次类推，只要打开你的cell文件，看一下层级进行调整就好了。
但是，如果你用xib创建，很遗憾地告诉你，顺序是关联xib文件的顺序。
demo中的xib做了一个错误示范，有坑慎入。
目前没有找到其他很好的方式，也希望收集大家的建议。~~

[v2.0.9以上解决动画下标问题，极大提高集成效率](https://www.jianshu.com/p/8c361ba5aa18)

2. 多行文本
![line.png](https://upload-images.jianshu.io/upload_images/5632003-866d8adb77e4310c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
上文有提到，这里再强调一下，
可以使用.line(x)设置行数 .space(x)设置间距
每一个动画组件都可以设置这两个属性，达到同一个效果。

3. 指定section加载动画的初始化方法

举个例子：
比如 animatedSectionArray = @[@(3),@(4)];
意思是 cellHeightArray,animatedCountArray,cellClassArray数组中的第一个元素，是分区为3时的动画数据。

```
// 部分section有动画
 _tableView.tabAnimated =
        [TABTableAnimated animatedWithCellClass:[TestTableViewCell class]
                                     cellHeight:100
                                  animatedCount:1
                                      toSection:1];

_tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
    manager.animation(1).down(3).height(12).toShortAnimation();
    manager.animation(2).height(12).width(110).toLongAnimation();
    manager.animation(3).down(-5).height(12);
};
```

4. 多section时扩展回调使用
```
_collectionView.tabAnimated.adjustWithSectionBlock = ^(TABComponentManager * _Nonnull manager, NSInteger section) {
    if (section == 0) {
        manager.animation(1).height(12).down(-2).reducedWidth(-90);
        manager.animation(2).height(12).down(7).reducedWidth(-30);
        manager.animation(3).height(12).down(-2).reducedWidth(150);
        manager.animations(5,3).down(4).right(30);
    }
};
```

5. 对于嵌套表格组件，需要在被嵌套在内的表格组件的`isNest`属性设为`YES`，详情请看demo。
```
_collectionView.tabAnimated = TABCollectionAnimated.new;
_collectionView.tabAnimated.isNest = YES;
_collectionView.tabAnimated.animatedCount = 3;
```

6. 指定section结束动画
```
/**
end animation to the section
特定分区结束动画，在所有分区都不存在动画，会自动置为结束动画状态

@param section 指定section
*/
- (void)tab_endAnimationWithSection:(NSInteger)section;
```

## 属性相关

| 初始化方法| 名称 | 
| ------ | ------ | 
| initWithOnlySkeleton | 骨架屏 | 
| initWithBinAnimation | 呼吸灯动画 | 
| initWithShimmerAnimated | 闪光灯动画 | 

初始化方法仅仅设置的是项目中全局的动画效果。
你可以设置`TABViewAnimated`中局部动画属性`superAnimationType`覆盖全局属性，在工程中兼容多种动画。

**全局动画属性:**
使用方法
```
[TABAnimated shareAnimated].xxx = xxx;
```

| 属性名称 | 适用动画 | 含义| 默认值|
| ------ |   ------ |  ------ | ------ |
| animatedColor|  通用 | 动画颜色 | 0xEEEEEE |
| animatedBackgroundColor| 通用 | 动画背景颜色 | UIColor.white |
| animatedDuration | 动态动画 | 来回移动时长 | 1.0 |
| longToValue |  动态动画 | 伸缩比例 | 1.9 |
| shortToValue |  动态动画 | 伸缩比例 | 0.6 |
| animatedDurationShimmer |  闪光灯 | 移动时长 | 1.5 |
|animatedHeightCoefficient| 通用|高度系数|0.75|
|useGlobalCornerRadius| 通用|开启全局圆角|NO|
|animatedCornerRadius| 通用|全局圆角|0.|
|useGlobalAnimatedHeight| 不适用UIImageView|使用全局动画高度|NO|
|animatedHeight| 不适用UIImageView|全局动画高度|12.|
|openLog| 通用|开启日志|NO|
|openAnimationTag| 通用|开启动画下标红色角标|NO|

**控制视图下所有动画属性配置:**
使用方法
```
_tableView.tabAnimated.xxx = xxx;
```

| 属性名称 | 适用范围 | 含义| 默认值|
| ------ |   ------ |  ------ | ------ |
|superAnimationType| 通用|该控制视图动画类型|默认使用全局属性|
| animatedCount|  表格组件 | 动画数量 | 填满表格可视区域 |
| animatedColor| 通用 | 动画内容颜色 | UIColor.white |
| animatedBackgroundColor | 通用 | 动画背景颜色 | 0xEEEEEE |
| cancelGlobalCornerRadius |  通用 | 取消使用全局圆角 | NO |
| animatedCornerRadius |  通用 | 该控制视图下动画圆角 | 0. |
| animatedHeight |  通用 | 该控制视图下动画高度 | 0. |
|isAnimating| 通用|是否在动画中|\|
|isNest| 通用|是否是被嵌套的表格|NO|
|canLoadAgain| 通用|是否可以重复启动动画|NO|
## 强调：

1. demo也只是简单的引导作用，
你可以订制更精美的效果，高效解决99.99%视图骨架
2. 以上的说明，demo上都有详细介绍和案例，
遇到问题先去[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)上看看有没有使用示例

## 最后：

> + 感谢相遇，感谢使用，如果您觉得不错可以在github上点个star
> + 如有使用问题，优化建议等，加入交流群更快解决:304543771
> + github地址：https://github.com/tigerAndBull/TABAnimated


## License

MIT License

Copyright (c) 2018 tigerAndBull

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
