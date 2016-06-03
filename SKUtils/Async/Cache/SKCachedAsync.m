//
//  SKCachedAsync.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/3.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKCachedAsync_Protected.h"

@interface SKCachedAsync ()

@end

@implementation SKCachedAsync

- (nonnull instancetype)init {
    self = [super init];
    _cache = [[NSMutableDictionary alloc] init];
    return self;
}

@end
