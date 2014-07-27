//
//  BLModel.m
//
//  Created by Burton Lee on 4/10/14.
//  Copyright (c) 2014 Buffalo Ladybug, LLC. All rights reserved.
//

#import "BLModel.h"


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


NSDate* dateWithAPITimeString(NSString *dString)
{
    if (!dString)
        return nil;

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kBLModelAPITimeFormat;
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

    NSDate* date = [dateFormatter dateFromString:dString];
    
    return date;
}

NSString* APITimeStringWithDate(NSDate *date)
{
    if (!date)
        return nil;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kBLModelAPITimeFormat;
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

    return [dateFormatter stringFromDate:date];
}

NSString* cosmeticTimeSinceDate(NSDate *date)
{
    if (!date)
        return nil;

    NSTimeInterval seconds = [date timeIntervalSinceNow];
    NSString* retString = nil;
    
    if (seconds > 0)
        retString = @"In the future!";
    else if (seconds > -60)
        retString = @"Just now";
    else if (seconds > -60)
        retString = @"A minute ago";
    else if (seconds > -300)
        retString = @"A few minutes ago";
    else if (seconds > -3600)
        retString = [NSString stringWithFormat:@"About %d minutes ago", (int)(seconds/-60)];
    else if (seconds > -7200)
        retString = @"About an hour ago";
    else if (seconds > -86400)
        retString = [NSString stringWithFormat:@"About %d hours ago", (int)(seconds/-3600)];
    else if (seconds > -172800)
        retString = @"About a day ago";
    else
        retString = [NSString stringWithFormat:@"About %d days ago", (int)(seconds/-86400)];
    
    return retString;
}

id nilProtectedZeroValueNumber(NSNumber *number)
{
    id outObj = [NSNull null];
    
    if (![number isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        outObj = number;
    }
    
    return outObj;
}

@implementation BLModel
@dynamic identifier;

#pragma mark - Full Methods; no need to override

+ (NSArray *)arrayOfDataWithJSONArray:(NSArray *)jsonArray
{
    Class class = [self class];
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for (id obj in jsonArray)
    {
        NSDictionary* dict = obj;
        id data = [[class alloc]
                   initWithDictionary:dict];
        
        if (data)
            [tempArray addObject:data];
        
    }
    
    return tempArray;
}

+ (NSArray *)arrayOfJSONWithRTModelArray:(NSArray *)modelsArray isPostData:(BOOL)isPost 
{
    NSMutableArray* outArray = [NSMutableArray array];
    
    for (BLModel* obj in modelsArray)
    {
        id new;
        if (isPost)
            new = [obj postDictionary];
        else
            new = [obj jsonDictionary];
        
        if (new)
            [outArray addObject:new];
    }
    
    return outArray;
}

#pragma mark - Stub Methods; Override in subclasses

+ (NSArray *)apiKeys
{
    return [[[self alloc] jsonDictionary] allKeys];
}

- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary* outDict = [[self postDictionary] mutableCopy];
    
    [outDict addEntriesFromDictionary: @{
                                         kBLModelUpdatedAtKey   : nilProtectedValueFromObject(APITimeStringWithDate(self.updatedAt)),
                                         kBLModelCreatedAtKey   : nilProtectedValueFromObject(APITimeStringWithDate(self.createdAt))
                                         }];
    
    return [outDict copy];
}

- (NSDictionary *)postDictionary
{
    NSMutableDictionary* outDict = [NSMutableDictionary dictionary];
    
    if (!self.isTemporaryID && self.identifier)
        [outDict addEntriesFromDictionary:@{ kBLModelIdentifierKey : nilProtectedValueFromObject(@(self.identifier)) }];
    
    return [outDict copy];
}

- (NSArray *)differenceArrayAgainstModel: (BLModel *)model
{
    NSAssert([model isKindOfClass:[self class]], @"Model mistmatch! %@ %@", [self class], [model class]);
    
    NSDictionary* myPostDict = [self postDictionary];
    NSDictionary* modelPostDict = [model postDictionary];
    
    NSMutableArray* diff = [NSMutableArray array];
    
    for (NSString* key in myPostDict)
    {
        if (![[modelPostDict valueForKey:key] isEqual:[myPostDict valueForKey:key]])
            [diff addObject: @{ kBLModelDifferenceKeyKey : key,
                                kBLModelDifferenceKeyModelValue : nilProtectedValueFromObject([modelPostDict valueForKey:key]),
                                kBLModelDifferenceKeySelfValue :  nilProtectedValueFromObject([myPostDict valueForKey:key]) }];
    }
    
    if (![diff count])
        diff = nil;
    
    return [diff copy];
}

- (NSDictionary *)differenceDictionaryAgainstModel: (BLModel *)model
{
    NSAssert([model isKindOfClass:[self class]], @"Model mistmatch! %@ %@", [self class], [model class]);
    
    NSDictionary* myPostDict = [self postDictionary];
    NSDictionary* modelPostDict = [model postDictionary];
    
    NSMutableDictionary* diff = [NSMutableDictionary dictionary];
    
    [diff addEntriesFromDictionary: @{ kBLModelIdentifierKey : nilProtectedValueFromObject(@(self.identifier)) }];
    for (NSString* key in myPostDict)
    {
        if (![[modelPostDict valueForKey:key] isEqual:[myPostDict valueForKey:key]])
            [diff addEntriesFromDictionary:@{ key : nilProtectedValueFromObject([myPostDict valueForKey:key]) }];
    }
    
    return [diff copy];
}

+ (BOOL)validateDictionary:(NSDictionary *)dictionary
{
    return NO;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary intoManagedObjectContext:(NSManagedObjectContext *)moc
{
    return nil;
}

- (BOOL)isUpdatedRelativeToModel:(BLModel *)model
{
    BOOL retVal = NO;
    
    if (![self.updatedAt isEqualToDate:model.updatedAt])
        retVal = YES;
    
    return retVal;
}

- (BOOL)arrayOfModels:(NSArray *)array isUpdatedRelativeToArray:(NSArray *)otherArray
{
    BOOL retVal = NO;
    
    for (BLModel* m in array)
    {
        BLModel* comparison = [self objectMatchingIdentifier:m.identifier inArray:otherArray];
        
        if (comparison)
        {
            if (![comparison.updatedAt isEqualToDate:m.updatedAt])
                retVal = YES;
        }
        else
            retVal = YES;
    }
    
    return retVal;
}

- (BLModel *)objectMatchingIdentifier: (NSUInteger)ident inArray:(NSArray *)array
{
    BLModel* retObj = nil;
    
    for (BLModel* obj in array)
    {
        if ([obj respondsToSelector:@selector(identifier)])
        {
            if (obj.identifier == ident)
            {
                retObj = obj;
                break;
            }
        }
    }
    
    return retObj;
}


- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[BLModel class]] && [self respondsToSelector:@selector(identifier)] && [object respondsToSelector:@selector(identifier)])
        return (self.identifier == ((BLModel *)object).identifier);
    
    return [super isEqual:object];
}
@end

