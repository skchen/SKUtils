//
//  SKPagedAsync_Protected.h
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/5/17.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKPagedAsync.h"
#import "SKAsync_Protected.h"
#import "SKPagedList.h"

typedef NSError * _Nullable (^SKPagedListRequest)(SKPagedList * _Nonnull pagedList);

@interface SKPagedAsync ()

@property(nonatomic, strong, readonly, nonnull) NSMutableDictionary *cache;

- (void)pagedList:(BOOL)refresh extend:(BOOL)extend cacheKey:(nonnull id<NSCopying>)cacheKey request:(nonnull SKPagedListRequest)request success:(nonnull SKExtendableListCallback)success failure:(nonnull SKErrorCallback)failure;

@end