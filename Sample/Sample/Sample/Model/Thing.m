//
//  Sample BLModel implementation
//

#import "Thing.h"

@implementation Thing

#pragma mark - NSObject

- (instancetype)initWithThingID:(NSInteger)thingID name:(NSString *)name company:(NSString *)company
{
    self = [super init];
    if (self)
    {
        _thingID = thingID;
        _name = [name copy];
        _company = [company copy];
    }

    return self;
}

#pragma mark - BLModel

- (instancetype)initWithDictionary: (NSDictionary *)jsonDict
{
    if (![Thing validateDictionary:jsonDict])
        return nil;
    
    NSInteger thingID = [[jsonDict nullStrippedObjectForKey:kThingAPIKeyThingID] intValue];
    NSString* name = [jsonDict nullStrippedObjectForKey:kThingAPIKeyName];
    NSString* company = [jsonDict nullStrippedObjectForKey:kThingAPIKeyCompany];
    
    return [self initWithThingID:ThingID name:name company:company];
}

- (instancetype)initWithDictionary: (NSDictionary *)dictionary intoManagedObjectContext:(NSManagedObjectContext *)moc
{
    if (!moc)
        return [self initWithDictionary:dictionary];
    
    // TODO: core data setup
    return nil;
}

+ (BOOL)validateDictionary:(NSDictionary *)dictionary
{
    BOOL retVal = YES;
    
    if (! validateClass([NSNumber class], kThingAPIKeyThingID, dictionary, NO))
        retVal = NO;

    if (! validateClass([NSString class], kThingAPIKeyName, dictionary, YES))
        retVal = NO;

    if (! validateClass([NSString class], kThingAPIKeyCompany, dictionary, YES))
        retVal = NO;
    
    return retVal;
}

@end
