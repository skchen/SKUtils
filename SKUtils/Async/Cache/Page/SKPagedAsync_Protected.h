//
//  SKPagedAsync_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPagedAsync.h"
#import "SKAsync_Protected.h"
#import "SKCachedAsync_Protected.h"

typedef void (^SKWrappedPagedListCallback)(id<SKPagedList> _Nonnull pagedList);

typedef id<SKPagedList> _Nullable (^SKPagedListRequest)(id<SKPagedList> _Nullable pagedList, NSError * _Nullable * _Nullable errorPtr);
typedef void (^SKAsyncPagedListRequest)(id<SKPagedList> _Nullable pagedList, SKWrappedPagedListCallback _Nonnull success, SKErrorCallback _Nonnull failure);

@interface SKPagedAsync ()

- (void)pagedList:(BOOL)refresh extend:(BOOL)extend cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKPagedListRequest)request success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;
- (void)pagedListAsync:(BOOL)refresh extend:(BOOL)extend cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKAsyncPagedListRequest)request success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;

- (nonnull NSString *)cacheKeyWithElements:(NSUInteger)numberOfElements, ...;

@end