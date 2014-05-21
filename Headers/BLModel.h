//
//  BLModel.h
//  Buffalo Ladybug, LLC
//
//  Created by Burton Lee on 4/9/13.
//  Any use permitted.  Use as you will.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+StripNullObjects.h"
@import CoreData;

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

#pragma mark - Function Implementation

// It's not a law that says you have to validate everything; suppressing unused warning on these functions.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused"

static BOOL validateClass(Class _class, NSString* _key, NSDictionary* _dict, BOOL _canBeNil)
{
    BOOL retVal = YES;
    
    id obj = _dict[_key];
    if ((! obj || [obj isKindOfClass:[NSNull class]]) && !_canBeNil)
       retVal = NO;
    
    else if (obj && ! [obj isKindOfClass: _class] && ! [obj isKindOfClass:[NSNull class]])
        retVal = NO;
    
    return retVal;
} 

static BOOL validateEnum(int _enumMax, NSString* _key, NSDictionary* _dict)
{
    BOOL retVal = YES;

    id obj = _dict[_key];
    int value = -99; // error state

    if (! [obj isKindOfClass:[NSNumber class]])
        retVal = NO;
    else
        value = [obj intValue];
    
    if (retVal && value >= _enumMax)
        retVal = NO;
    
    else if (retVal && value < 0)
        retVal = NO;
    
    return retVal;
}

static BOOL validateBool(NSString* _key, NSDictionary* _dict, BOOL _canBeNSStringOrNSNumber, BOOL _canBeNil)
{
    BOOL retVal = NO;
    
    id obj = _dict[_key];
    
    if (_canBeNil && !obj)
        retVal = YES;
    
    if ([obj isKindOfClass:[NSNumber class]] && ([obj intValue] == 0 || [obj intValue] == 1))
        retVal = YES;
    
    else if (_canBeNSStringOrNSNumber && [obj isKindOfClass:[NSString class]] && ([obj isEqualToString:@"true"] || [obj isEqualToString:@"false"]))
        retVal = YES;
    
    return retVal;
}

#pragma clang diagnostic pop


