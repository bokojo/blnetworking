//
//  BLParseOperation.h
//  Buffalo Ladybug, LLC
//
//  Created by Burton Lee on 6/20/13.
//  All Use Permitted.
//

#import <Foundation/Foundation.h>
#import "BLModel.h"

static NSString* const kNotificationBLParseOperationAlertFound = @"kNotificationBLParseOperationAlertFound";

@interface BLParseOperation : NSOperation

@property (nonatomic, assign) BOOL traceEnabled;

- (id)initWithResponseObject: (id)responseObject path: (NSString *)path  modelClass: (Class <BLModel>)model managedObjectContext: (NSManagedObjectContext *)moc successNote: (NSString *)successNote successBlock: (void (^)(NSArray* array))success lock:(BOOL *)lock alertPath: (NSString *)alertPath alertClass: (Class <BLModel>)alert;

@end
