//
//  Sample BLModel implementation
//

#import "Contact.h"

@implementation Contact

#pragma mark - NSObject

- (instancetype)initWithContactID:(NSInteger)contactID name:(NSString *)name company:(NSString *)company
{
    self = [super init];
    if (self)
    {
        _contactID = contactID;
        _name = [name copy];
        _company = [company copy];
    }

    return self;
}

#pragma mark - BLModel

- (instancetype)initWithDictionary: (NSDictionary *)jsonDict
{
    if (![Contact validateDictionary:jsonDict])
        return nil;
    
    NSInteger contactID = [[jsonDict nullStrippedObjectForKey:kContactAPIKeyContactID] intValue];
    NSString* name = [jsonDict nullStrippedObjectForKey:kContactAPIKeyName];
    NSString* company = [jsonDict nullStrippedObjectForKey:kContactAPIKeyCompany];
    
    return [self initWithContactID:contactID name:name company:company];
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
    
    if (! validateClass([NSNumber class], kContactAPIKeyContactID, dictionary, NO))
        retVal = NO;

    if (! validateClass([NSString class], kContactAPIKeyName, dictionary, YES))
        retVal = NO;

    if (! validateClass([NSString class], kContactAPIKeyCompany, dictionary, YES))
        retVal = NO;
    
    return retVal;
}

@end
