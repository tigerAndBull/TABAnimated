//
//  TABAnimatedProductDefines.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/14.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedProductDefines_h
#define TABAnimatedProductDefines_h

typedef NS_ENUM(NSUInteger, TABAnimatedProductOrigin) {
    
    // UIView
    TABAnimatedProductOriginView,

    // TableViewCell
    TABAnimatedProductOriginTableViewCell,
    
    // TableHeaderFooterView
    TABAnimatedProductOriginTableHeaderFooterView,
    
    // TableHeaderFooterCell
    TABAnimatedProductOriginTableHeaderFooterViewCell,
    
    // CollectionViewCell
    TABAnimatedProductOriginCollectionViewCell,
    
    // CollectionReuseableHeaderView
    TABAnimatedProductOriginCollectionReuseableHeaderView,
    
    // CollectionReuseableFooterView
    TABAnimatedProductOriginCollectionReuseableFooterView,
};

typedef NS_ENUM(NSInteger, TABAnimatedProductionState) {
    
    // Production刚被创建
    TABAnimatedProductionCreate = 0,
    
    // Production需要加工
    TABAnimatedProductionProcess,
    
    // Production已绑定view
    TABAnimatedProductionBind,
};

typedef NS_ENUM(NSInteger, TABAnimatedProductionPoolState) {
    
    // Production不存在
    TABAnimatedProductionPoolDefault = 0,
    
    // Production被创建
    TABAnimatedProductionPoolCreate,
    
    // Production生产流程结束
    TABAnimatedProductionPoolProcessed,
};

typedef NS_ENUM(NSUInteger, TABAnimatedProductType) {
    // 从未被生产，初次生产, 生产行为
    TABAnimatedProductFirst,
    // 正在生产中，等待复用
    TABAnimatedProductReuseWait,
    // 以前有生产过，读取复用
    TABAnimatedProductReuseByHistory,
    // 不使用复用机制，生产行为
    TABAnimatedProductReuseNever,
};

#endif /* TABAnimatedProductDefines_h */
