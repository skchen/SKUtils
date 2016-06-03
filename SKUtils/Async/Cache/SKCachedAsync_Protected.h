//
//  SKCachedAsync_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/3.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKCachedAsync.h"

@interface SKCachedAsync () {
@protected
    NSMutableDictionary *_cache;
}

@property(nonatomic, strong, readonly, nonnull) NSMutableDictionary *cache;

@end