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
    id<SKLruStorageCoster> mockCoster;
    id<SKLruStorageSpiller> mockSpiller;
    
    id<NSCopying> mockKey1;
    NSURL *mockUrl1;
    NSString *mockPath1;
    
    id<NSCopying> mockKey2;
    NSURL *mockUrl2;
    NSString *mockPath2;
}

- (void)setUp {
    [super setUp];
    
    mockFileManager = mock([NSFileManager class]);
    mockTable = mock([SKLruTable class]);
    mockCoster = mockProtocol(@protocol(SKLruStorageCoster));
    mockSpiller = mockProtocol(@protocol(SKLruStorageSpiller));
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    mockUrl1 = mock([NSURL class]);
    mockPath1 = mock([NSString class]);
    [given([mockUrl1 absoluteString]) willReturn:mockPath1];
    
    mockKey2 = mockProtocol(@protocol(NSCopying));
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    mockUrl2 = mock([NSURL class]);
    mockPath2 = mock([NSString class]);
    [given([mockUrl2 absoluteString]) willReturn:mockPath2];
    
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    [given([mockKey2 copyWithZone:nil]) willReturn:mockKey2];
    
    lruStorage = [[SKLruStorage alloc] initWithFileManager:mockFileManager andLruTable:mockTable andCoster:mockCoster andSpiller:mockSpiller];
    
    [given([mockTable coster]) willReturn:(id<SKLruTableCoster>)lruStorage];
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

- (void)test_shouldGetUrl_whenObjectIsInCacheAndStorage {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockUrl1];
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:YES];
    
    id object1 = [lruStorage objectForKey:mockKey1];
    
    assertThat(object1, is(mockUrl1));
}

- (void)test_shouldGetNilAndRemoveCache_whenObjectIsInCacheButNotInStorage {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockUrl1];
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:NO];
    
    id object1 = [lruStorage objectForKey:mockKey1];
    
    [verify(mockTable) removeObjectForKey:mockKey1];
    assertThat(object1, is(nilValue()));
}

- (void)test_shouldSetUrl_whenFileIsInStorage {
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:YES];
    
    [lruStorage setObject:mockUrl1 forKey:mockKey1];
    
    [verify(mockTable) setObject:mockUrl1 forKey:mockKey1];
}

- (void)test_shouldNotSetUrl_whenFileIsNotInStorage {
    [given([mockFileManager fileExistsAtPath:mockPath1]) willReturnBool:NO];
    
    [lruStorage setObject:mockUrl1 forKey:mockKey1];
    
    [verifyCount(mockTable, never()) setObject:mockUrl1 forKey:mockKey1];
}

- (void)test_shouldRemoveCacheAndFile_whenFileIsCached {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockUrl1];
    
    [lruStorage removeObjectForKey:mockKey1];
    
    [verify(mockTable) removeObjectForKey:mockKey1];
    [verify(mockFileManager) removeItemAtURL:mockUrl1 error:nil];
}

- (void)test_shouldRemoveCacheOnly_whenFileIsNotCached {
    [given([mockTable objectForKey:mockKey1]) willReturn:nil];
    
    [lruStorage removeObjectForKey:mockKey1];
    
    [verify(mockTable) removeObjectForKey:mockKey1];
    //[verifyCount(mockFileManager, never()) removeItemAtURL:nil error:nil];
}

- (void)test_shouldRemoveAllObjects {
    [given([mockTable allValues]) willReturn:@[mockUrl1, mockUrl2]];
    [given([mockTable objectForKey:mockKey1]) willReturn:mockUrl1];
    [given([mockTable objectForKey:mockKey2]) willReturn:mockUrl2];
    
    [lruStorage removeAllObjects];
    
    [verify(mockFileManager) removeItemAtURL:mockUrl1 error:nil];
    [verify(mockFileManager) removeItemAtURL:mockUrl2 error:nil];
    [verify(mockTable) removeAllObjects];
}

- (void)test_shouldGetCost {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockUrl1];
    [given([mockCoster costForObject:mockUrl1]) willReturnUnsignedInteger:3];
    
    NSUInteger costForObject1 = [mockTable.coster costForObject:mockUrl1];
    
    assertThatUnsignedInteger(costForObject1, is(equalToUnsignedInteger(3)));
}

- (void)test_shouldInvokeSpill {
    [given([mockTable objectForKey:mockKey1]) willReturn:mockUrl1];
    
    [mockTable.spiller onSpilled:mockUrl1 forKey:mockKey1];
    
    [verify(mockFileManager) removeItemAtURL:mockUrl1 error:nil];
    [verify(mockSpiller) onSpilled:mockUrl1 forKey:mockKey1];
}

@end
