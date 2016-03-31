//
//  SKLruCacheTests.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/30.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruCache.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruCacheTests : XCTestCase

@end

@implementation SKLruCacheTests {
    SKLruCache *lruCache;
    
    id<SKLruCacheLoader> mockLruCacheLoader;
    SKLruTable *mockLruTable;
    
    id<NSCopying> mockKey1;
    id mockObject1;
    
    id<NSCopying> mockKey2;
    id mockObject2;
}

- (void)setUp {
    [super setUp];
    
    mockLruTable = mock([SKLruTable class]);
    mockLruCacheLoader = mockProtocol(@protocol(SKLruCacheLoader));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    mockKey2 = mockProtocol(@protocol(NSCopying));
    
    mockObject1 = mock([NSObject class]);
    mockObject2 = mock([NSObject class]);
    
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    
    [given([mockLruCacheLoader loadObjectForKey:mockKey1]) willReturn:mockObject1];
    [given([mockLruCacheLoader loadObjectForKey:mockKey2]) willReturn:mockObject2];
    
    lruCache = [[SKLruCache alloc] initWithLruTable:mockLruTable andLoader:mockLruCacheLoader];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldLoadObject_whenObjectIsNotYetLoaded {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:nil];
    
    id object = [lruCache objectForKey:mockKey1];
    
    [verify(mockLruCacheLoader) loadObjectForKey:mockKey1];
    assertThat(object, is(mockObject1));
}

- (void)test_shouldNotLoadObject_whenObjectIsAlreadyLoaded {
    [given([mockLruTable objectForKey:mockKey1]) willReturn:mockObject1];
    
    id object1 = [lruCache objectForKey:mockKey1];
    
    [verifyCount(mockLruCacheLoader, never()) loadObjectForKey:mockKey1];
    assertThat(object1, is(mockObject1));
}

- (void)test_shouldRemoveObject {
    [lruCache removeObjectForKey:mockKey1];
    
    [verify(mockLruTable) removeObjectForKey:mockKey1];
}

- (void)test_shouldRemoveAllObjects {
    [lruCache removeAllObjects];
    
    [verify(mockLruTable) removeAllObjects];
}



@end
