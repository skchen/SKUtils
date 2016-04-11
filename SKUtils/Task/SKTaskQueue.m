//
//  SKTaskQueue.m
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/26.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKTaskQueue.h"

@interface SKTaskQueue ()

@property(nonatomic, strong) SKTask *executing;
@property(nonatomic, strong) SKOrderedDictionary *taskArray;
@property(nonatomic, copy) dispatch_queue_t queue;

- (SKTask *)popTask;
- (void)dispatchTasks;

@end

@implementation SKTaskQueue

+ (SKOrderedDictionary *)defaultOrderedDictionary {
    return [[SKOrderedDictionary alloc] init];
}

+ (dispatch_queue_t)defaultQueue {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return dispatch_queue_create([bundleIdentifier UTF8String], NULL);
}

- (nonnull instancetype)initWithOrderedDictionary:(nullable SKOrderedDictionary *)taskArray andConstraint:(NSUInteger)constraint andQueue:(nullable dispatch_queue_t)queue {
    self = [super init];
    
    if(taskArray) {
        _taskArray = taskArray;
    } else {
        _taskArray = [SKTaskQueue defaultOrderedDictionary];
    }
    
    if(queue) {
        _queue = queue;
    } else {
        _queue = [SKTaskQueue defaultQueue];
    }
    
    _constraint = constraint;
    
    _suspended = NO;
    _executing = nil;
    
    return self;
}

- (nonnull instancetype)init {
    return [self initWithOrderedDictionary:nil andConstraint:0 andQueue:nil];
}

- (void)setSuspended:(BOOL)suspended {
    _suspended = suspended;
    if(!_suspended) {
        [self dispatchTasks];
    }
}

- (void)insertTask:(SKTask *)task {
    if(task.id!=_executing.id) {
        @synchronized(self) {
            [_taskArray insertObject:task atIndex:0 forKey:task.id];
            
            if(_constraint>0 && _taskArray.count>_constraint) {
                [_taskArray removeLastObject];
            }
        }
        [self dispatchTasks];
    }
}

- (void)addTask:(SKTask *)task {
    if(task.id!=_executing.id) {
        @synchronized(self) {
            if(_constraint==0 || _taskArray.count<_constraint) {
                [_taskArray addObject:task forKey:task.id];
            }
        }
        [self dispatchTasks];
    }
}

- (void)removeTask:(SKTask *)task {
    @synchronized(self) {
        [_taskArray removeObjectForKey:task.id];
    }
}

- (void)cancelAllTasks {
    @synchronized(self) {
        [_taskArray removeAllObjects];
    }
}

- (SKTask *)popTask {
    @synchronized(self) {
        if([_taskArray count]>0) {
            SKTask *task = [_taskArray objectAtIndex:0];
            if(task) {
                [_taskArray removeObjectForKey:task.id];
            }
            return task;
        }
        return nil;
    }
}

- (void)dispatchTasks {
    @synchronized (self) {
        if(!_executing && !_suspended) {
            SKTask *firstTask = [self popTask];
            if(firstTask) {
                _executing = firstTask;
                dispatch_async(_queue, ^{
                    _executing.block();
                    _executing = nil;
                    
                    [self dispatchTasks];
                });
            }
        }
    }
}

@end
