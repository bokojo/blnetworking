//
//  BLJSONResponseSerializer.m
//
//  Created by Burton Lee on 10/11/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All use permitted.
//

#import "BLJSONResponseSerializer.h"

@implementation BLJSONResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    // Object fails validation presumably for a failing HTTP response code, not for bad JSON
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error])
    {
        if (*error != nil)
        {
            NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
            
            userInfo[kBLJSONResponseSerializerKeyRawData] = data;
            
            // But if it IS bad JSON, this is how we'll know
            NSError* parseError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            if (json && !parseError)
                userInfo[kBLJSONResponseSerializerKeyJSONData] = json;
            
            NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
            *error = newError;
        }
        
        return nil;
    }
    
    return [super responseObjectForResponse:response data:data error:error];
}
@end
