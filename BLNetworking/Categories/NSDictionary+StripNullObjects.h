//
//  NSDictionary+StripNullObjects.h
//
//  Created by Burton Lee on 4/9/13.
//  Copyright (c) 2013 Buffalo Ladybug, LLC. All use permitted.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (StripNullObjects)

- (id)nullStrippedObjectForKey: (NSString *)key;

@end
