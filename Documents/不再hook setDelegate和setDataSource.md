## 前言

TABAnimated从起初的版本开始，为了对`UITableView `和`UICollectionView `进行弱管理，采取了hook的方式，其中包含UITableView和UICollectionView的`setDelegate`和`setDataSource`方法。

后来，发现使用xib/sb创建的UITableView/UICollectionView，在关联代理对象的时候，并不会调用`setDelegate`和`setDataSource`方法。这里笔者认为，这种方式只是将指针地址改变，苹果工程师对xib/sb进行了一定的管理。

与此同时，未免部分开发者会在开启动画前`多次设置`了不同源代理，这样可能会有`安全隐患`。

所以，在最新的版本中，将相关的代理方法的hook延迟到了实例对象第一次启动动画时，**呈现出的动画元素将会以第一个实例对象启动动画为基准**。

## 适配自适应高度 - 动态代理 时发现一个问题

#### 首先，关于适配自适应高度 - 动态代理采取了什么手段实现的

**答：**实际上采用的是，为代理类对象手动加入`heightForRowAtIndexPath`这一实例方法，让其在动画时，遵循指定高度规则，在动画结束后，遵循自动高度规则。

**PS：后续为属性设置动态高度这种情况，加入了基于系统自适应高度，无需在写死高度的做法，这一类问题后续继续完善。**

#### 在此过程中发现了什么问题？

**答：**发现在进行addMethod，交换IMP地址，这些操作后，只有首次加载不走`heightForRowAtIndexPath`方法，也就是在第一次就没办法按照我们说好的规则：`在动画时，遵循指定高度规则，在动画结束后，遵循自动高度`。

**解决方案是什么？**

有个关键要素，为什么通过hook setDelegate 的方式，首次加载就可以呢？

随后，笔者通过打印缓存的方法列表，发现在首次交换方法后，`heightForRowAtIndexPath`是存在于方法列表中的，也就是之前的步骤都相同，并没有疏漏。

而之前hook的是`setDelegate`，在交换了方法后，又对`delegate`的进行了重新赋值操作。因此，笔者联想到此时重新赋值delegate，问题得以解决。

**结论：同xib/sb那个问题一样，xib/sb在切换源代理的时候，并不会走`setDelegate`和`setDataSource`方法。
OC基于方法列表本身有一套缓存机制，在重新赋值delegate后，苹果工程师对于UITableView/UICollectionView做了相应的调整。**
