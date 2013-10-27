//
//  NSDictionary+StripNullObjectsTests.m
//  BLNetworking
//
//  Created by Burton Lee on 10/16/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+StripNullObjects.h"

@interface NSDictionary_StripNullObjectsTests : XCTestCase
{
    NSDictionary* _dict;
}
@end

@implementation NSDictionary_StripNullObjectsTests

- (void)setUp
{
    [super setUp];
    
    _dict = @{ @"one" : @1,
               @"two" : @"too",
               @"null" : [NSNull null] };
}

- (void)tearDown
{
    _dict = nil;
    [super tearDown];
}

- (void)testNullStrippedObjectForKey
{
    id obj = nil;
    obj = [_dict nullStrippedObjectForKey:@"null"];
    
    XCTAssertNil(obj, @"obj: %@", obj);
}

- (void)testNilProtectedValueForKey
{
    id nothing = nil;
    id obj = nilProtectedValueFromObject(nothing);
    
    XCTAssert(obj == [NSNull null], @"obj: %@", obj);
}

@end
