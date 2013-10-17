//
//  BLModelTests.m
//  BLNetworking
//
//  Created by Burton Lee on 10/17/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLModel.h"

@interface BLModelTests : XCTestCase

@end

@implementation BLModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testValidateClass
{
    NSDictionary* dictionary = @{ @"string" : @"mystring",
                                  @"number" : @123,
                                  @"operation" : [[NSOperation alloc] init],
                                  @"null" : [NSNull null]};
    
    // Correct requests to validate class
    XCTAssertTrue(validateClass([NSString class], @"string", dictionary, YES), @"Failed to validate NSString object type in dictionary: %@", dictionary);
    XCTAssertTrue(validateClass([NSNumber class], @"number", dictionary, YES), @"Failed to validate NSNumber object type in dictionary: %@", dictionary);
    XCTAssertTrue(validateClass([NSOperation class], @"operation", dictionary, YES), @"Failed to validate NSOperation object type in dictionary: %@", dictionary);
    
    // Bad requests to validate class; should be false
    XCTAssertFalse(validateClass([NSNumber class], @"string", dictionary, YES), @"Improperly validated string as NSNumber in dictionary: %@", dictionary);
    XCTAssertFalse(validateClass([NSString class], @"number", dictionary, YES), @"Improperly validated NSNumber as NSString in dictionary: %@", dictionary);
    XCTAssertFalse(validateClass([NSNumber class], @"operation", dictionary, YES), @"Improperly validated NSOperation as NSNumber in dictionary: %@", dictionary);
    
    // Requesting non-existant key, allowing nil
    XCTAssertTrue(validateClass([NSString class], @"missingkey", dictionary, YES), @"Improperly rejected nil value after YES passed to canBeNil option.");

    // Requesting non-existant key, disallowing nil
    XCTAssertFalse(validateClass([NSString class], @"missingkey", dictionary, NO), @"Improperly rejected nil value after YES passed to canBeNil option.");
    
    // Requesting NSNull, allowing nil
    XCTAssertTrue(validateClass([NSString class], @"null", dictionary, YES), @"Improperly rejected nil value after YES passed to canBeNil option.");
    
    // Requesting NSNull, disallowing nil
    XCTAssertFalse(validateClass([NSString class], @"null", dictionary, NO), @"Improperly rejected nil value after YES passed to canBeNil option.");

}

- (void)testValidateEnum
{
    NSDictionary* dictionary = @{ @"one" : @1,
                                  @"ninethousand" : @9000,
                                  @"string" : @"string",
                                  @"null" : [NSNull null] };
    
    XCTAssertTrue(validateEnum(3, @"one", dictionary), @"Failed to validate enum value 1, max 3 in dictionary: %@", dictionary);
    
    XCTAssertFalse(validateEnum(3, @"ninethousand", dictionary), @"Failed to reject enum value 9000, max 3 in dictionary: %@", dictionary);
    
    XCTAssertFalse(validateEnum(3, @"string", dictionary), @"Failed to reject string in place of number in dictionary: %@", dictionary);
    
    XCTAssertFalse(validateEnum(3, @"nonexistantkey", dictionary), @"Failed to reject nil value in dictionary: %@", dictionary);
    
    XCTAssertFalse(validateEnum(3, @"null", dictionary), @"Failed to reject Null value in dictionary: %@", dictionary);

}

- (void)testValidateBool
{
    BOOL testBool = YES;
    NSDictionary* dictionary = @{ @"bool" : @(testBool),
                                  @"number" : @1,
                                  @"word" : @"true",
                                  @"string" : @"1",
                                };
    
    XCTAssert(validateBool(@"bool", dictionary, YES, YES), @"Failed to identify boxed BOOL object in dictionary: %@", dictionary);
    
    XCTAssert(validateBool(@"number", dictionary, YES, YES), @"Failed to identify numeric BOOL in dictionary: %@", dictionary);
    
    XCTAssert(validateBool(@"word", dictionary, YES, YES), @"Failed to identify string BOOL in dictionary: %@", dictionary);
    XCTAssertFalse(validateBool(@"word", dictionary, NO, YES), @"Failed to reject string BOOL when disallowed in dictionary: %@", dictionary);
    
    XCTAssert(validateBool(@"nonexistant", dictionary, YES, YES), @"Failed to identify nil as allowed value in dictionary: %@", dictionary);
    XCTAssertFalse(validateBool(@"nonexistant", dictionary, YES, NO), @"Failed to reject nil as disallowed in dictionary: %@", dictionary);
}

@end
