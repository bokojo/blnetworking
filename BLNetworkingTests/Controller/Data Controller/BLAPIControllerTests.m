//
//  BLAPIControllerTests.m
//  BLNetworking
//
//  Created by Burton Lee on 10/16/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLAPIController.h"

@interface BLAPIControllerTests : XCTestCase
{
    BLAPIController* _apiController;
}
@end

@implementation BLAPIControllerTests

- (void)setUp
{
    [super setUp];
    _apiController = [[BLAPIController alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.google.com"] sessionConfiguration:nil];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCompletionBlockWithEtc
{
    NSDictionary* results = [_apiController completionBlocksWithSuccess:nil failure:nil modelClass:nil managedObjectContext:nil successNotificationName:nil failureNotificationName:nil atomicLock:nil responsePath:nil queue:nil];
    
    XCTAssert(results[kBLAPIControllerSuccessBlockKey], @"results: %@", results);
    XCTAssert(results[kBLAPIControllerFailureBlockKey], @"results: %@", results);
}

- (void)testInitWithBaseURLEtc
{
    XCTAssert([[BLAPIController alloc] initWithBaseURL:nil sessionConfiguration:nil], @"initWithBaseURL:sessionConfiguration: failed with nil values");
}

@end
