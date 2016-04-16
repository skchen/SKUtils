//
//  SKLruDictionaryTest.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruDictionary.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruDictionaryTests : XCTestCase

@end

@implementation SKLruDictionaryTests {
    SKLruDictionary *lruTable;
    
    NSMutableDictionary *mockStorage;
    SKLruArray *mockLruList;
    id<SKLruCoster> mockCoster;
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
    
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockSpiller = mockProtocol(@protocol(SKLruTableSpiller));
    mockLruList = mock([SKLruArray class]);
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    mockKey2 = mockProtocol(@protocol(NSCopying));
    
    mockObject1 = mock([NSObject class]);
    mockObject1r = mock([NSObject class]);
    mockObject2 = mock([NSObject class]);
    
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    
    lruTable = [[SKLruDictionary alloc] initWithConstraint:1];
    [lruTable setCoster:mockCoster];
    [lruTable setSpiller:mockSpiller];
    [lruTable setValue:mockStorage forKey:@"storage"];
    [lruTable setValue:mockLruList forKey:@"keyLruList"];
    [mockLruList setValue:lruTable forKey:@"coster"];
    [mockLruList setValue:lruTable forKey:@"spiller"];
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

- (void)test_shouldListAllValues {
    [lruTable allValues];
    
    [verify(mockStorage) allValues];
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

@end
