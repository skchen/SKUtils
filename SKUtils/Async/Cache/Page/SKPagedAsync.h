//
//  SKPagedAsync.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKCachedAsync.h"

typedef void (^SKPagedListCallback)(NSArray  * _Nonnull list, BOOL finished);

@protocol SKPagedList <NSObject>

@property(nonatomic, strong, readonly, nonnull) NSArray *list;
@property(nonatomic, readonly) BOOL finished;

- (void)append:(nonnull id)newPage;

@end

@interface SKPagedAsync : SKCachedAsync

@end