//
//  SKCachedAsync_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/6/3.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKCachedAsync.h"

typedef id _Nullable (^SKObjectRequest)(NSError * _Nullable * _Nullable errorPtr);
typedef void (^SKAsyncObjectRequest)(SKObjectCallback _Nonnull success, SKErrorCallback _Nonnull failure);

@interface SKCachedAsync () {
@protected
    NSMutableDictionary *_cache;
}

@property(nonatomic, strong, readonly, nonnull) NSMutableDictionary *cache;

@end