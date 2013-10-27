//
//  Sample BLAPIController subclass
//

#import "BLNetworking.h"

// Notifications

static NSString* const kNotificationRTAPIControllerGetThingsSucceeded = @"kNotificationRTAPIControllerGetThingsSucceeded";
static NSString* const kNotificationRTAPIControllerGetThingsFailed = @"kNotificationRTAPIControllerGetThingsFailed";

@interface APIController : BLAPIController

+ (APIController *)sharedController;

- (BOOL)getThingsWithSuccess: (void(^)(NSArray* Things))success failure: (void(^)(NSError* error))failure;

@end
