## 以下所有参数的注释均可以在框架中找到，建议直接在框架中查看

## 目录
- 全局方法和属性
- 局部（控制视图）属性
- 链式语法说明

## 全局方法和属性

#### 一、`appDelegate`初始化方法列表

| 初始化方法| 名称 | 
| ------ | ------ | 
| initWithOnlySkeleton | 骨架屏 | 
| initWithBinAnimation | 呼吸灯动画 | 
| initWithShimmerAnimated | 闪光灯动画 | 
| initWithDropAnimated | 豆瓣动画 |

- 初始化方法仅仅设置的是项目中全局的动画效果，默认动画内容颜色。
- 设置`TABViewAnimated`中局部动画属性`superAnimationType`覆盖全局属性，在一个工程中兼容多种动画。

#### 二、全局属性列表

使用方法
```
[TABAnimated shareAnimated].xxx = xxx;
```

| 属性名称 | 适用动画 | 含义| 默认值|
| ------ |   ------ |  ------ | ------ |
| animatedColor|  通用 | 动画内容颜色 | 0xEEEEEE |
| animatedBackgroundColor| 通用 | 动画背景颜色 | UIColor.whiteColor |
|animatedHeightCoefficient| 通用|高度系数|0.75|
|useGlobalCornerRadius| 通用|使用动画全局圆角|NO|
|animatedCornerRadius| 通用|全局动画圆角的值|0.|
|useGlobalAnimatedHeight| 不适用UIImageView|使用全局动画高度|NO|
|animatedHeight| 不适用UIImageView|全局动画高度的值|12.|
|openLog| 通用|开启日志|NO|
|openAnimationTag| 通用|开启动画下标红色角标|NO|
| animatedDurationShimmer |  闪光灯 | 移动时长 | 1.5 |
|shimmerDirection|闪光灯|闪光灯动画的方向|从左往右|
|shimmerBackColor|闪光灯|闪光灯变色值|0xDFDFDF|
|shimmerBrightness|闪光灯|闪光灯亮度|0.92|
| animatedDuration | 动态动画 | 来回移动时长 | 1.0 |
| longToValue |  动态动画 | 伸缩比例 | 1.9 |
| shortToValue |  动态动画 | 伸缩比例 | 0.6 |
|animatedDurationBin|呼吸灯|持续时长|1.0|
|dropAnimationDeepColor|豆瓣动画|豆瓣动画变色值|0xE1E1E1|

## 局部（控制视图）属性
**使用方法**

```
_tableView.tabAnimated.xxx = xxx;
```

| 属性名称 | 适用范围 | 含义| 默认值|
| ------ |   ------ |  ------ | ------ |
|superAnimationType| 通用|该控制视图动画类型|默认使用全局属性|
| animatedColor| 通用 | 动画内容颜色 | UIColor.whiteColor |
| animatedBackgroundColor | 通用 | 动画背景颜色 | 0xEEEEEE |
| cancelGlobalCornerRadius |  通用 | 取消使用全局圆角 | NO |
| animatedCornerRadius |  通用 | 该控制视图下动画圆角 | 0. |
| animatedHeight |  通用 | 该控制视图下动画高度 | 0. |
|isAnimating| 通用|是否在动画中|\|
|isNest| 通用|是否是被嵌套的表格|NO|
|canLoadAgain| 通用|是否可以重复启动动画|NO|
|animatedCount| 表格组件| 动画数量|单个section情况下，填满表格可视区域|

## 链式语法说明

| 链式函数名称 | 含义 | 
| ------ |   ------ |
| manager.animation(x) | 指定下标x的单个动画个体|
| manager.animations(a,n) | 从a开始的n个动画个体集合 |
| manager.animationsWithIndexs(a,b,c...) | 指定下标的动画个体集合 |
| up(x) | 向上移动多少 |
| down(x) | 向下移动多少 |
| left(x) | 向左移动多少 |
| right(x) | 向右移动多少 |
| height(x) | 修改高度 |
| width(x) | 修改宽度 |
| reducedWidth(x) | 宽度相比之前，减少多少 |
| reducedHeight(x) | 高度相比之前，减少多少 |
| radius(x) | 圆角 |
| reducedRadius(x) | 圆角相比之前，减少多少 |
| remove() | 移出动画组 |
| toLongAnimation() | 赋予先变长后变短的伸缩动画 |
| toShortAnimation() | 赋予先变短后变长的伸缩动画 |
| placeHolder(x) | 为该动画元素添加占位图 |

**需要特别说明的函数：**

line(x): 行数

space(x): 间距

lastScale(x): 最后一行和原宽度的比例系数，默认值0.5

- 如果是`UILabel`，根据会根据文本的`numberOfLines`数量相应赋值。
注意，普通的动画元素也可以通过设置这三个属性，达到多行的特殊效果。
- 每一个动画元素都可以设置`line(x)`达到多行的效果

