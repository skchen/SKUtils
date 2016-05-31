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

    [self pagedListAsync:refresh extend:extend cacheKey:cacheKey request:^(id<SKPagedList>  _Nullable pagedList, SKWrappedPagedListCallback  _Nonnull success, SKErrorCallback  _Nonnull failure) {
        
        dispatch_async(_workerQueue, ^{
            NSError *error = nil;
            
            id<SKPagedList> newPage = request(pagedList, &error);
            
            if(error) {
                failure(error);
            } else {
                success(newPage);
            }
        });
        
    } success:success failure:failure];
}

- (void)pagedListAsync:(BOOL)refresh extend:(BOOL)extend cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKAsyncPagedListRequest)asyncRequest success:(nonnull SKPagedListCallback)success failure:(nonnull SKErrorCallback)failure {
    
    id<SKPagedList> cachedPagedList = [_cache objectForKey:cacheKey];

    if(refresh || (!cachedPagedList) || (extend && !cachedPagedList.finished) ) {
        if( refresh || (!cachedPagedList) ) {
            cachedPagedList = nil;
        }
        
        SKWrappedPagedListCallback innerSuccess = ^void(id<SKPagedList> _Nonnull newPage) {
            id<SKPagedList> _Nonnull appendedPage = cachedPagedList;
            
            if(!appendedPage) {
                appendedPage = newPage;
            } else {
                [appendedPage append:newPage];
            }
            
            [_cache setObject:appendedPage forKey:cacheKey];
            
            dispatch_async(_callbackQueue, ^{
                success(cachedPagedList.list, cachedPagedList.finished);
            });
        };
        
        SKErrorCallback innerFailure = ^void(NSError * _Nullable error) {
            dispatch_async(_callbackQueue, ^{
                failure(error);
            });
        };
        
        asyncRequest(cachedPagedList, innerSuccess, innerFailure);
    } else {
        dispatch_async(_callbackQueue, ^{
            success(cachedPagedList.list, cachedPagedList.finished);
        });
    }
}

- (nonnull NSString *)cacheKeyWithElements:(NSUInteger)numberOfElements, ... {
    NSMutableString *newContentString = [NSMutableString string];
    
    va_list args;
    va_start(args, numberOfElements);
    for(int i=0; i<numberOfElements; i++) {
        if(i>0) {
            [newContentString appendString:@"/"];
        }
        
        NSString *arg = va_arg(args, NSString*);
        if(arg) {
            [newContentString appendString:arg];
        }
    }
    va_end(args);
    
    return newContentString;
}

@end
