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

@property(nonatomic, strong) SKLruList *list;

@property(nonatomic, strong) id mockObject1;
@property(nonatomic, strong) id mockObject2;

@end

@implementation SKLruListTests {
    NSMutableArray *mockStorage;
    id<SKLruCoster> mockCoster;
    id<SKLruListSpiller> mockSpiller;
}

- (void)setUp {
    [super setUp];
    
    mockStorage = mock([NSMutableArray class]);
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockSpiller = mockProtocol(@protocol(SKLruListSpiller));
    
    _mockObject1 = mock([NSObject class]);
    _mockObject2 = mock([NSObject class]);
    
    _list = [[SKLruList alloc] initWithConstraint:1 andCoster:mockCoster andSpiller:mockSpiller];
    [_list setValue:mockStorage forKey:@"storage"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldKeepObjectAndIncreaseCost_whenObjectIsNotInStorageAndTouched {
    [given([mockStorage containsObject:_mockObject1]) willReturnBool:NO];
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list touchObject:_mockObject1];
    
    NSUInteger currentCost = _list.cost;
    [verifyCount(mockStorage, never()) removeObject:_mockObject1];
    [verify(mockStorage) insertObject:_mockObject1 atIndex:0];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost+1)));
}

- (void)test_shouldUpdateObject_whenObjectIsInStorageAndTouched {
    [given([mockStorage containsObject:_mockObject1]) willReturnBool:YES];
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list touchObject:_mockObject1];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeObject:_mockObject1];
    [verify(mockStorage) insertObject:_mockObject1 atIndex:0];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost)));
}

- (void)test_shouldSpillObject_whenCostOverflow {
    [given([mockStorage containsObject:_mockObject1]) willReturnBool:NO];
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:2];
    [given([mockStorage lastObject]) willReturn:_mockObject2];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list touchObject:_mockObject1];
    
    NSUInteger currentCost = _list.cost;
    [verifyCount(mockStorage, never()) removeObject:_mockObject1];
    [verify(mockStorage) insertObject:_mockObject1 atIndex:0];
    [verify(mockStorage) removeObject:_mockObject2];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject1];
    [verify(mockSpiller) onSpilled:_mockObject2];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost+1)));
}

- (void)test_shouldDoNothing_whenObjectIsNotInStorageAndRemoved {
    [given([mockStorage containsObject:_mockObject1]) willReturnBool:NO];
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list removeObject:_mockObject1];
    
    NSUInteger currentCost = _list.cost;
    [verifyCount(mockStorage, never()) removeObject:_mockObject1];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost)));
}

- (void)test_shouldRemoveObject_whenObjectIsInStorageAndRemoved {
    [given([mockStorage containsObject:_mockObject1]) willReturnBool:YES];
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list removeObject:_mockObject1];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeObject:_mockObject1];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost-1)));
}

- (void)test_shouldRemoveAllObjects_whenRemoveAllObjectCalled {
    [_list removeAllObjects];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeAllObjects];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(0)));
}

@end
