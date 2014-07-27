//
//  BLModel.h
//  Capsule
//
//  Created by Burton Lee on 4/10/13.
//  Copyright (c) 2014 Buffalo Ladybug LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+StripNullObjects.h"
@import CoreData;

static NSString* const kBLModelAPITimeFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

@protocol BLModel <NSObject>

+ (BOOL)validateDictionary: (NSDictionary *)dictionary;

@optional
// Models are NSObjects
- (instancetype)initWithDictionary: (NSDictionary *)dictionary;

// Models are NSManagedObjects (CoreData); Implement main runloop entity-based creation under this method.
- (instancetype)initWithDictionary: (NSDictionary *)dictionary intoManagedObjectContext:(NSManagedObjectContext *)moc;

@end

#pragma mark - Function Declarations

static BOOL validateClass(Class _class, NSString* _key, NSDictionary* _dict, BOOL _canBeNil);
static BOOL validateEnum(int _enumMax, NSString* _key, NSDictionary* _dict);
static BOOL validateBool(NSString* _key, NSDictionary* _dict, BOOL _canBeNSStringOrNSNumber, BOOL _canBeNil);

static int const kBLModelIdentifierNone = 0;
static NSString* const kBLModelUpdatedAtKey = @"updated_at";
static NSString* const kBLModelCreatedAtKey = @"created_at";
static NSString* const kBLModelIdentifierKey = @"id";


// Shared functions
NSDate* dateWithAPITimeString(NSString *dString);
NSString* APITimeStringWithDate(NSDate *date);
id nilProtectedZeroValueNumber(NSNumber *number);
NSString* cosmeticTimeSinceDate(NSDate *date);

@class BLModel;
@protocol BLTestableModel <BLModel>

+ (NSArray *)apiKeys;
- (NSDictionary *)jsonDictionary;
- (NSDictionary *)postDictionary;

+ (NSArray *)arrayOfDataWithJSONArray: (NSArray *)jsonArray;

- (BOOL)isUpdatedRelativeToModel:(BLModel *)model;
- (BOOL)arrayOfModels:(NSArray *)array isUpdatedRelativeToArray:(NSArray *)otherArray;

@end

@interface BLModel : NSObject <BLTestableModel>

@property (nonatomic, assign) BOOL isTemporary;
@property (nonatomic, assign) NSUInteger identifier; // id
@property (nonatomic, strong) NSDate* updatedAt;
@property (nonatomic, strong) NSDate* createdAt;

@end



