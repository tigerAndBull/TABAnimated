//
//  Game.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/15.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game:NSObject

@property (nonatomic,strong) NSString *gameId;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) NSString *cover;

@property (nonatomic,strong) NSString *author;

@property (nonatomic) long long openTime;

@property (nonatomic) long long endTime;

@property (nonatomic) long long erollTime;

@property (nonatomic) long long erollEndTime;

@end
