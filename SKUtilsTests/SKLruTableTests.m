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

@property(nonatomic, strong) SKLruTable *lruTable;

@property(nonatomic, strong) id<SKLruTableSpiller> mockSpillers;

@property(nonatomic, strong) id<NSCopying> key1;
@property(nonatomic, strong) id<NSCopying> key2;
@property(nonatomic, strong) id<NSCopying> key3;

@property(nonatomic, strong) id mockObject1;
@property(nonatomic, strong) id mockObject1r;
@property(nonatomic, strong) id mockObject2;
@property(nonatomic, strong) id mockObject3;

@end

@implementation SKLruTableTests

- (void)setUp {
    [super setUp];
    
    _mockSpillers = mockProtocol(@protocol(SKLruTableSpiller));
    
    _lruTable = [[SKLruTable alloc] initWithCapacity:2 andSpiller:_mockSpillers];
    
    _key1 = mockProtocol(@protocol(NSCopying));
    _key2 = mockProtocol(@protocol(NSCopying));
    _key3 = mockProtocol(@protocol(NSCopying));
    
    _mockObject1 = mock([NSObject class]);
    _mockObject1r = mock([NSObject class]);
    _mockObject2 = mock([NSObject class]);
    _mockObject3 = mock([NSObject class]);
    
    [given([_key1 copyWithZone:nil]) willReturn:_key1];
    [given([_key2 copyWithZone:nil]) willReturn:_key2];
    [given([_key3 copyWithZone:nil]) willReturn:_key3];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_countShouldBeOne_whenSetObjectForEmptyDictionary {
    [_lruTable setObject:_mockObject1 forKey:_key1];
    
    assertThatUnsignedInteger(_lruTable.count, is(equalToUnsignedInteger(1)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
}

- (void)test_countShouldBeTwo_whenSetObjectForDictionaryWithOneObject {
    [_lruTable setObject:_mockObject1 forKey:_key1];
    
    [_lruTable setObject:_mockObject2 forKey:_key2];
    
    assertThatUnsignedInteger(_lruTable.count, is(equalToUnsignedInteger(2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

- (void)test_countShouldBeZero_whenRemoveAllObjects {
    [_lruTable setObject:_mockObject1 forKey:_key1];
    
    [_lruTable removeAllObjects];
    
    assertThatUnsignedInteger(_lruTable.count, is(equalToUnsignedInteger(0)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
}

- (void)test_objectShouldMatch_whenRetriveObjectWithSpecificKey {
    [_lruTable setObject:_mockObject1 forKey:_key1];
    [_lruTable setObject:_mockObject2 forKey:_key2];
    
    id object1 = [_lruTable objectForKey:_key1];
    id object2 = [_lruTable objectForKey:_key2];
    
    assertThat(object1, is(notNilValue()));
    assertThat(object1, is(equalTo(_mockObject1)));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

- (void)test_objectShouldBeRemoved_whenRemoveObjectForSpecificKey {
    [_lruTable setObject:_mockObject1 forKey:_key1];
    [_lruTable setObject:_mockObject2 forKey:_key2];
    
    [_lruTable removeObjectForKey:_key1];
    
    id object1 = [_lruTable objectForKey:_key1];
    id object2 = [_lruTable objectForKey:_key2];
    
    assertThat(object1, is(nilValue()));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

- (void)test_shouldDropLru_whenSetOverflow {
    [_lruTable setObject:_mockObject1 forKey:_key1];
    [_lruTable setObject:_mockObject2 forKey:_key2];
    [_lruTable setObject:_mockObject3 forKey:_key3];
    
    id object1 = [_lruTable objectForKey:_key1];
    id object2 = [_lruTable objectForKey:_key2];
    id object3 = [_lruTable objectForKey:_key3];
    
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
    [_lruTable setObject:_mockObject1 forKey:_key1];
    [_lruTable setObject:_mockObject2 forKey:_key2];
    [_lruTable objectForKey:_key1];
    [_lruTable setObject:_mockObject3 forKey:_key3];
    
    id object1 = [_lruTable objectForKey:_key1];
    id object2 = [_lruTable objectForKey:_key2];
    id object3 = [_lruTable objectForKey:_key3];
    
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
    [_lruTable setObject:_mockObject1 forKey:_key1];
    [_lruTable setObject:_mockObject2 forKey:_key2];
    [_lruTable setObject:_mockObject1r forKey:_key1];
    [_lruTable setObject:_mockObject3 forKey:_key3];
    
    id object1 = [_lruTable objectForKey:_key1];
    id object2 = [_lruTable objectForKey:_key2];
    id object3 = [_lruTable objectForKey:_key3];
    
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
    [_lruTable setObject:_mockObject2 forKey:_key2];
    [_lruTable setObject:_mockObject1 forKey:_key1];
    [_lruTable setObject:_mockObject1r forKey:_key1];
    
    id object1 = [_lruTable objectForKey:_key1];
    id object2 = [_lruTable objectForKey:_key2];
    
    assertThat(object1, is(notNilValue()));
    assertThat(object1, is(equalTo(_mockObject1r)));
    assertThat(object2, is(notNilValue()));
    assertThat(object2, is(equalTo(_mockObject2)));
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1 forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject1r forKey:_key1];
    [verifyCount(_mockSpillers, never()) onSpilled:_mockObject2 forKey:_key2];
}

@end
