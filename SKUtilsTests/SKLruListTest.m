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

@interface SKMockSpiller : NSObject

- (void)onSpill:(id)object;

@end

@implementation SKMockSpiller

- (void)onSpill:(id)object {}

@end

@interface SKLruListTest : XCTestCase

@property(nonatomic, strong) SKMockSpiller *mockSpiller;
@property(nonatomic, strong) SKLruList *list;

@property(nonatomic, strong) id mockObject1;
@property(nonatomic, strong) id mockObject2;
@property(nonatomic, strong) id mockObject3;
@property(nonatomic, strong) id mockObject4;

@end

@implementation SKLruListTest

- (void)setUp {
    [super setUp];
    
    _mockSpiller = mock([SKMockSpiller class]);
    
    _mockObject1 = mock([NSObject class]);
    _mockObject2 = mock([NSObject class]);
    _mockObject3 = mock([NSObject class]);
    _mockObject4 = mock([NSObject class]);
    
    _list = [[SKLruList alloc] initWithCapacity:2 andSpiller:^(id  _Nonnull object) {
        [_mockSpiller onSpill:object];
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_shouldSpillLru_whenOverflow {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject3];
    
    [verify(_mockSpiller) onSpill:_mockObject1];
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject3];
}

- (void)test_shouldUpdateLru_whenObjectReTouched {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject3];
    
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject1];
    [verify(_mockSpiller) onSpill:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject3];
}

- (void)test_shouldNotSpill_whenObjectTouchedAfterClear {
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list removeAllObjects];
    [_list touchObject:_mockObject3];
    [_list touchObject:_mockObject4];
    
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject1];
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject2];
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject3];
    [verifyCount(_mockSpiller, never()) onSpill:_mockObject4];
}

@end
