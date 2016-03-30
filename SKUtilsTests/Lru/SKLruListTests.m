//
//  SKLruListTest.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruList.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruListTests : XCTestCase

@property(nonatomic, strong) id<SKLruListSpiller> mockSpiller;
@property(nonatomic, strong) SKLruList *list;

@property(nonatomic, strong) id mockObject1;
@property(nonatomic, strong) id mockObject2;
@property(nonatomic, strong) id mockObject3;
@property(nonatomic, strong) id mockObject4;

@end

@implementation SKLruListTests

- (void)setUp {
    [super setUp];
    
    _mockSpiller = mockProtocol(@protocol(SKLruListSpiller));
    
    _mockObject1 = mock([NSObject class]);
    _mockObject2 = mock([NSObject class]);
    _mockObject3 = mock([NSObject class]);
    _mockObject4 = mock([NSObject class]);
    
    _list = [[SKLruList alloc] initWithCapacity:2 andSpiller:_mockSpiller];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldSpillLru_whenOverflow {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject3];
    
    [verify(_mockSpiller) onSpilled:_mockObject1];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject3];
}

- (void)test_shouldUpdateLru_whenObjectReTouched {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject3];
    
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject1];
    [verify(_mockSpiller) onSpilled:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject3];
}

- (void)test_shouldNotSpill_whenObjectTouchedAfterRemove {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list removeObject:_mockObject1];
    [_list touchObject:_mockObject3];
    [_list touchObject:_mockObject4];
    
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject1];
    [verify(_mockSpiller) onSpilled:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject3];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject4];
}

- (void)test_shouldNotSpill_whenObjectTouchedAfterClear {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list removeAllObjects];
    [_list touchObject:_mockObject3];
    [_list touchObject:_mockObject4];
    
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject1];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject3];
    [verifyCount(_mockSpiller, never()) onSpilled:_mockObject4];
}

@end
