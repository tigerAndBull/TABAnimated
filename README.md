如果你此时看到这里你必须要知道，
将在五一期间发布一个比较重要的版本，合并当前两大模式。

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

#### the lastest version is 2.0.3.2 [中文文档](https://www.jianshu.com/p/6a0ca4995dff)

* [About TABAnimated](#About-TABAnimated)
* [Realization Principle](#Realization-Principle)
* [TABAnimated has two patterns](#TABAnimated-has-two-patterns)
* [Features](#Features)
* [Install](#Install)  
  * [Cocoapods](#Using-CocoaPods)
  * [Manually](#Manually)
* [Effect Drawing](#Effect-Drawing)
* [How to use](#How-to-use)
  * [Use Template Pattern](#Use-Template-Pattern)
  * [Use Normal Pattern](#Use-Normal-Pattern)
* [Tips](#Tips)
* [Properties](#More-Global-Properties)
* [Author](#Author)
* [Hope](#Hope)
* [License](#License)

## About TABAnimated

The origin of `TABAnimated` by imitating [jianshu](https://www.jianshu.com/) animation in chinese palform early, i was attracted by its dynamics in Mid 2018.
But i remove it over version 2.0, because i changed the realization principle of `TABAnimated` to cut coupling.

## Realization Principle

`TABAnimated` needs a control view, the view used to start or end animations.
all subviews onto the control view added to the animation queue acquiescently. 
Of course, you can remove specific views without the animation queue.
`TABAnimated` create a group of `TABLayer` according to their position.
(`TABLayer` is the subclass of `CALayer`.)

Almost all views can be resolved by `TABAnimated`.

When views have not enough condition to know position with none data, 
`TABAnimated` can use default data to fill them up. 

## TABAnimated has two patterns

Which two kinds?

Nomal pattern and template pattern.

Why?

First, for a normal view, there is no distinction between patterns. you do not care it.
The concept of the template pattern is for tableView and collectionView only.

In most cases, if `TABAnimated` create animations by origin views' position, the animation is not beautiful,
but you just need to make the right adjustments to look good by `TABAnimated`.
so, if you don't care coupling in your project, you can use normal pattern.
If you care coupling, you can use normal pattern. Meanwhile, you need create a new template file.

## Features

-  Use three seconds to integrate it
-  Zero coupling
-  High Performance
-  All views you can see
-  Fully customized
-  Code is beautiful

## Install

#### Using CocoaPods

```
pod 'TABAnimated'
```
#### Manually

Drag the folder named by `TABAnimated` to your project

## Effect Drawing

<table>
<tr>
<td width="20%">
<center>Template - card</center>
</td>
<td width="20%">
<center>Template - bin</center>
</td>
<td width="20%">
<center>Template - shimmer</center>
</td>
<td width="20%">
<center>Template - segment</center>
</td>
<td width="20%">
<center>Normal - skeleton</center>
</td>
</tr>
<tr>
<td width="20%">
<img src="https://upload-images.jianshu.io/upload_images/5632003-47f991e3d8729075.gif"></img>
</td>
<td width="20%">
<img src="https://upload-images.jianshu.io/upload_images/5632003-f05eaec5e159df0d.gif"></img>
</td>
<td width="20%">
<img src="https://upload-images.jianshu.io/upload_images/5632003-dc5980b6178839c5.gif"></img>
</td>
<td width="20%">
<img src="https://upload-images.jianshu.io/upload_images/5632003-f50be5a34e12dfd1.gif"></img>
</td>
<td width="20%">
<img src="https://upload-images.jianshu.io/upload_images/5632003-7249862124eb2d76.gif"></img>
</td>
</tr>
</table>

## How to use

you need only 4 steps

1. import 'TABAnimated.h', advise you to set it on `.pch`
2. init `TABAimated` on `didFinishLaunchingWithOptions`

```
// init `TABAnimated`, and set the properties you need.
[[TABViewAnimated sharedAnimated] initWithOnlySkeleton];
// demo changes the pattern quietly.
// you can change the pattern in different views.
[TABViewAnimated sharedAnimated].isUseTemplate = YES;
// open log
[TABViewAnimated sharedAnimated].openLog = YES;
// set gobal cornerRadius
[TABViewAnimated sharedAnimated].animatedCornerRadius = 3.f;
```

3. [self.rootControlView tab_startAnimation];
4. [self.rootControlView tab_endAnimation];

But evevryone have different views, `TABAnimated` used to solve the problem better.

#### Use Template Pattern

Template pattern on `UITableView` and `UICollectionView` only.
Normal view looks like a superfluous move when useing template pattern.

1.set `TABAnimatedObject` properties

```
_collectionView.tabAnimated = [TABAnimatedObject animatedWithTemplateClass:[TABTemplateCollectionViewCell class] animatedCount:4];
```

TABAnimatedObject init methods

```
/**
 one section
 animation count full contentSize
 
 @param templateClass
 @return TABAnimatedObject.new
 */
+ (instancetype)animatedWithTemplateClass:(Class)templateClass;

/**
 one section
 specific animation count
 
 @param templateClass TABAnimatedObject.new
 @param animatedCount
 @return object
 */
+ (instancetype)animatedWithTemplateClass:(Class)templateClass
                            animatedCount:(NSInteger)animatedCount;

/**
 sections

 @param templateClassArray
 @param animatedCountArray
 @return object
 */
+ (instancetype)animatedWithTemplateClassArray:(NSArray <Class> *)templateClassArray
                            animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;
```

the array has security handling:

when animatedCountArray.count > section.count，the extra on animatedCountArray is not effective.
when animatedCountArray.count < section.count，the financial departments load by animatedCountArray.lastobject.

2. create template

UITableViewCell
> + create new cell，inherit `TABBaseTableViewCell`
> + override `+ (NSNumber *)cellHeight` to set cellHeight
> + init subviews on it，and set positions

UICollectionViewCell
> + create new cell，inherit `继承自TABBaseCollectionViewCell`
> + override `+ (NSValue *)cellSize` to set cellSize
> + init subviews on it，and set positions

3. [self.collectionView tab_startAnimation];
4. [self.collectionView tab_endAnimation];

##### tips: TABAnimatedObject have more properties, you can find them on `TABAnimatedObject.h`.

#### Use Normal Pattern

1. set properties

```
TABAnimatedObject *tabAnimated = TABAnimatedObject.new;
tabAnimated.animatedCount = 3;
_tableView.tabAnimated = tabAnimated;
```

2. use `loadStyle` - `TABViewLoadAnimationRemove`, cancel add

```
UILabel *lab = [[UILabel alloc]init];
[lab setFont:tab_kFont(15)];
lab.loadStyle = TABViewLoadAnimationRemove;   // remove it
[lab setTextColor:[UIColor blackColor]];    
self.titleLab = lab;
[self.contentView addSubview:lab];
```

3. [self.collectionView tab_startAnimation];
4. [self.collectionView tab_endAnimation];

## Tips

when using on normal pattern

1. specificing when having none data.

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (!_tableView.tabAnimated.isAnimating) {
        [cell initWithData:dataArray[indexPath.row]];
    }

    return cell;
}
```

2. same as 1, you can also do by the following method.

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

3. set animatedDelegate or set `animatedCountArray`

(1) `UITableViewAnimatedDelegate` and `UICollectionViewAnimatedDelegate`
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

(2) self.tableView.tabAnimated.animatedCountArray = @[@(3),@(3)];

4. nest about tableView or collectionView

```
_collectionView.tabAnimated.isNest = YES;
```

## More Global Properties

| init methods| name | 
| ------ | ------ | 
| initWithOnlySkeleton | only Skeleton | 
| initWithBinAnimation | bin Animation | 
| initWithShimmerAnimated | Shimmer Animation | 

If you set the control view `superAnimationType`, the animation type of the control view according to `superAnimationType`.

| name | pattern | animation| default|
| ------ | ------ |  ------ | ------ |
|animatedColor| common |common|0xEEEEEE |
|animatedDurationShimmer|common|shimmer animation| 1.5 |
|animatedHeightCoefficient|common|common|0.75|
|animatedCornerRadius|common|common|0.|
|templateTableViewCell|pattern|common|0.|
|templateCollectionViewCell| pattern|common|0.|

## Author

email:1429299849@qq.com

## Hope

Demo is just a simple example I wrote, you can use the framework to play a more attractive effect. It has gone through many projects. This framework can solve all the problems in your project, conquer it quickly!

If you have any questions or suggestions, you can contact me by email. I'm looking forward to it.
Surely, you can also push your code to me on this.

## License

```
MIT License

Copyright (c) 2019 tigerAndBull

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
```
