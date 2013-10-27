//
//  Thing.h
//  Sample BLModel
//

#import <Foundation/Foundation.h>
#import "BLModel.h"

///// API Keys
static NSString* const kThingAPIKeyThingID      =   @"id";
static NSString* const kThingAPIKeyName         =   @"name";
static NSString* const kThingAPIKeyCompany      =   @"company";

@interface Thing : NSObject <BLModel>

@property (nonatomic, assign) NSInteger thingID;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* company;

- (instancetype)initWithThingID: (NSInteger)thingID name: (NSString *)name company: (NSString *)company;

@end
