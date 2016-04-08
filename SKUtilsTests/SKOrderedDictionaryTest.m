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

@interface SKOrderedDictionaryTest : XCTestCase

@end

@implementation SKOrderedDictionaryTest {
    SKOrderedDictionary *orderedDictionary;
    
    NSMutableDictionary *mockMutableDictionary;
    NSMutableArray *mockMutableArray;
    
    id<NSCopying> mockKey1;
    id mockObject1;
}

- (void)setUp {
    [super setUp];
    orderedDictionary = [[SKOrderedDictionary alloc] init];
    
    mockMutableDictionary = mock([NSMutableDictionary class]);
    mockMutableArray = mock([NSMutableArray class]);
    [orderedDictionary setValue:mockMutableDictionary forKey:@"dictionary"];
    [orderedDictionary setValue:mockMutableArray forKey:@"array"];
    
    mockKey1 = mockProtocol(@protocol(NSCopying));
    [given([mockKey1 copyWithZone:nil]) willReturn:mockKey1];
    mockObject1 = mock([NSObject class]);
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_shouldGetObjectForKey_whenObjectExist {
    [given([mockMutableDictionary objectForKey:mockKey1]) willReturn:mockObject1];
    
    id object = [orderedDictionary objectForKey:mockKey1];
    
    assertThat(object, is(equalTo(mockObject1)));
}

- (void)test_shouldGetNilAsObjectForKey_whenObjectNotExist {
    [given([mockMutableDictionary objectForKey:mockKey1]) willReturn:nil];
    
    id object = [orderedDictionary objectForKey:mockKey1];
    
    assertThat(object, is(nilValue()));
}

- (void)test_shouldGetObjectAtIndex_whenObjectExist {
    [given([mockMutableArray count]) willReturnUnsignedInteger:5];
    [given([mockMutableArray objectAtIndex:3]) willReturn:mockKey1];
    [given([mockMutableDictionary objectForKey:mockKey1]) willReturn:mockObject1];
    
    id object = [orderedDictionary objectForKey:mockKey1];
    
    assertThat(object, is(equalTo(mockObject1)));
}

- (void)test_shouldGetNilAsObjectAtIndex_whenObjectNotExist {
    [given([mockMutableArray count]) willReturnUnsignedInteger:5];
    [given([mockMutableArray objectAtIndex:3]) willReturn:mockKey1];
    [given([mockMutableDictionary objectForKey:mockKey1]) willReturn:nil];
    
    id object = [orderedDictionary objectAtIndex:3];
    
    assertThat(object, is(nilValue()));
}

- (void)test_shouldGetLastObject_whenNotEmpty {
    [given([mockMutableArray lastObject]) willReturn:mockKey1];
    [given([mockMutableDictionary objectForKey:mockKey1]) willReturn:mockObject1];
    
    id object = [orderedDictionary lastObject];
    
    assertThat(object, is(equalTo(mockObject1)));
}

- (void)test_shouldGetNilAsLastObject_whenEmpty {
    [given([mockMutableArray lastObject]) willReturn:nil];
    
    id object = [orderedDictionary lastObject];
    
    assertThat(object, is(nilValue()));
}

- (void)test_shouldInsertObjectAtIndexForKey {
    [orderedDictionary insertObject:mockObject1 atIndex:3 forKey:mockKey1];
    
    [verify(mockMutableDictionary) setObject:mockObject1 forKey:mockKey1];
    [verify(mockMutableArray) insertObject:mockKey1 atIndex:3];
}

- (void)test_shouldAddObject {
    [orderedDictionary addObject:mockObject1 forKey:mockKey1];
    
    [verify(mockMutableDictionary) setObject:mockObject1 forKey:mockKey1];
    [verify(mockMutableArray) addObject:mockKey1];
}

- (void)test_shouldRemoveObjectForKey {
    [orderedDictionary removeObjectForKey:mockKey1];
    
    [verify(mockMutableDictionary) removeObjectForKey:mockKey1];
    [verify(mockMutableArray) removeObject:mockKey1];
}

- (void)test_shouldRemoveObjectAtIndex {
    [given([mockMutableArray objectAtIndex:3]) willReturn:mockKey1];
    
    [orderedDictionary removeObjectAtIndex:3];
    
    [verify(mockMutableDictionary) removeObjectForKey:mockKey1];
    [verify(mockMutableArray) removeObject:mockKey1];
}

- (void)test_shouldRemoveLastObject_whenNotEmpty {
    [given([mockMutableArray lastObject]) willReturn:mockKey1];
    
    [orderedDictionary removeLastObject];
    
    [verify(mockMutableDictionary) removeObjectForKey:mockKey1];
    [verify(mockMutableArray) removeObject:mockKey1];
}

- (void)test_shouldNotRemoveAnythingAsLastObject_whenNotEmpty {
    [given([mockMutableArray lastObject]) willReturn:nil];
    
    [orderedDictionary removeLastObject];
    
    [verifyCount(mockMutableDictionary, never()) removeObjectForKey:(id)anything()];
    [verifyCount(mockMutableArray, never()) removeObject:(id)anything()];
}

- (void)test_shouldRemoveAllObjects {
    [orderedDictionary removeAllObjects];
    
    [verify(mockMutableDictionary) removeAllObjects];
    [verify(mockMutableArray) removeAllObjects];
}

@end
