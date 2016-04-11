//
//  SKTaskQueue.h
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/26.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SKUtils/SKOrderedDictionary.h>
#import "SKTask.h"

@interface SKTaskQueue : NSObject

@property(nonatomic, assign) BOOL suspended;
@property(nonatomic, assign) NSUInteger constraint;

- (nonnull instancetype)initWithOrderedDictionary:(nullable SKOrderedDictionary *)taskArray andConstraint:(NSUInteger)constraint andQueue:(nullable dispatch_queue_t)queue;

/**
 Insert task to the beginning of task queue
 @param task    task to insert
 */
- (void)insertTask:(nonnull SKTask *)task;

/**
 Add task to the end of task queue
 @param task    task to add
 */
- (void)addTask:(nonnull SKTask *)task;

/**
 Remove task
 @param task    task to remove
 */
- (void)removeTask:(nonnull SKTask *)task;

/**
 Remoev all tasks in task queue
 */
- (void)cancelAllTasks;

@end
