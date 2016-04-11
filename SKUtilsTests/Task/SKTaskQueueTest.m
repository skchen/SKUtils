//
//  SKTaskQueueTest.m
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/26.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKTaskQueue.h"

@import OCMockito;

@interface SKTaskQueueTest : XCTestCase

@property(nonatomic, strong) SKTaskQueue *taskQueue;

@property(nonatomic, strong) SKOrderedDictionary *taskArray;
@property(nonatomic, strong) SKTask *mockTask1;
@property(nonatomic, strong) SKTask *mockTask2;
@property(nonatomic, strong) SKTask *mockTask2r;
@property(nonatomic, strong) SKTask *mockTask3;

@end

@implementation SKTaskQueueTest {
    NSString *mockTask1Id;
}

- (void)setUp {
    [super setUp];
    
    _taskArray = [[SKOrderedDictionary alloc] init];
    
    mockTask1Id = @"Task1";
    _mockTask1 = mock([SKTask class]);
    [given([_mockTask1 id]) willReturn:mockTask1Id];
    [given([_mockTask1 block]) willReturn:^{
        NSLog(@"Task1");
    }];
    
    id mockTask2Id = @"Task2";
    _mockTask2 = mock([SKTask class]);
    [given([_mockTask2 id]) willReturn:mockTask2Id];
    [given([_mockTask2 block]) willReturn:^{
        NSLog(@"Task2");
    }];
    
    //id mockTask2rId = @"Task2";
    _mockTask2r = mock([SKTask class]);
    [given([_mockTask2r id]) willReturn:mockTask2Id];
    [given([_mockTask2r block]) willReturn:^{
        NSLog(@"Task2r");
    }];
    
    id mockTask3Id = @"Task3";
    _mockTask3 = mock([SKTask class]);
    [given([_mockTask3 id]) willReturn:mockTask3Id];
    [given([_mockTask3 block]) willReturn:^{
        NSLog(@"Task3");
    }];
    
    _taskQueue = [[SKTaskQueue alloc] initWithOrderedDictionary:_taskArray andConstraint:0 andQueue:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldAddTask {
    // given
    _taskQueue.suspended = YES;
    
    // when
    [_taskQueue addTask:_mockTask1];
    [_taskQueue addTask:_mockTask2];
    [_taskQueue addTask:_mockTask3];
    _taskQueue.suspended = NO;
    
    // should
    [NSThread sleepForTimeInterval:(double)1];
    [verify(_mockTask1) block];
    [verify(_mockTask2) block];
    [verify(_mockTask3) block];
}

- (void)test_shouldInsertTask {
    // given
    _taskQueue.suspended = YES;
    
    // when
    [_taskQueue insertTask:_mockTask1];
    [_taskQueue insertTask:_mockTask2];
    [_taskQueue insertTask:_mockTask3];
    _taskQueue.suspended = NO;
    
    // should
    [NSThread sleepForTimeInterval:(double)1];
    [verify(_mockTask3) block];
    [verify(_mockTask2) block];
    [verify(_mockTask1) block];
}

- (void)test_shouldInsertTask_whenTaskIsAlreadyInQueue {
    // given
    _taskQueue.suspended = YES;
    
    // when
    [_taskQueue addTask:_mockTask1];
    [_taskQueue addTask:_mockTask2];
    [_taskQueue insertTask:_mockTask3];
    [_taskQueue insertTask:_mockTask2r];
    _taskQueue.suspended = NO;
    
    // should
    [NSThread sleepForTimeInterval:(double)1];
    [verify(_mockTask2r) block];
    [verify(_mockTask3) block];
    [verify(_mockTask1) block];
    
    [verifyCount(_mockTask2, never()) block];
}

- (void)test_shouldAddTask_whenTaskIsAlreadyInQueue {
    // given
    _taskQueue.suspended = YES;
    
    // when
    [_taskQueue addTask:_mockTask1];
    [_taskQueue addTask:_mockTask2];
    [_taskQueue addTask:_mockTask3];
    [_taskQueue addTask:_mockTask2r];
    _taskQueue.suspended = NO;
    
    // should
    [NSThread sleepForTimeInterval:(double)1];
    [verify(_mockTask1) block];
    [verify(_mockTask2r) block];
    [verify(_mockTask3) block];
    
    [verifyCount(_mockTask2, never()) block];
}

- (void)test_shouldNotInsertTask_whenTaskIsExecuting {
    SKTask *mockExecuting = mock([SKTask class]);
    [given([mockExecuting id]) willReturn:mockTask1Id];
    SKOrderedDictionary *mockOrderedDictionary = mock([SKOrderedDictionary class]);
    [_taskQueue setValue:mockExecuting forKey:@"executing"];
    [_taskQueue setValue:mockOrderedDictionary forKey:@"taskArray"];
    
    [_taskQueue insertTask:_mockTask1];
    [NSThread sleepForTimeInterval:(double)1];
    
    [verifyCount(mockOrderedDictionary, never()) insertObject:_mockTask1 atIndex:0 forKey:mockTask1Id];
}

- (void)test_shouldNotAddTask_whenTaskIsExecuting {
    SKTask *mockExecuting = mock([SKTask class]);
    [given([mockExecuting id]) willReturn:mockTask1Id];
    SKOrderedDictionary *mockOrderedDictionary = mock([SKOrderedDictionary class]);
    [_taskQueue setValue:mockExecuting forKey:@"executing"];
    [_taskQueue setValue:mockOrderedDictionary forKey:@"taskArray"];
     
    [_taskQueue addTask:_mockTask1];
    [NSThread sleepForTimeInterval:(double)1];
    
    [verifyCount(mockOrderedDictionary, never()) addObject:_mockTask1 forKey:mockTask1Id];
}

@end
