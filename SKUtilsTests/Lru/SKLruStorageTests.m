//
//  SKLruStorageTests.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/4/1.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruStorage.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruStorageTests : XCTestCase

@end

@implementation SKLruStorageTests {
    SKLruStorage *lruStorage;
    
    NSFileManager *mockFileManager;
    SKLruTable *mockTable;
    id<SKLruCoster> mockCoster;
    id<SKLruTableSpiller> mockSpiller;
    
    id<NSCopying> mockKey1;
    NSString *mockPath1;
    
    id<NSCopying> mockKey2;
    NSString *mockPath2;
}

- (void)setUp {
    [super setUp];
    
    mockFileManager = mock([NSFileManager class]);
    mockTable = mock([SKLruTable class]);
    mockCoster = mockProtocol(@protocol(SKLruCoster));
    mockSpiller = mockProtocol(@protocol(SKLruTableSpiller));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    mockPath1 = mock([NSString class]);
    
    mockKey2 = mockProtocol(@protocol(NSCopying));
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    mockPath2 = mock([NSString class]);
    
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    
    lruStorage = [[SKLruStorage alloc] initWithConstraint:1];
    lruStorage.coster = mockCoster;
    lruStorage.spiller = mockSpiller;
    lruStorage.fileManager = mockFileManager;
    [lruStorage setValue:mockTable forKey:@"urlLruTable"];
    
    [given([mockTable coster]) willReturn:(id<SKLruCoster>)lruStorage];
    [given([mockTable spiller]) willReturn:(id<SKLruTableSpiller>)lruStorage];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldGetNil_whenObjectIsNotInCache {
    [given([mockTable objectForKey:mockKey1]) willReturn:nil];
    
    id object1 = [lruStorage objectForKey:mockKey1];
    
    assertThat(object1, is(nilValue()));
}

- (void)test_shouldGetPath_whenObjectIsInCacheAndStorage {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockPath1];
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:YES];
    
    id object1 = [lruStorage objectForKey:mockKey1];
    
    assertThat(object1, is(mockPath1));
}

- (void)test_shouldGetNilAndRemoveCache_whenObjectIsInCacheButNotInStorage {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockPath1];
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:NO];
    
    id object1 = [lruStorage objectForKey:mockKey1];
    
    [verify(mockTable) removeObjectForKey:mockKey1];
    assertThat(object1, is(nilValue()));
}

- (void)test_shouldSetPath_whenFileIsInStorage {
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:YES];
    
    [lruStorage setObject:mockPath1 forKey:mockKey1];
    
    [verify(mockTable) setObject:mockPath1 forKey:mockKey1];
}

- (void)test_shouldNotSetPath_whenFileIsNotInStorage {
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:NO];
    
    [lruStorage setObject:mockPath1 forKey:mockKey1];
    
    [verifyCount(mockTable, never()) setObject:mockPath1 forKey:mockKey1];
}

- (void)test_shouldRemoveCacheAndFile_whenFileIsCached {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockPath1];
    
    [lruStorage removeObjectForKey:mockKey1];
    
    [verify(mockTable) removeObjectForKey:mockKey1];
    [verify(mockFileManager) removeItemAtPath:mockPath1 error:nil];
}

- (void)test_shouldRemoveCacheOnly_whenFileIsNotCached {
    [given([mockTable objectForKey:mockKey1]) willReturn:nil];
    
    [lruStorage removeObjectForKey:mockKey1];
    
    [verify(mockTable) removeObjectForKey:mockKey1];
    //[verifyCount(mockFileManager, never()) removeItemAtURL:nil error:nil];
}

- (void)test_shouldRemoveAllObjects {
    [given([mockTable allValues]) willReturn:@[mockPath1, mockPath2]];
    [given([mockTable objectForKey:mockKey1]) willReturn:mockPath1];
    [given([mockTable objectForKey:mockKey2]) willReturn:mockPath2];
    
    [lruStorage removeAllObjects];
    
    [verify(mockFileManager) removeItemAtPath:mockPath1 error:nil];
    [verify(mockFileManager) removeItemAtPath:mockPath2 error:nil];
    [verify(mockTable) removeAllObjects];
}

@end
