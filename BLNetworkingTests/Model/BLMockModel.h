//
//  BLTestModel.h
//  BLNetworking
//
//  Created by Burton Lee on 10/17/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLModel.h"
@import CoreData;

@interface BLMockModel : NSObject <BLModel>

@property (nonatomic, assign) BOOL calledInitWithDictionary;
@property (nonatomic, assign) BOOL calledInitWithDictionaryIntoManagedObjectContext;

@end

@implementation BLMockModel

- (id)initWithDictionary:(__unused NSDictionary *)dictionary
{
    self = [super init];
    self.calledInitWithDictionary = YES;
    return self;
}

- (id)initWithDictionary:(__unused NSDictionary *)dictionary intoManagedObjectContext:(__unused NSManagedObjectContext*)moc
{
    self = [super init];
    self.calledInitWithDictionaryIntoManagedObjectContext = YES;
    return self;
}

+ (BOOL)validateDictionary: (__unused NSDictionary *)dictionary
{
    return YES;
}

@end
