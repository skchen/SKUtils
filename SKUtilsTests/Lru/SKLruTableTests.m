//
//  SKLruDictionaryTest.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruTable.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruTableTests : XCTestCase

@end

@implementation SKLruTableTests {
    SKLruTable *lruTable;
    
    NSMutableDictionary *mockStorage;
    SKLruList *mockLruList;
    id<SKLruTableCoster> mockCoster;
    id<SKLruTableSpiller> mockSpiller;
    
    id<NSCopying> mockKey1;
    id<NSCopying> mockKey2;
    
    id mockObject1;
    id mockObject1r;
    id mockObject2;
}

- (void)setUp {
    [super setUp];
    
    mockStorage = mock([NSMutableDictionary class]);
    mockLruList = mock([SKLruList class]);
    
    mockCoster = mockProtocol(@protocol(SKLruTableCoster));
    mockSpiller = mockProtocol(@protocol(SKLruTableSpiller));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    mockKey2 = mockProtocol(@protocol(NSCopying));
    
    mockObject1 = mock([NSObject class]);
    mockObject1r = mock([NSObject class]);
    mockObject2 = mock([NSObject class]);
    
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    
    lruTable = [[SKLruTable alloc] initWithStorage:mockStorage andLruList:mockLruList andCoster:mockCoster andSpiller:mockSpiller];
    
    [given([mockLruList coster]) willReturn:(id<SKLruListCoster>)lruTable];
    [given([mockLruList spiller]) willReturn:(id<SKLruListSpiller>)lruTable];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldGetNilAndNotUpdateLru_whenObjectIsNotInStorage {
    [given([mockStorage objectForKey:mockKey1]) willReturn:nil];
    
    id object1 = [lruTable objectForKey:mockKey1];
    
    [verify(mockStorage) objectForKey:mockKey1];
    [verifyCount(mockLruList, never()) touchObject:mockKey1];
    assertThat(object1, is(nilValue()));
}

- (void)test_shouldGetObjectAndUpdateLru_whenObjectIsInStorage {
    [given([mockStorage objectForKey:mockKey1]) willReturn:mockObject1];
    
    id object1 = [lruTable objectForKey:mockKey1];
    
    [verify(mockStorage) objectForKey:mockKey1];
    [verify(mockLruList) touchObject:mockKey1];
    assertThat(object1, is(mockObject1));
}

- (void)test_shouldSetObject {
    [lruTable setObject:mockObject1r forKey:mockKey1];
    
    [verify(mockStorage) setObject:mockObject1r forKey:mockKey1];
    [verify(mockLruList) touchObject:mockKey1];
}

- (void)test_shouldRemoveObject {
    [lruTable removeObjectForKey:mockKey1];
    
    [verify(mockStorage) removeObjectForKey:mockKey1];
    [verify(mockLruList) removeObject:mockKey1];
}

- (void)test_shouldRemoveAllObjects {
    [lruTable removeAllObjects];
    
    [verify(mockStorage) removeAllObjects];
    [verify(mockLruList) removeAllObjects];
}

- (void)test_shouldGetCost {
    [given([mockStorage objectForKey:mockKey1]) willReturn:mockObject1];
    [given([mockCoster costForObject:mockObject1]) willReturnUnsignedInteger:3];
    
    NSUInteger costForObject1 = [mockLruList.coster costForObject:mockKey1];
    
    assertThatUnsignedInteger(costForObject1, is(equalToUnsignedInteger(3)));
}

- (void)test_shouldInvokeSpill {
    [given([mockStorage objectForKey:mockKey1]) willReturn:mockObject1];
    
    [mockLruList.spiller onSpilled:mockKey1];
    
    [verify(mockSpiller) onSpilled:mockObject1 forKey:mockKey1];
}

- (void)test_shouldRemoveObject_whenSpilled {
    [given([mockStorage objectForKey:mockKey2]) willReturn:mockObject2];
    [givenVoid([mockLruList touchObject:mockKey1]) willDo:^id(NSInvocation *invocation) {
        [mockLruList.spiller onSpilled:mockKey2];
        return nil;
    }];
    
    [lruTable setObject:mockObject1 forKey:mockKey1];
    
    [verify(mockStorage) removeObjectForKey:mockKey2];
    [verify(mockSpiller) onSpilled:mockObject2 forKey:mockKey2];
}

@end
