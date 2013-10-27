//
//  Sample BLAPIController subclass
//

#import "BLNetworking.h"

// Notifications

static NSString* const kNotificationRTAPIControllerGetContactsSucceeded = @"kNotificationRTAPIControllerGetContactsSucceeded";
static NSString* const kNotificationRTAPIControllerGetContactsFailed = @"kNotificationRTAPIControllerGetContactsFailed";

@interface APIController : BLAPIController

+ (APIController *)sharedController;

- (BOOL)getContactsWithSuccess: (void(^)(NSArray* contacts))success failure: (void(^)(NSError* error))failure;

@end
