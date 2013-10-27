//
// Sample BLAPIController subclass implementation
//
//

#import "APIController.h"
#import "Thing.h"

@implementation APIController

#pragma mark - Initialization

+ (APIController *)sharedController
{
    static APIController* controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[super alloc] initWithBaseURL:[NSURL URLWithString:@"YOUR SERVER HERE"] sessionConfiguration:nil];
    });
    
    return controller;
}

#pragma mark - RTAPIController

- (BOOL)getThingsWithSuccess: (apiSuccessBlock)success failure: (apiFailureBlock)failure
{   
    // Return blocks
    NSDictionary* blocks = [self completionBlocksWithSuccess:success
                                                     failure:failure
                                                  modelClass:[Thing class]
                                        managedObjectContext:nil
                                     successNotificationName:kNotificationAPIControllerGetThingsSucceeded
                                     failureNotificationName:kNotificationAPIControllerGetThingsFailed
                                                  atomicLock:nil
                                                responsePath:@"things"
                                                       queue:nil];
    
    
    // AFSessionManager HTTP Method
    [self GET:@"things"
   parameters:nil
      success:blocks[kBLAPIControllerSuccessBlockKey]
      failure:blocks[kBLAPIControllerFailureBlockKey]];
    
    return YES;
}

@end
