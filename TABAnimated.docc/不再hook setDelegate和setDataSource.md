## 不再hook setDelegate和setDataSource

TABAnimated从起初的版本开始，为了对`UITableView `和`UICollectionView `进行弱管理，采取了hook的方式，其中包含UITableView和UICollectionView的`setDelegate`和`setDataSource`方法。

后来，发现使用xib/sb创建的UITableView/UICollectionView，在关联代理对象的时候，并不会调用`setDelegate`和`setDataSource`方法。这里笔者认为，这种方式只是将指针地址改变，苹果工程师对xib/sb进行了一定的管理。

与此同时，未免部分开发者会在开启动画前`多次设置`了不同源代理，所以这样的技术方案存在一定的`安全隐患`，是不合理的。

在最新的版本中，将相关的代理方法的hook时机延迟到了目标视图第一次启动TABAnimated骨架屏的时候。

## 适配自适应高度是如何做的？

**答：**实际上采用的是，为代理对象手动加入`heightForRowAtIndexPath`这一实例方法，让其在动画时，遵循指定高度规则，在动画结束后，遵循自动高度规则。

#### 在此过程中发现了一个值得关注的问题

**答：**发现在进行addMethod，交换IMP地址，这些操作后，只有首次加载不走`heightForRowAtIndexPath`方法，也就是在第一次就没办法按照我们说好的规则运行：`在动画时，遵循指定高度规则，在动画结束后，遵循自动高度`。

**是什么原因造成的？解决方案是什么？**

有个关键要素，为什么通过hook setDelegate 的方式，首次加载就可以呢？

随后，笔者打印了缓存的方法列表，发现在首次交换方法后，`heightForRowAtIndexPath`也是存在于方法列表中的。

而之前hook`setDelegate`方法，在交换了方法后，又对`delegate`重新进行了赋值操作。因此，笔者在此时对UITableView重新赋值delegate，问题得以解决。

**结论：同xib/sb那个问题一样，xib/sb在切换源代理的时候，并不会走`setDelegate`和`setDataSource`方法。
OC基于方法列表本身有一套缓存机制，在重新赋值delegate后，苹果工程师又对于UITableView/UICollectionView做了相应的调整。**
