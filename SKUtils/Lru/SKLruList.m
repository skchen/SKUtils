//
//  SKLruList.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruList.h"

@interface SKLruList ()

@property(nonatomic, copy, readonly, nonnull) NSMutableArray *storage;

- (void)checkSpill;

@end

@implementation SKLruList

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint andStorage:(nonnull NSMutableArray *)storage andCoster:(nullable id<SKLruListCoster>)coster andSpiller:(nullable id<SKLruListSpiller>)spiller {
    
    self = [super init];
    
    _cost = 0;
    _constraint = constraint;
    _storage = storage;
    _coster = coster;
    _spiller = spiller;
    
    return self;
}

- (NSUInteger)count {
    return [_storage count];
}

- (void)touchObject:(id)object {
    @synchronized(self) {
        if([_storage containsObject:object]) {
            [_storage removeObject:object];
        } else {
            _cost += [_coster costForObject:object];
        }
        
        [_storage insertObject:object atIndex:0];
        
        [self checkSpill];
    }
}

- (void)removeObject:(nonnull id)object {
    @synchronized(self) {
        if([_storage containsObject:object]) {
            [_storage removeObject:object];
            _cost -= [_coster costForObject:object];
        }
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_storage removeAllObjects];
        _cost = 0;
    }
}

#pragma mark - Local

- (void)checkSpill {
    while(_cost>_constraint) {
        id objectToSpill = [_storage lastObject];
        [_storage removeObject:objectToSpill];
        _cost -= [_coster costForObject:objectToSpill];
        
        if([_spiller respondsToSelector:@selector(onSpilled:)]) {
            [_spiller onSpilled:objectToSpill];
        }
    }
}

@end
