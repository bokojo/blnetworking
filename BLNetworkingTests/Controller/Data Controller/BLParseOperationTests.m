//
//  BLParseOperationTests.m
//  BLNetworking
//
//  Created by Burton Lee on 10/16/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLParseOperation.h"
#import "BLMockModel.h"

@interface BLParseOperationTests : XCTestCase

@end

@implementation BLParseOperationTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitWithResponseObjectEtc
{
    XCTAssert([[BLParseOperation alloc] initWithResponseObject:nil path:nil modelClass:nil managedObjectContext:nil successNote:nil successBlock:nil lock:nil], @"InitWithResponse failed on all nil values.");
}

- (void)testMainLocking
{
    BOOL lock = YES;
    BLParseOperation* parseOp = [[BLParseOperation alloc] initWithResponseObject:nil
                                                                            path:nil
                                                                      modelClass:nil
                                                            managedObjectContext:nil
                                                                     successNote:nil
                                                                    successBlock:nil                                                                                                   lock:&lock];
    
   [parseOp main];
     XCTAssertFalse(lock, @"lock is true");
    
}

- (void)testMainPathToResponseObject
{
    void (^success3)(NSArray *) = ^(NSArray *array) {
        XCTAssertEqual(3, (int)[array count], @"Wrong object count in array: %@", array);
    };
    
    void (^success1)(NSArray *) = ^(NSArray *array) {
        XCTAssertEqual(1, (int)[array count], @"Wrong object count in array: %@", array);
    };
    
    void (^success0)(NSArray *) = ^(NSArray *array) {
        XCTAssertEqual(0, (int)[array count], @"Wrong object count in array: %@", array);
    };
    
    NSDictionary* responseObject = @{
                                     @"foo" : @{
                                             @"bar" : @{
                                                     @"bat" : @[ @{ @"name" : @"value" },
                                                                 @{ @"name" : @"value" },
                                                                 @{ @"name" : @"value" }],
                                                     @"bad" : @[ @{ @"bad": @"bad object"} ]
                                                     },
                                             
                                             @"bad" : @[ @{ @"bad": @"bad object"} ]
                                             },
                                     @"bad" : @{ @"bad": @"bad object"}
                                     };
    
    // 3 objects
    BLParseOperation* parseOp = [[BLParseOperation alloc] initWithResponseObject:responseObject
                                                                            path:@"foo.bar.bat"
                                                                      modelClass:[BLMockModel class]
                                                            managedObjectContext:nil
                                                                     successNote:nil
                                                                    successBlock:success3
                                                                            lock:nil];
    [parseOp main];
    
    // 1 object, alternate path
    parseOp = [[BLParseOperation alloc] initWithResponseObject:responseObject
                                                          path:@"foo.bad"
                                                    modelClass:[BLMockModel class]
                                          managedObjectContext:nil
                                                   successNote:nil
                                                  successBlock:success1
                                                          lock:nil];
    
    [parseOp main];
    
    // 1 object, dictionary not array
    parseOp = [[BLParseOperation alloc] initWithResponseObject:responseObject
                                                          path:@"bad"
                                                    modelClass:[BLMockModel class]
                                          managedObjectContext:nil
                                                   successNote:nil
                                                  successBlock:success1
                                                          lock:nil];
    
    [parseOp main];
    
    // 1 object, already an array
    parseOp = [[BLParseOperation alloc] initWithResponseObject:@[ @{ @"key" : @"value" } ]
                                                          path:nil
                                                    modelClass:[BLMockModel class]
                                          managedObjectContext:nil
                                                   successNote:nil
                                                  successBlock:success1
                                                          lock:nil];
    
    [parseOp main];
    
    // Bad response from a non failing code
    parseOp = [[BLParseOperation alloc] initWithResponseObject:@"404 ERROR PAGE NOT FOUND"
                                                          path:nil
                                                    modelClass:[BLMockModel class]
                                          managedObjectContext:nil
                                                   successNote:nil
                                                  successBlock:success0
                                                          lock:nil];
    
    [parseOp main];

}

- (void)testMainInitializing
{
    void (^success)(NSArray*) = ^(NSArray *array) {
        
        XCTAssertEqual(1, (int)[array count], @"Too many objects in array: %@", array);
        
        XCTAssert([[array firstObject] class] == [BLMockModel class], @"Wrong object type: %@", [array firstObject]);
        
        XCTAssertTrue([(BLMockModel *)[array firstObject] calledInitWithDictionary], @"Initializer initWithDictionary reports no call. %@", [array firstObject]);
        
        XCTAssertFalse([(BLMockModel *)[array firstObject] calledInitWithDictionaryIntoManagedObjectContext], @"Initializer initWithDictionaryIntoManagedObjectContext reports call. %@", [array firstObject]);
        
    };
    
    BLParseOperation* parseOp = [[BLParseOperation alloc] initWithResponseObject:@[ @{ @"object" : @"test" } ]
                                                                            path:nil
                                                                      modelClass:[BLMockModel class]
                                                            managedObjectContext:nil
                                                                     successNote:nil
                                                                    successBlock:success
                                                                            lock:nil];
    [parseOp main];
    
}

@end
