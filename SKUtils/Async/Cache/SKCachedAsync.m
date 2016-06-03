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

- (void)cache:(BOOL)refresh cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKObjectRequest)request success:(nonnull SKObjectCallback)success failure:(nonnull SKErrorCallback)failure {
    
    [self cacheAsync:refresh cacheKey:cacheKey request:^(SKObjectCallback  _Nonnull success, SKErrorCallback  _Nonnull failure) {
        
        dispatch_async(_workerQueue, ^{
            NSError *error = nil;
            
            id object = request(&error);
            
            if(error) {
                failure(error);
            } else {
                success(object);
            }
        });
    } success:success failure:failure];
}

- (void)cacheAsync:(BOOL)refresh cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKAsyncObjectRequest)asyncRequest success:(nonnull SKObjectCallback)success failure:(nonnull SKErrorCallback)failure {
    
    id cachedObject = [_cache objectForKey:cacheKey];
    
    if(refresh || (!cachedObject) ) {
        SKObjectCallback innerSuccess = ^void(id _Nonnull object) {
            [_cache setObject:object forKey:cacheKey];
            
            dispatch_async(_callbackQueue, ^{
                success(object);
            });
        };
        
        SKErrorCallback innerFailure = ^void(NSError * _Nullable error) {
            dispatch_async(_callbackQueue, ^{
                failure(error);
            });
        };
        
        asyncRequest(innerSuccess, innerFailure);
    } else {
        dispatch_async(_callbackQueue, ^{
            success(cachedObject);
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
