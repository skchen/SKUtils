//
//  SKLruDictionaryTest.m
//  SKUtils
//
//  Created by Shin-Kai Chen on 2016/3/29.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKLruCache.h"

@import OCHamcrest;
@import OCMockito;

@interface SKLruCacheTest : XCTestCase

@property(nonatomic, strong) SKLruCache *lruDictionary;

@property(nonatomic, strong) id<SKLruCacheSpiller> mockSpillers;

@property(nonatomic, strong) id<NSCopying> key1;
@property(nonatomic, strong) id<NSCopying> key2;
@property(nonatomic, strong) id<NSCopying> key3;

@property(nonatomic, strong) id mockObject1;
@property(nonatomic, strong) id mockObject1r;
@property(nonatomic, strong) id mockObject2;
@property(nonatomic, strong) id mockObject3;

@end

@implementation SKLruCacheTest

- (void)setUp {
    [super setUp];
    
    _mockSpillers = mockProtocol(@protocol(SKLruCacheSpiller));
    
    _lruDictionary = [[SKLruCache alloc] initWithCapacity:2 andSpiller:_mockSpillers];
    
    _key1 = @"Key 1";
    _key2 = @"Key 2";
    _key3 = @"Key 3";
    
    _mockObject1 = mock([NSObject class]);
    _mockObject1r = mock([NSObject class]);
    _mockObject2 = mock([NSObject class]);
    _mockObject3 = mock([NSObject class]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_countShouldBeOne_whenSetObjectForEmptyDictionary {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    
    assertThatUnsignedInteger(_lruDictionary.count, is(equalToUnsignedInteger(1)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
}

- (void)test_countShouldBeTwo_whenSetObjectForDictionaryWithOneObject {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    
    assertThatUnsignedInteger(_lruDictionary.count, is(equalToUnsignedInteger(2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

- (void)test_countShouldBeZero_whenRemoveAllObjects {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    
    [_lruDictionary removeAllObjects];
    
    assertThatUnsignedInteger(_lruDictionary.count, is(equalToUnsignedInteger(0)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
}

- (void)test_objectShouldMatch_whenRetriveObjectWithSpecificKey {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    
    id object1 = [_lruDictionary objectForKey:_key1];
    id object2 = [_lruDictionary objectForKey:_key2];
    
    assertThat(object1, is(notNilValue()));
    assertThat(object1, is(equalTo(_mockObject1)));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

- (void)test_objectShouldBeRemoved_whenRemoveObjectForSpecificKey {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    
    [_lruDictionary removeObjectForKey:_key1];
    
    id object1 = [_lruDictionary objectForKey:_key1];
    id object2 = [_lruDictionary objectForKey:_key2];
    
    assertThat(object1, is(nilValue()));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

- (void)test_shouldDropLru_whenSetOverflow {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    [_lruDictionary setObject:_mockObject3 forKey:_key3];
    
    id object1 = [_lruDictionary objectForKey:_key1];
    id object2 = [_lruDictionary objectForKey:_key2];
    id object3 = [_lruDictionary objectForKey:_key3];
    
    assertThat(object1, is(nilValue()));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    assertThat(object3, is(notNilValue()));
    assertThat(object3, is(equalTo(_mockObject3)));
    [verify(_mockSpillers) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject3 forKey:_key3];
}

- (void)test_shouldUpdateLru_whenGetObject {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    [_lruDictionary objectForKey:_key1];
    [_lruDictionary setObject:_mockObject3 forKey:_key3];
    
    id object1 = [_lruDictionary objectForKey:_key1];
    id object2 = [_lruDictionary objectForKey:_key2];
    id object3 = [_lruDictionary objectForKey:_key3];
    
    assertThat(object1, is(notNilValue()));
    assertThat(object1, is(equalTo(_mockObject1)));
    assertThat(object2, is(nilValue()));
    assertThat(object3, is(notNilValue()));
    assertThat(object3, is(equalTo(_mockObject3)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verify(_mockSpillers) onSpilled:_mockObject2 forKey:_key2];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject3 forKey:_key3];
}

- (void)test_shouldUpdateLru_whenSetObject {
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    [_lruDictionary setObject:_mockObject1r forKey:_key1];
    [_lruDictionary setObject:_mockObject3 forKey:_key3];
    
    id object1 = [_lruDictionary objectForKey:_key1];
    id object2 = [_lruDictionary objectForKey:_key2];
    id object3 = [_lruDictionary objectForKey:_key3];
    
    assertThat(object1, is(notNilValue()));
    assertThat(object1, is(equalTo(_mockObject1r)));
    assertThat(object2, is(nilValue()));
    assertThat(object3, is(notNilValue()));
    assertThat(object3, is(equalTo(_mockObject3)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1r forKey:_key1];
    [verify(_mockSpillers) onSpilled:_mockObject2 forKey:_key2];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject3 forKey:_key3];
}

- (void)test_shouldKeepObjects_whenNotOverflow {
    [_lruDictionary setObject:_mockObject2 forKey:_key2];
    [_lruDictionary setObject:_mockObject1 forKey:_key1];
    [_lruDictionary setObject:_mockObject1r forKey:_key1];
    
    id object1 = [_lruDictionary objectForKey:_key1];
    id object2 = [_lruDictionary objectForKey:_key2];
    
    assertThat(object1, is(notNilValue()));
    assertThat(object1, is(equalTo(_mockObject1r)));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1r forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

@end
