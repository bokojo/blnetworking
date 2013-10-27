//
//  NSDictionary+StripNullObjects.m
//
//  Created by Burton Lee on 4/9/13.
//  Copyright (c) 2013 Buffalo Ladybug, Inc. All use permitted.
//

#import "NSDictionary+StripNullObjects.h"

id nilProtectedValueFromObject(id obj)
{
    id retVal = obj;
    if (!obj)
        retVal = [NSNull null];
    
    return retVal;
}

@implementation NSDictionary (StripNullObjects)

- (id)nullStrippedObjectForKey: (NSString *)key
{
    id obj = self[key];
    
    if (obj == [NSNull null])
        obj = nil;
    
    return obj;
}

@end
