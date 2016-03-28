//
//  SKOrderedDictionaryTest.m
//  SKTaskUtils
//
//  Created by Shin-Kai Chen on 2016/3/28.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SKOrderedDictionary.h"

@import OCHamcrest;
@import OCMockito;

static NSString *const kKeyObject1 = @"key1";
static NSString *const kKeyObject2 = @"key2";

@interface SKOrderedDictionaryTest : XCTestCase

@property(nonatomic, strong) SKOrderedDictionary *orderedDictionary;

@property(nonatomic, strong) NSObject *dummyObject1;
@property(nonatomic, strong) NSObject *dummyObject2;

@end

@implementation SKOrderedDictionaryTest

- (void)setUp {
    [super setUp];
    _orderedDictionary = [[SKOrderedDictionary alloc] init];
    _dummyObject1 = mock([NSObject class]);
    _dummyObject2 = mock([NSObject class]);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_countShouldBeOne_whenSetObjectForEmptyDictionary {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    assertThatUnsignedInteger(_orderedDictionary.count, is(equalToUnsignedInteger(1)));
}

- (void)test_countShouldBeTwo_whenSetObjectForDictionaryWithOneObject {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    [_orderedDictionary addObject:_dummyObject2 forKey:kKeyObject2];
    
    assertThatUnsignedInteger(_orderedDictionary.count, is(equalToUnsignedInteger(2)));
}

- (void)test_countShouldBeZero_whenRemoveAllObjects {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    [_orderedDictionary removeAllObjects];
    
    assertThatUnsignedInteger(_orderedDictionary.count, is(equalToUnsignedInteger(0)));
}

- (void)test_objectShouldMatch_whenRetriveObjectWithSpecificKey {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    id object = [_orderedDictionary objectForKey:kKeyObject1];
    
    assertThat(object, is(notNilValue()));
    assertThat(object, is(equalTo(_dummyObject1)));
}

- (void)test_objectShouldBeRemoved_whenRemoveObjectForSpecificKey {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    [_orderedDictionary removeObjectForKey:kKeyObject1];
    
    id object = [_orderedDictionary objectForKey:kKeyObject1];
    assertThat(object, is(nilValue()));
}

- (void)test_objectShouldMatch_whenRetriveObjectWithSpecificIndex {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    id object = [_orderedDictionary objectAtIndex:0];
    
    assertThat(object, is(notNilValue()));
    assertThat(object, is(equalTo(_dummyObject1)));
}

- (void)test_objectShouldMatch_whenInsertObjectWithSpecificIndex {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    [_orderedDictionary insertObject:_dummyObject2 atIndex:0 forKey:kKeyObject2];
    
    id object = [_orderedDictionary objectAtIndex:0];
    
    assertThat(object, is(notNilValue()));
    assertThat(object, is(equalTo(_dummyObject2)));
}

- (void)test_objectShouldBeRemoved_whenRemoveObjectForSpecificIndex {
    [_orderedDictionary addObject:_dummyObject1 forKey:kKeyObject1];
    
    [_orderedDictionary removeObjectAtIndex:0];
    
    id object = [_orderedDictionary objectForKey:kKeyObject1];
    assertThat(object, is(nilValue()));
}

@end
