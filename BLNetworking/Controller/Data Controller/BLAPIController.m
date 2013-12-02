//
//  BLAPIController.m
//
//  Created by Burton Lee on 10/11/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All use permitted.
//

#import "BLAPIController.h"

@interface BLAPIController()

@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

@end

@implementation BLAPIController

@synthesize responseSerializer = _responseSerializer;

#pragma mark - BLAPIController

- (NSDictionary *)completionBlocksWithSuccess: (void(^)(NSArray*))success failure: (void(^)(NSError*))failure modelClass: (Class <BLModel>)model managedObjectContext:(NSManagedObjectContext *)moc successNotificationName: (NSString *)successNote failureNotificationName: (NSString *)failureNote atomicLock: (BOOL *)lock responsePath: (NSString *)path queue: (NSOperationQueue *)queue
{
    
    afSuccessBlock newSuccess = ^(NSURLSessionDataTask *task, id responseObject) {
        
        BLParseOperation* parseOp = [[BLParseOperation alloc] initWithResponseObject:responseObject path:path modelClass:model managedObjectContext:moc successNote:successNote successBlock:success lock:lock];
        
        if (queue)
            [queue addOperation:parseOp];
        else
            [self.backgroundQueue addOperation:parseOp];
    };
    
    afFailureBlock newFailure = ^(NSURLSessionDataTask *task, NSError* error) {
        
        // Free atomic lock
        if (lock)
            *lock = NO;
        
        if (task.state == NSURLSessionTaskStateCanceling)
            return;
        
        // Notify observers of failure
        if (failureNote)
        {
            id errorOrNull = error;
            if (!errorOrNull)
                errorOrNull = [NSNull null];
            
            id taskOrNull = task;
            if (!taskOrNull)
                taskOrNull = [NSNull null];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:failureNote object:self userInfo:@{ kBLAPIControllerNotificationTaskKey : taskOrNull, kBLAPIControllerNotificationErrorKey : errorOrNull }];
        }
        
        // Run failure client block
        if (failure)
            failure(error);
    };
    
    return @{ kBLAPIControllerSuccessBlockKey : newSuccess, kBLAPIControllerFailureBlockKey : newFailure };
    
}

#pragma mark - AFHTTPSessionManager

// initWithBaseURL: also resolves here. 
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self)
    {
        // Provides extra content in userInfo dict of NSError on ^failure() blocks
        _responseSerializer = [BLJSONResponseSerializer serializer];
        
        _backgroundQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

@end
