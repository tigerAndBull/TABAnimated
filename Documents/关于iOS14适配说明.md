## TABAnimated对于iOS14的适配说明

## 背景

`TABAnimated`是一个自动化生成骨架屏的工具。  
骨架屏是一个定制化程度较高的需求。而`TABAnimated`的自动生成策略和开发者的自定制需求天然地存在冲突。  
所以在自动化生成元素之后，为开发者开了一个定制接口，引入了**调整回调（adjustBlock）**

又因为自定制本身需要的是定制某个动画元素，此时需要定位这个动画元素。  
所以引入了**tagIndex（递归深度下标）**，用于标记动画元素，定义某个元素是哪一个。

**所以，一旦iOS系统原始的图层发生变化，TABAnimated则需要进行适配，以保证与旧的tagIndex匹配**

因为涉及到新的处理策略，旧的错误说明，所以本文特地做一个简要说明。

## iOS14系统变化

iOS14对`UITableViewCell`，`UITableViewHeaderFooterView`等类型视图做了调整。  
以`UITableViewCell`为例，其增加了一个与`UITableViewCellContentView`同级的view，其class类型为`_UISystemBackgroundView`。

与此同时，在`_UISystemBackgroundView`之上，又加上了一个与之大小一致的UIView，这个view的唯一特征是和_UISystemBackgroundView的大小一样。

![cell结构图.png](https://upload-images.jianshu.io/upload_images/5632003-88dfa4d807289cb0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 隐藏问题和初步适配策略

因为`_UISystemBackgroundView`的class类型是特殊的，所以可以通过className过滤掉。还需要把`_UISystemBackgroundView`上的UIView移除掉，才能完全解决这个问题。    
这个view它主要有两种特征，一个是大小和`_UISystemBackgroundView`一致，另一个是位于`_UISystemBackgroundView`的subViews栈底。  
因为我们无法预测iOS的视图层级是否还会发生变化，所以采取了第一种策略。  

**在多种视图的测试下，发现`_UISystemBackgroundView`仍然具备特殊性，它在高度为浮点数的场景下，会比原始的TableViewCell高零点几pt，但也不是取整造成的。**


所以不得不更改过滤策略，将宽高大于TableViewCell的view也过滤掉。

过滤代码如下：

```
if ((CGRectEqualToRect(view.bounds, rootView.bounds)
	|| view.bounds.size.width > rootView.bounds.size.width
	|| view.bounds.size.height > rootView.bounds.size.height)) {
	return YES;
}
```

## TABAnimated的旧错误及兼容策略

**背景：**在自动化生成的策略中，当视图的组件很多（包含隐藏组件），大概率存在动画元素局部覆盖，同时有很多元素不会被开发者用到，所以增加了筛选策略，对于宽高小于3pt的动画元素进行自动过滤，同时支持过滤条件自定制。  

因为`UITableViewCell`最早就包含`UITableViewCellContentView`，所以早期直接过滤了这个视图，并且不会生成动画元素，我把它定义为**根源性移除**。但是对于宽高过滤机制而言，使用**根源性移除**会产生歧义，所以在生成了动画元素的基础之上，采取了**标记移除**。 
 
**所以TABAnimated有两种移除策略，一种是根源性移除，另一种是标记移除。**
  
TABAnimated的旧错误在于，将`_UITableViewHeaderFooterContentView`进行了标记移除。而根据上述的定义，毫无疑问应该使用根源性移除。此次增加的过滤条件，`_UITableViewHeaderFooterContentView`又完美符合了（**会先被根源性移除**）。为了向下兼容，我们必须将其进行标记移除，不然tagIndex会和过去的不一致，所以我们必须过滤掉`_UITableViewHeaderFooterContentView`。

完整过滤代码如下

```
if ((CGRectEqualToRect(view.bounds, rootView.bounds)
	|| view.bounds.size.width > rootView.bounds.size.width
	|| view.bounds.size.height > rootView.bounds.size.height)
	&& ![view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterContentView") class]]) {
	return YES;
}
```

不得不保留旧的标记移除条件

```
// 标记移除
if ([view isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]  ||
	[view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterContentView") class]]) {
	needRemove = YES;
}
```

#### 所以，此处的逻辑有些怪异，这都是为了弥补过去不合理的逻辑造成的，但是我们又必须向下兼容。希望后续的朋友看到此处代码，不要太无语。