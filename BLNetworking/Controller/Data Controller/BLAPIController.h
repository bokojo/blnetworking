//
//  BLAPIController.h
//
//  Created by Burton Lee on 10/11/13.
//  Copyright (c) 2013 Buffalo Ladybug LLC. All use permitted.
//

@import Foundation;

#import "AFHTTPSessionManager.h"
#import "BLJSONResponseSerializer.h"
#import "BLParseOperation.h"
#import "BLModel.h"

//
// Internal Constants
//
// Block Dictionary keys

static NSString* const kBLAPIControllerSuccessBlockKey = @"success";
static NSString* const kBLAPIControllerFailureBlockKey = @"failure";

// Notification UserInfo Keys

static NSString* const kBLAPIControllerNotificationTaskKey = @"task";
static NSString* const kBLAPIControllerNotificationErrorKey = @"error";
static NSString* const kBLAPIControllerNotificationResponseObjectKey = @"response";

////// Helper block typedefs
typedef void (^afFailureBlock)(NSURLSessionDataTask*, NSError*);
typedef void (^afSuccessBlock)(NSURLSessionDataTask*, id);
typedef void (^apiSuccessBlock)(NSArray*);
typedef void (^apiFailureBlock)(NSError*);

@interface BLAPIController : AFHTTPSessionManager

/*
//  completionBlocksWithSuccess:failure... is the intended configuration method for processing an API call.  It returns an NSDictionary containing two block pointers keyed to kBLAPIControllerSuccessBlockKey and kBLAPIControllerFailureBlockKey.

//  Within the API implementation methods of a BLAPIController's subclass, pass the apiSuccessBlock and apiFailureBlock parameters to this method to receieve compatible AFNetworking afSuccessBlock and afFailureBlocks.

//  Pass a class of a model complying with <BLModel> to serialize JSON into the custom model objects.  Models implement initWithDictionary: or initWithDictionary:inManagedObjectContext.  No saving is performed on the NSManagedObjectContext by default.  CoreData is seen as out of scope of this project, and left between <BLModel> and a CoreData package.  If left nil, the output NSArray* will contain the Foundation object representaton returned by the JSONSerializer; likely NSDictionaries.

//  Pass the names of success and failure notifications if you wish to subscribe multiple controllers to the results of this API call, for example to save the ManagedObjectContext after serializing a bunch of new objects, or to update parent and child view controllers presenting the same data set.

//  Pass a pointer to a BOOL value to use as an atomic lock on the API itself.  APIs with shared data sets across multiple view controllers can use this feature to ensure that once a fetch for shared data is initiated, it is allowed to continue without spawning subsequent fetches of the same data.  It is left up to subclasses to implement the actual check of the lock prior to issuing the HTTP AFHTTPSessionManager method, and to return a BOOL value from the encapsulated api method reflecting the state of this lock.  It is separate from the failure() block that you provide.

//  ResponsePath is a keyed subpath to traverse a series of nested key:value pairs in the JSON returned by the server. This allows flexbility to tailor behavior to the specific format of the API.  For example, a return like this:


{
  "v1" : {
    {
      "contacts" : [
        {
          "key" : "attribute",
          "key" : "attribute"
        }
      ]
    }
 }


//  can be traversed with a responsePath of @"v1.contacts".  Traversal stops when an array is encountered.  You can construct model  objects that serialize additional arrays of subsequent model objects.  If the terminal object is a dictionary and not an array, it will encapsulate the dictionary in an array, and return an array containing the dictionary to the client view controller's success() block and notification.
 
//  Queue lets you specify separate operation queues.  This can provide a measure of cancellation to parse operations. By grouping parse operations for related data, all those related to a specific set of data can be cancelled together. Use of this feature lets you clobber existing operations on an API call, allowing the most recently spawned attempt return the data.  This is in opposition to the (BOOL *)lock parameter, which lets you protect a running process.  In both cases, it is up to the API implementation method to check for the state of the lock, or to cancel the operations in a specific queue, if that behavior is desired.  In most conventional API returns, it probably doesn't make a difference, as the parse operation is sufficiently quick.
 
//  It is perfectly reasonable to configure this method with no parameters other than the success and/or failure blocks. It will give you blocks no matter if you give it nothing at all.
*/
- (NSDictionary *)completionBlocksWithSuccess: (apiSuccessBlock)success failure: (apiFailureBlock)failure modelClass: (Class <BLModel>)model managedObjectContext:(NSManagedObjectContext *)moc successNotificationName: (NSString *)successNote failureNotificationName: (NSString *)failureNote atomicLock: (BOOL *)lock responsePath: (NSString *)path queue: (NSOperationQueue *)queue;

//
// initWithBaseURL:sessionConfiguration: is the default initializer.  initWithBaseURL resolves there with a nil value for
// the sessionConfiguration.
//
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration;

@property (nonatomic, strong) NSOperationQueue* backgroundQueue;

@end
