//
//  Contact.h
//  Sample BLModel
//

#import <Foundation/Foundation.h>
#import "BLModel.h"

///// API Keys
static NSString* const kContactAPIKeyContactID    =   @"id";
static NSString* const kContactAPIKeyName         =   @"name";
static NSString* const kContactAPIKeyCompany      =   @"company";

@interface Contact : NSObject <BLModel>

@property (nonatomic, assign) NSInteger contactID;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* company;

- (instancetype)initWithContactID: (NSInteger)contactID name: (NSString *)name company: (NSString *)company;

@end
