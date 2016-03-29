//
//  SKLruList.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruList.h"

@interface SKLruList ()

@property(nonatomic, readonly) NSUInteger capacity;
@property(nonatomic, copy, readonly, nonnull) NSMutableArray *storage;
@property(nonatomic, weak, readonly, nullable) id<SKLruListSpiller> spiller;

- (void)checkSpill;

@end

@implementation SKLruList

- (nonnull instancetype)initWithCapacity:(NSUInteger)capacity andSpiller:(nullable id<SKLruListSpiller>)spiller {
    
    self = [super init];
    
    _capacity = capacity;
    _spiller = spiller;
    _storage = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)touchObject:(id)object {
    @synchronized(self) {
        [_storage removeObject:object];
        [_storage insertObject:object atIndex:0];
        
        [self checkSpill];
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_storage removeAllObjects];
    }
}

- (void)checkSpill {
    if([_storage count]>_capacity) {
        id objectToSpill = [_storage lastObject];
        [_storage removeObject:objectToSpill];
        
        if([_spiller respondsToSelector:@selector(onSpilled:)]) {
            [_spiller onSpilled:objectToSpill];
        }
    }
}

@end
