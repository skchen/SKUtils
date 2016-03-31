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
@property(nonatomic, strong) id mockObject3;
@property(nonatomic, strong) id mockObject4;

@end

@implementation SKLruListTests {
    id<SKLruListCoster> mockCoster;
    id<SKLruListSpiller> mockSpiller;
}

- (void)setUp {
    [super setUp];
    
    mockCoster = mockProtocol(@protocol(SKLruListCoster));
    mockSpiller = mockProtocol(@protocol(SKLruListSpiller));
    
    _mockObject1 = mock([NSObject class]);
    _mockObject2 = mock([NSObject class]);
    _mockObject3 = mock([NSObject class]);
    _mockObject4 = mock([NSObject class]);
    
    _list = [[SKLruList alloc] initWithConstraint:2 andCoster:mockCoster andSpiller:mockSpiller];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldSpillLru_whenOverflow {
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject3]) willReturnUnsignedInteger:1];
    
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject3];
    
    [verify(mockSpiller) onSpilled:_mockObject1];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject2];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject3];
}

- (void)test_shouldUpdateLru_whenObjectReTouched {
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject3]) willReturnUnsignedInteger:1];
    
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject3];
    
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject1];
    [verify(mockSpiller) onSpilled:_mockObject2];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject3];
}

- (void)test_shouldNotSpill_whenObjectTouchedAfterRemove {
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject3]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject4]) willReturnUnsignedInteger:1];
    
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list removeObject:_mockObject1];
    [_list touchObject:_mockObject3];
    [_list touchObject:_mockObject4];
    
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject1];
    [verify(mockSpiller) onSpilled:_mockObject2];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject3];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject4];
}

- (void)test_shouldNotSpill_whenObjectTouchedAfterClear {
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject3]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject4]) willReturnUnsignedInteger:1];
    
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list removeAllObjects];
    [_list touchObject:_mockObject3];
    [_list touchObject:_mockObject4];
    
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject1];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject2];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject3];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject4];
}

- (void)test_shouldSpill_whenTotalObjectCostIsMoreThanConstraint {
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:2];
    
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    
    [verify(mockSpiller) onSpilled:_mockObject1];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject2];
}

- (void)test_shouldSpillBoth_whenTotalObjectCostIsMoreThanConstraint {
    [given([mockCoster costForObject:_mockObject1]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject2]) willReturnUnsignedInteger:1];
    [given([mockCoster costForObject:_mockObject3]) willReturnUnsignedInteger:2];
    
    [_list touchObject:_mockObject1];
    [_list touchObject:_mockObject2];
    [_list touchObject:_mockObject3];
    
    [verify(mockSpiller) onSpilled:_mockObject1];
    [verify(mockSpiller) onSpilled:_mockObject2];
    [verifyCount(mockSpiller, never()) onSpilled:_mockObject3];
}

@end
