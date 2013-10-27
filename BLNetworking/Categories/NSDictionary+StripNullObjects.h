//
//  NSDictionary+StripNullObjects.h
//
//  Created by Burton Lee on 4/9/13.
//  Copyright (c) 2013 Buffalo Ladybug, LLC. All use permitted.
//

#import <Foundation/Foundation.h>

// get an NSNull instead of a nil for an obj.
id nilProtectedValueFromObject(id obj);

@interface NSDictionary (StripNullObjects)

// get a nil instead of an NSNull in the dictionary.
- (id)nullStrippedObjectForKey: (NSString *)key;

@end
