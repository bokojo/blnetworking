//
// Sample BLModel Test
//

#import <XCTest/XCTest.h>
#import "Thing.h"

@interface RTContactTests : XCTestCase
{
    NSDictionary* _jsonExample;
}
@end

@implementation RTContactTests

- (void)setUp
{
    [super setUp];
    
    _jsonExample =
    
    // API Documentation provided sample
    @{
      @"id": @2,
      @"name": @"John Doe",
      @"company": @"COMPANY",
    };
    
}

- (void)tearDown
{
    [super tearDown];
    _jsonExample = nil;
}

- (void)testSampleData
{
    XCTAssert(_jsonExample, @"json: %@", _jsonExample);
}

- (void)testValidateDictionary
{
    XCTAssert([Contact validateDictionary:_jsonExample]);
    
    NSMutableDictionary* badDictionary = nil;
    
    badDictionary = [_jsonExample mutableCopy];
    XCTAssert([Contact validateDictionary:badDictionary]);
    
    badDictionary[kContactAPIKeyContactID] = @"32";
    XCTAssertFalse([Contact validateDictionary:badDictionary]);
    
    badDictionary = [_jsonExample mutableCopy];
    badDictionary[kContactAPIKeyName] = @12;
    XCTAssertFalse([Contact validateDictionary:badDictionary]);

    badDictionary = [_jsonExample mutableCopy];
    badDictionary[kContactAPIKeyCompany] = @12;
    XCTAssertFalse([Contact validateDictionary:badDictionary]);
}

- (void)testRTContactInitWithDictionary
{
    id obj = [[Thing alloc] initWithDictionary:_jsonExample];
    XCTAssert([obj isKindOfClass:[Contact class]], @"obj: %@", obj);
}

- (void)testRTContactInitWithDictionaryIntoManagedObjectContext
{
    id obj = [[Thing alloc] initWithDictionary:_jsonExample intoManagedObjectContext:nil];
    XCTAssert([obj isKindOfClass:[Contact class]], @"obj: %@", obj);
    
    // TODO: test for core data setup
}

- (void)testRTContactInitWithParameters
{
    NSInteger contactID = [[_jsonExample nullStrippedObjectForKey:kContactAPIKeyContactID] intValue];
    NSString* name = [_jsonExample nullStrippedObjectForKey:kContactAPIKeyName];
    NSString* company = [_jsonExample nullStrippedObjectForKey:kContactAPIKeyCompany];
   
    Thing* obj = [[Thing alloc] initWithContactID:contactID name:name company:company];
    
    XCTAssert(obj.contactID == contactID, @"expect: %d received: %d", (int)contactID, (int)obj.contactID);
    XCTAssert([obj.name isEqualToString:name], @"name: %@", obj.name);
    XCTAssert([obj.company isEqualToString:company], @"company: %@", obj.company);
}

@end
