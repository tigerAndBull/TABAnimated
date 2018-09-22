**2018 - 09 - 22 重大更新！你一定会爱上这个库！！！**

**你或许只需要干2件事，就可以让所有组件在网络卡顿时动起来！！！**

>1. 注册需要动画的组件
>2. 父视图控制动画的开关

*******************************

**2018 - 09 - 20晚 更新一次**

**更新内容：**

>1. 动画支持所有继承自UIView的组件，以前仅支持UITableView
>2. 需要动的组件仍需注册一个属性
>3. 可以全局定义动画时长，动画背景色，由类方法改为单例模式

*******************************

## 先上效果图

![效果图.gif](https://upload-images.jianshu.io/upload_images/5632003-716bb8feae7ada1b.gif?imageMogr2/auto-orient/strip)

## 说明

>1. 本文主要讲解如何将[demo](https://github.com/tigerAndBull/LoadAnimatedDemo-ios)集成到你的项目中，并使用，同时也算是抛砖引玉了，大佬们要是有更好的封装方法，求之不得。
>2. 均为个人思考，转载请注明出处，谢谢🙏

## 主要使用的技术

>AOP，即IOS的`Runtime`运行机制的黑魔法

## 使用流程

**第一步**：
将demo的文件夹引入到你的项目中，并在合适位置导入头文件`TABAnimated.h`，建议在`.pch`文件下全局引用

![库内文件.png](https://upload-images.jianshu.io/upload_images/5632003-041894cf6564de8a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**第二步（可选）**：

可以选择在appDelegate的`didFinishLaunchingWithOptions`方法全局设置动画属性，有默认属性，为上面示例图的样子

```
//设置TABAnimated相关属性
[[TABViewAnimated sharedAnimated]initWithAnimatedDuration:0.3 withColor:tab_kBackColor];
```

**第三步**：在需要动画的view上，将属性`animatedStyle`设置为`TABTableViewAnimationStart`,不需要动画的view不用做额外的操作

```
//UIView枚举
typedef NS_ENUM(NSInteger,TABTableViewAnimationStyle) {
    TABTableViewAnimationDefault = 0,     //没有动画，默认
    TABTableViewAnimationStart,           //开始动画
    TABTableViewAnimationEnd              //结束动画
};

//UITableView枚举
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,    //没有动画，默认
    TABViewAnimationStart,          //开始动画
    TABViewAnimationEnd             //结束动画
};

```
```
//UITableView例子
- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mainTV.animatedStyle = TABTableViewAnimationStart;  //开启动画
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

//UIView例子
- (TestHeadView *)headView {
    if (!_headView) {
        _headView = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, 90)];
        _headView.animatedStyle = TABViewAnimationStart;  //开启动画
    }
    return _headView;
}
```

**第四步**：

>1. 将**需要动**的组件的属性`loadStyle`，设置为需要的类型（**不需要动**的组件不用做额外的操作）
>2. （可选）新增属性`tabViewWidth`，其为动画开启时该组件的宽度,有较为合理默认值

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
        [lab setTextColor:[UIColor blackColor]];
        [lab setText:@""];
        
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
[_headView layoutSubviews];
```

**注意点**：

1. 对于table组件，在加载动画的时候，即未获得数据时，不要设置对应的数值

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

2. 没有默认高度，如果高度为0，则没有动画

## 最后：

> + 欢迎在下方谈论，同时，如果觉得对你有所帮助的话，能在github上star一下就更好了
> + 如有问题，可以联系我，qq:1429299849
> + 简书地址：https://www.jianshu.com/p/6a0ca4995dff
