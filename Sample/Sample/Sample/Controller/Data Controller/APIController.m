//
// Sample BLAPIController subclass implementation
//
//

#import "APIController.h"
#import "Contact.h"

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

- (BOOL)getContactsWithSuccess: (apiSuccessBlock)success failure: (apiFailureBlock)failure
{   
    // Return blocks
    NSDictionary* blocks = [self completionBlocksWithSuccess:success
                                                     failure:failure
                                                  modelClass:[Contact class]
                                        managedObjectContext:nil
                                     successNotificationName:kNotificationAPIControllerGetContactsSucceeded
                                     failureNotificationName:kNotificationAPIControllerGetContactsFailed
                                                  atomicLock:nil
                                                responsePath:@"contacts"
                                                       queue:nil];
    
    
    // AFSessionManager HTTP Method
    [self GET:@"contacts"
   parameters:nil
      success:blocks[kBLAPIControllerSuccessBlockKey]
      failure:blocks[kBLAPIControllerFailureBlockKey]];
    
    return YES;
}

@end
