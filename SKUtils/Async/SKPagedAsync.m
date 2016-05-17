//
//  SKPagedAsync.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPagedAsync_Protected.h"

@interface SKPagedAsync ()

@end

@implementation SKPagedAsync

- (nonnull instancetype)init {
    self = [super init];
    _cache = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)pagedList:(BOOL)refresh extend:(BOOL)extend cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKPagedListRequest)request success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    SKPagedList *cachedPagedList = [_cache objectForKey:cacheKey];
    
    if(refresh || (!cachedPagedList) || (extend && !cachedPagedList.finished) ) {
        if(!cachedPagedList) {
            cachedPagedList = [[SKPagedList alloc] init];
        }
        
        dispatch_async(_workerQueue, ^{
            NSError *error = request(cachedPagedList);
            
            if(!error) {
                [_cache setObject:cachedPagedList forKey:cacheKey];
            }
            
            dispatch_async(_callbackQueue, ^{
                if(error) {
                    failure(error);
                } else {
                    success(cachedPagedList.list, cachedPagedList.finished);
                }
            });
        });
    } else {
        dispatch_async(_callbackQueue, ^{
            success(cachedPagedList.list, cachedPagedList.finished);
        });
    }
}

@end
