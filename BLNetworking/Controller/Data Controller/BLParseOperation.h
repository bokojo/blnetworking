//
//  BLParseOperation.h
//  Buffalo Ladybug, LLC
//
//  Created by Burton Lee on 6/20/13.
//  All Use Permitted.
//

#import <Foundation/Foundation.h>
#import "BLModel.h"

@interface BLParseOperation : NSOperation

- (id)initWithResponseObject: (id)responseObject path: (NSString *)path  modelClass:(Class <BLModel>)model managedObjectContext: (NSManagedObjectContext *)moc successNote: (NSString *)successNote successBlock: (void (^)(NSArray* array))success lock:(BOOL *)lock;

@end
