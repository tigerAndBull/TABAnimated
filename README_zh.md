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

## 骨架屏是什么？

找到这里的同志，或多或少都对骨架屏有所了解，请容许我先啰嗦一句。骨架屏(Skeleton Screen)是一种优化用户弱网体验的方案，可以有效缓解用户等待的焦躁情绪。

## TABAnimated是什么？

TABAnimated是提供给iOS开发者自动生成骨架屏的一种解决方案。开发者可以将已经开发好的视图，通过TABAnimated配置一些全局/局部的参数，自动生成与其长相一致的骨架屏。
当然，TABAnimated会协助你管理骨架屏的生命周期。

## 目录

* [集成优势](#集成优势)
* [效果展示](#效果展示)
* [演示过程](#演示过程)  
* [集成步骤](#集成步骤)
* [相关文档](#相关文档)
* [最后强调](#最后强调)

## 集成优势

通过TABAnimated集成的骨架屏有什么优势？

-  是一种自动化方案，集成速度很快
-  零耦合，易于将其动画逻辑封装到基础库，且移除方便
-  配有缓存功能，压测切换控制器不卡顿
-  适用场景广，可以适用开发中99%的视图
-  自由度非常高，可以完全地自定制

## 效果展示

| 动态效果 | 卡片投影 | 呼吸灯  | 
| ------ | ------ | ------ | 
| ![动态动画.gif](https://upload-images.jianshu.io/upload_images/5632003-56c9726a027ca5e2.gif?imageMogr2/auto-orient/strip) | ![卡片投影.gif](https://upload-images.jianshu.io/upload_images/5632003-fd01c795bb3f9e1a.gif?imageMogr2/auto-orient/strip) | ![呼吸灯.gif](https://upload-images.jianshu.io/upload_images/5632003-683062be0a23d5b8.gif?imageMogr2/auto-orient/strip) | 

| 闪光灯 | 分段视图 | 豆瓣效果 |
| ------ | ------ | ------ | 
| ![闪光灯改版.gif](https://upload-images.jianshu.io/upload_images/5632003-93ab2cf6950498ab.gif?imageMogr2/auto-orient/strip)| ![分段视图.gif](https://upload-images.jianshu.io/upload_images/5632003-4da2062be691cf0b.gif?imageMogr2/auto-orient/strip) | ![豆瓣.gif](https://upload-images.jianshu.io/upload_images/5632003-3ed9d6cc317891a3.gif?imageMogr2/auto-orient/strip) | 

## 演示过程
下面通过一个小例子，更深入地了解一下TABAnimated。

### 1. 小明和小张有一个下图这样的视图，需要集成骨架屏

![需求.png](https://upload-images.jianshu.io/upload_images/5632003-8c707acf0c20dd31.png?imageMogr2/auto-orient/strip%7CimageView2/3/w/300)

### 2. 下面是通过TABAnimated自动化生成的效果

![自动化生成.png](https://upload-images.jianshu.io/upload_images/5632003-56994d8a518fd304.png?imageMogr2/auto-orient/strip%7CimageView2/3/w/300)

### 3. 小明做这个需求说，这个效果我很满意，那么小明的工作到此就结束了。但是小张说，我感觉长度，高度，虽然和原视图很像，但是作为一种动画效果我不太满意，不够精致。于是，他通过（预处理回调+链式语法），很快地做了如下调整。

![调整效果.png](https://upload-images.jianshu.io/upload_images/5632003-9c0838dcec166562.png?imageMogr2/auto-orient/strip%7CimageView2/3/w/300)

当然啦，每个人有不同的审美，每个产品有不同的需求，这些就全交由你来把握啦～

## 集成步骤

### 一、导入到工程中

- 使用 CocoaPods
```
pod 'TABAnimated'
```

- 将TABAnimated文件夹拖入工程

**注意: 在github上下载的演示demo，为了很好的模拟真实的应用场景，使用了一些大家都熟悉的第三方，但是TABAnimated自身并不依赖他们。**

### 二、全局参数初始化

在 `didFinishLaunchingWithOptions` 中初始化 `TABAimated`

```
[[TABAnimated sharedAnimated] initWithOnlySkeleton];
[TABAnimated sharedAnimated].openLog = YES;
```
**注意：还有其他的动画类型、全局属性，在框架中都有注释。**

### 三、控制视图初始化

**控制视图：如果是列表视图，那么就是UITableView/UICollectionView，有文档具体讲解。**

`NewsCollectionViewCell`就是你列表中用到的cell，当然你要绑定其他cell，也是完全可以的！

```
_collectionView.tabAnimated = 
[TABCollectionAnimated animatedWithCellClass:[NewsCollectionViewCell class] 
cellSize:[NewsCollectionViewCell cellSize]];
```

**注意：**

- **有其他初始化方法，比如常见的多种cell，在框架中都有注释**
- **有针对这个控制视图的局部属性，在框架中都有注释**

### 四、控制骨架屏开关

1. 开启动画

```
[self.collectionView tab_startAnimation];  
```

2. 关闭动画

```
[self.collectionView tab_endAnimation];
```

### 五、刚刚说到的，预处理回调+链式语法怎么用？

```
_tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
    manager.animation(1).down(3).radius(12);
    manager.animation(2).height(12).width(110);
    manager.animation(3).down(-5).height(12);
};
```

**1. 有的人看到上面，可能一下子就被吓到了，集成需要这么复杂吗？**

答：需不需要异步调整，需要调整到什么程度，与你自身约束、产品需求，都有关系。所以并不能自动生成让任何产品、任何人立即都完全满意的效果。
你大可放心，推出这个功能反而是协助开发者更快速调整自己想要的结果。**

**预处理回调+链式语法 简单说明：**

**2. `manager.animation(x)`，x是多少？**

答：设置openTag属性为YES，会自动为你指示，究竟x是几，而且仅会在debug模式下出现哦～

**3. 通过几个示例，你就能很明白是什么个意思啦**

- 假如第0个元素的高度和宽度不合适，那你就可以这样设置
```
manager.animation(0).height(12).width(110);
```

- 假如第1个元素需要使用占位图，那你就可以这样设置
```
manager.animation(1).placeholder(@"占位图名称.png");
```

- 假如第1，2，3个元素宽度都为50，那你就可以这样设置
```
manager.animations(1,3).width(50);
```

- 假如第1，5，7个元素需要下移5px，那你就可以这样设置
```
manager.animationWithIndexs(1,5,7).down(5);
```

![下标示意图.png](https://upload-images.jianshu.io/upload_images/5632003-2842bd54e80dd9ef.png?imageMogr2/auto-orient/strip%7CimageView2/3/w/300)


## 相关文档

**当然啦，在现实中，我们还有各式各样的视图，TABAnimated经历了很多产品的考验，统统都可以应对。
但是光凭上面的知识肯定是不够的，以下是更详细说明文档。**

- [骨架屏缓存策略](https://juejin.im/post/5d86d16ce51d4561fa2ec135)
- [问答文档和集成注意点](https://www.jianshu.com/p/34417897915a)
- [历史更新文档](https://www.jianshu.com/p/e3e9ea295e8a)
- [动画下标解释文档](https://www.jianshu.com/p/8c361ba5aa18)
- [豆瓣效果使用地址](https://www.jianshu.com/p/1a92158ce83a)
- [嵌套视图说明地址](https://www.jianshu.com/p/cf8e37195c11)
- [预览骨架效果工具库，异步调整无需编译即可看到效果](https://juejin.im/post/5d73d3e5e51d453b730b0fb9)


## 最后强调：

- 有问题要先看[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)和文档哈，基本都有～
- demo也只是引导的作用，你可以自己设置出更精美的效果
- 如有使用问题，优化建议等，可以直接提issue，可以加交流群反馈: 304543771

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
