//
//  NSDictionary+StripNullObjects.m
//
//  Created by Burton Lee on 4/9/13.
//  Copyright (c) 2013 Buffalo Ladybug, Inc. All use permitted.
//

#import "NSDictionary+StripNullObjects.h"

@implementation NSDictionary (StripNullObjects)

- (id)nullStrippedObjectForKey: (NSString *)key
{
    id obj = [self objectForKey:key];
    
    if (obj == [NSNull null])
        obj = nil;
    
    return obj;
}

@end
