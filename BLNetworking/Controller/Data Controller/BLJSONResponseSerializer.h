//
//  BLJSONResponseSerializer.h
//
//  Created by Burton Lee on 10/11/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All use permitted.
//

#import "AFURLResponseSerialization.h"

// Contains an NSData of the body content of the received response.
static NSString* const kBLJSONResponseSerializerKeyRawData = @"kBLJSONResponseSerializerKeyRawData";
// Contains a Foundation object representing a serialized JSON response from the server.  
static NSString* const kBLJSONResponseSerializerKeyJSONData = @"kBLJSONResponseSerializerKeyJSONData";

@interface BLJSONResponseSerializer : AFJSONResponseSerializer

@end
