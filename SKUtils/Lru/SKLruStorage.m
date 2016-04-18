//
//  SKLruStorage.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKLruStorage.h"

@interface SKLruStorage () <SKLruTableSpiller>

@property(nonatomic, copy, readonly, nonnull) SKLruDictionary *urlLruTable;

@end

@implementation SKLruStorage

- (id)init {
    return [self initWithConstraint:0];
}

- (nonnull instancetype)initWithConstraint:(NSUInteger)constraint {
    self = [super initWithConstraint:constraint];
    
    _fileManager = [NSFileManager defaultManager];
    
    _urlLruTable = [[SKLruDictionary alloc] initWithConstraint:constraint];
    _urlLruTable.spiller = self;
    
    return self;
}

- (NSUInteger)constraint {
    return _urlLruTable.constraint;
}

- (void)setConstraint:(NSUInteger)constraint {
    _urlLruTable.constraint = constraint;
}

- (NSUInteger)count {
    return _urlLruTable.count;
}

- (NSUInteger)cost {
    return _urlLruTable.cost;
}

- (void)setCoster:(id<SKLruCoster>)coster {
    [_urlLruTable setCoster:coster];
}

- (nullable id)objectForKey:(nonnull id<NSCopying>)key {
    @synchronized (self) {
        NSString *path = [_urlLruTable objectForKey:key];
        if(path) {
            if([_fileManager fileExistsAtPath:path]) {
                return path;
            } else {
                [_urlLruTable removeObjectForKey:key];
            }
        }
        
        return nil;
    }
}

- (void)setObject:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    @synchronized (self) {
        NSString *path = (NSString *)object;
        if([_fileManager fileExistsAtPath:path]) {
            [_urlLruTable setObject:path forKey:key];
        }
    }
}

- (void)removeObjectForKey:(nonnull id<NSCopying>)key {
    @synchronized (self) {
        NSString *path = [_urlLruTable objectForKey:key];
        [_urlLruTable removeObjectForKey:key];
        
        if(path) {
            [_fileManager removeItemAtPath:path error:nil];
        }
    }
}

- (void)removeAllObjects {
    @synchronized (self) {
        NSArray *paths = [_urlLruTable allValues];
        for(NSString *path in paths) {
            [_fileManager removeItemAtPath:path error:nil];
        }
        [_urlLruTable removeAllObjects];
    }
}

#pragma mark - NSCoding

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    _fileManager = [NSFileManager defaultManager];
    
    _urlLruTable = [aDecoder decodeObjectOfClass:[SKLruDictionary class] forKey:@"urlLruTable"];
    _urlLruTable.spiller = self;
    
    NSArray *keys = [_urlLruTable allKeys];
    for(id<NSCopying> key in keys) {
        [self objectForKey:key];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_urlLruTable forKey:@"urlLruTable"];
}

#pragma mark - SKLruTableSpiller

- (void)onSpilled:(nonnull id)object forKey:(nonnull id<NSCopying>)key {
    @synchronized(self) {
        NSLog(@"SKLruStorage.onSpilled:%@ forKey:%@", object, key);
        NSString *path = (NSString *)object;
        [_fileManager removeItemAtPath:path error:nil];
        [_spiller onSpilled:object forKey:key];
    }
}

@end
