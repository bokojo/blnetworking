//
//  BLJSONResponseSerializerTests.m
//  BLNetworking
//
//  Created by Burton Lee on 10/16/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLJSONResponseSerializer.h"

@interface BLJSONResponseSerializerTests : XCTestCase
{
    BLJSONResponseSerializer* _serializer;
}
@end

@implementation BLJSONResponseSerializerTests

- (void)setUp
{
    [super setUp];
    XCTAssert(_serializer = [BLJSONResponseSerializer serializer], @"Serializer failed factory method");
}

- (void)tearDown
{
    _serializer = nil;
    [super tearDown];
}

- (void)testResponseObjectForResponseEtc
{
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"www.google.com"]
                                                              statusCode:401
                                                             HTTPVersion:@"5.0"
                                                            headerFields:@{ @"Content-Type" : @"application/json" }];

    NSData* badData = [@"IOsjdojasoidjaisjdoiajsd" dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    
    [_serializer responseObjectForResponse:response data:badData error:&error];
    
    XCTAssert(error, @"Failed; no error returned");
    XCTAssert(error.userInfo[kBLJSONResponseSerializerKeyRawData], @"Raw Data Dictionary Not Found. %@", error.userInfo);
    XCTAssertNil(error.userInfo[kBLJSONResponseSerializerKeyJSONData], @"JSON Found in bad data.  Unexpected.");
    
    error = nil;
    NSData* goodData = [@"{ \"json\" : true }" dataUsingEncoding:NSUTF8StringEncoding];
    
    [_serializer responseObjectForResponse:response data:goodData error:&error];
    
    XCTAssert(error, @"Failed; no error returned");
    XCTAssert(error.userInfo[kBLJSONResponseSerializerKeyRawData], @"Raw Data Dictionary Not Found");
    XCTAssert(error.userInfo[kBLJSONResponseSerializerKeyJSONData], @"JSON Dictionary Not Found");
}

@end
