//
//  SKLruArrayTests.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruArray.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruArrayTests : XCTestCase

@property(nonatomic, strong) SKLruArray *list;

@end

@implementation SKLruArrayTests {
    NSMutableArray *mockStorage;
    id<SKLruCoster> mockCoster;
    id<SKLruArraySpiller> mockSpiller;
    
    NSString *object1;
    NSString *object2;
}

- (void)setUp {
    [super setUp];
    
    mockStorage = mock([NSMutableArray class]);
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockSpiller = mockProtocol(@protocol(SKLruArraySpiller));
    
    object1 = @"object1";
    object2 = @"object2";
    
    _list = [[SKLruArray alloc] initWithConstraint:1];
    _list.coster = mockCoster;
    _list.spiller = mockSpiller;
    [_list setValue:mockStorage forKey:@"storage"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldKeepObjectAndIncreaseCost_whenObjectIsNotInStorageAndTouched {
    [given([mockStorage containsObject:object1]) willReturnBool:NO];
    [given([mockCoster costForObject:object1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list touchObject:object1];
    
    NSUInteger currentCost = _list.cost;
    [verifyCount(mockStorage, never()) removeObject:object1];
    [verify(mockStorage) insertObject:object1 atIndex:0];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost+1)));
}

- (void)test_shouldUpdateObject_whenObjectIsInStorageAndTouched {
    [given([mockStorage containsObject:object1]) willReturnBool:YES];
    [given([mockCoster costForObject:object1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list touchObject:object1];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeObject:object1];
    [verify(mockStorage) insertObject:object1 atIndex:0];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost)));
}

- (void)test_shouldSpillObject_whenCostOverflow {
    [given([mockStorage containsObject:object1]) willReturnBool:NO];
    [given([mockCoster costForObject:object1]) willReturnUnsignedInteger:2];
    [given([mockStorage lastObject]) willReturn:object2];
    [given([mockCoster costForObject:object2]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list touchObject:object1];
    
    NSUInteger currentCost = _list.cost;
    [verifyCount(mockStorage, never()) removeObject:object1];
    [verify(mockStorage) insertObject:object1 atIndex:0];
    [verify(mockStorage) removeObject:object2];
    [verifyCount(mockSpiller, never()) onSpilled:object1];
    [verify(mockSpiller) onSpilled:object2];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost+1)));
}

- (void)test_shouldReturnLastObject_whenStorageNotEmpty {
    [given([mockStorage lastObject]) willReturn:object1];
    
    id object = [_list lastObject];
    
    assertThat(object, is(equalTo(object1)));
}

- (void)test_shouldReturnNilAsLastObject_whenStorageEmpty {
    [given([mockStorage lastObject]) willReturn:nil];
    
    id object = [_list lastObject];
    
    assertThat(object, is(nilValue()));
}

- (void)test_shouldDoNothing_whenObjectIsNotInStorageAndRemoved {
    [given([mockStorage containsObject:object1]) willReturnBool:NO];
    [given([mockCoster costForObject:object1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list removeObject:object1];
    
    NSUInteger currentCost = _list.cost;
    [verifyCount(mockStorage, never()) removeObject:object1];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost)));
}

- (void)test_shouldRemoveObject_whenObjectIsInStorageAndRemoved {
    [given([mockStorage containsObject:object1]) willReturnBool:YES];
    [given([mockCoster costForObject:object1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list removeObject:object1];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeObject:object1];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost-1)));
}

- (void)test_shouldRemoveLastObject_whenStorageIsNotEmpty {
    [given([mockStorage lastObject]) willReturn:object1];
    [given([mockCoster costForObject:object1]) willReturnUnsignedInteger:1];
    NSUInteger previousCost = _list.cost;
    
    [_list removeLastObject];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeLastObject];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(previousCost-1)));
}

- (void)test_shouldRemoveAllObjects_whenRemoveAllObjectCalled {
    [_list removeAllObjects];
    
    NSUInteger currentCost = _list.cost;
    [verify(mockStorage) removeAllObjects];
    assertThatUnsignedInteger(currentCost, is(equalToUnsignedInteger(0)));
}

@end
