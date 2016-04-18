//
//  SKLruArray.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruArray.h"

@interface SKLruArray ()

@property(nonatomic, copy, readonly, nonnull) NSMutableArray *storage;

- (void)checkSpill;

@end

@implementation SKLruArray

- (nonnull instancetype)init {
    return [self initWithConstraint:0];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint {
    self = [super init];
    
    _constraint = constraint;
    _cost = 0;
    
    _storage = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)setConstraint:(NSUInteger)constraint {
    _constraint = constraint;
    [self checkSpill];
}

- (NSUInteger)count {
    return [_storage count];
}

- (void)setCoster:(id<SKLruCoster>)coster {
    @synchronized(self) {
        _coster = coster;
        
        if(_coster) {
            _cost = 0;
            for(id object in _storage) {
                _cost += [coster costForObject:object];
            }
        } else {
            _cost = _storage.count;
        }
    }
}

- (void)touchObject:(id)object {
    @synchronized(self) {
        if([_storage containsObject:object]) {
            [_storage removeObject:object];
        } else {
            NSUInteger costOfObject = (_coster)?([_coster costForObject:object]):(1);
            _cost += costOfObject;
        }
        
        [_storage insertObject:object atIndex:0];
        
        [self checkSpill];
    }
}

- (nullable id)lastObject {
    return [_storage lastObject];
}

- (void)removeObject:(nonnull id)object {
    @synchronized(self) {
        if([_storage containsObject:object]) {
            [_storage removeObject:object];
            _cost -= [_coster costForObject:object];
        }
    }
}

- (void)removeLastObject {
    @synchronized(self) {
        id lastObject = [_storage lastObject];
        [_storage removeLastObject];
        _cost -= [_coster costForObject:lastObject];
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [_storage removeAllObjects];
        _cost = 0;
    }
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [super init];
    
    _constraint = [[aDecoder decodeObjectForKey:@"constraint"] unsignedIntegerValue];
    _storage = [aDecoder decodeObjectForKey:@"storage"];
    _cost = _storage.count;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_constraint) forKey:@"constraint"];
    [aCoder encodeObject:_storage forKey:@"storage"];
}

#pragma mark - Local

- (void)checkSpill {
    if(_constraint>0) {
        NSLog(@"Cost/Constraint: %@/%@", @(_cost), @(_constraint));
        
        while(_cost>_constraint) {
            id objectToSpill = [_storage lastObject];
            [_storage removeObject:objectToSpill];
            _cost -= [_coster costForObject:objectToSpill];
            
            if([_spiller respondsToSelector:@selector(onSpilled:)]) {
                [_spiller onSpilled:objectToSpill];
            }
        }
    }
}

@end
