//
//  SKPagedAsync_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPagedAsync.h"
#import "SKAsync_Protected.h"

typedef id<SKPagedList> _Nonnull (^SKPagedListInitial)(void);
typedef NSError * _Nullable (^SKPagedListRequest)(id<SKPagedList> _Nonnull pagedList);

@interface SKPagedAsync ()

@property(nonatomic, strong, readonly, nonnull) NSMutableDictionary *cache;

- (void)pagedList:(BOOL)refresh extend:(BOOL)extend cacheKey:(nonnull id<NSCopying>)cacheKey initial:(nonnull SKPagedListInitial)initial request:(nonnull SKPagedListRequest)request success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure;

@end