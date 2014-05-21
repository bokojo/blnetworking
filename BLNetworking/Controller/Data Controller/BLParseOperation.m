//
//  BLParseOperation.m
//  Buffalo Ladybug, LLC
//
//  Created by Burton Lee on 6/20/13.
//  All Use Permitted.
//

#import "BLParseOperation.h"
@import CoreData;

@interface BLParseOperation ()
{
    id _responseObject;
    NSString* _path;
    Class <BLModel> _model;
    NSManagedObjectContext* _moc;
    NSString* _successNote;
    void (^_success)(NSArray *);
    BOOL* _lock;
    NSArray* _models;
}
@end

@implementation BLParseOperation

- (id)initWithResponseObject: (id)responseObject path: (NSString *)path  modelClass: (Class <BLModel>)model managedObjectContext: (NSManagedObjectContext *)moc successNote: (NSString *)successNote successBlock: (void (^)(NSArray* array))success lock:(BOOL *)lock
{
    self = [super init];
    if (self)
    {
        _responseObject = responseObject;
        _path = path;
        _model = model;
        _moc = moc;
        _successNote = successNote;
        _success = success;
        _lock = lock;
    }
    return self;
}

- (void)main
{
        
    //
    // Parse responseObject into destination model objects
    //
    
    // Check cancellation
    
    if ([self isCancelled])
    {
        if (_lock)
            *_lock = NO;
        
        return;
    }
    
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: Parse Operation Started");
    
    // Setup
        
    NSMutableArray* tempModels = [NSMutableArray array];
    id responseArray = nil;
        
    // Could be one object or many objects
        
    // Is it a dictionary or an array?
    if ([_responseObject isKindOfClass:[NSDictionary class]])
    {
        // Is there a keyed subpath?  Path will terminate at the first array it hits
        if (_path)
        {
            NSArray* components = [_path componentsSeparatedByString:@"."];
            id marker = nil;
            for (NSString* item in components)
            {
                if ([components indexOfObject:item] == 0)
                    marker = _responseObject[item];
                else
                    marker = marker[item];
                    
                if (![marker isKindOfClass:[NSDictionary class]])
                    break;
            }
            // Found an array
            if ([marker isKindOfClass:[NSArray class]])
                responseArray = marker;
            
            // Or a single dictionary, which is to be discouraged, I think, but that's my personal preference.
            // Regardless, we always provide an array of even single or zero objects to consumers.
            else if ([marker isKindOfClass:[NSDictionary class]])
                responseArray = @[marker];
        }
        // No path, or path found a dictionary instead of an array
        // Eventually, we just need an array of dictionaries to make objects
        if (!responseArray)
            responseArray = @[_responseObject];
    }
    // responseObject is already an array
    else if ([_responseObject isKindOfClass:[NSArray class]])
        responseArray = _responseObject;
        
    // An invalid object was delivered, but AFHTTPRequestOperation didn't fail
    // could be a 204 No Content; or some other non-terminal error representing an empty set
    else
        responseArray = @[];
    
    // Check cancellation again
    if ([self isCancelled])
    {
        responseArray = nil;
        
        if (_lock)
            *_lock = NO;
        return;
    }
    
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: ParseOp: Found Objects");
    
    
    // Iterate and initialize models.  Models are <BLModel> so they conform to initWithDictionary:
    // or they conform to initWithDictionary:intoManagedObjectContext: in a CoreData system.  Provide a
    // NSManagedObjectContext to use that initializer.
    for (NSDictionary* modelDict in responseArray)
    {
        id obj = modelDict;
        if (_model)
        {
            if (_moc)
                obj = [[(Class)_model alloc] initWithDictionary:modelDict intoManagedObjectContext:_moc];
            else
                obj = [[(Class)_model alloc] initWithDictionary:modelDict];
        }
        if (obj)
            [tempModels addObject:obj];
    }
    
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: ParseOp: Made NSObjects");
    
        
    // Can still pass an empty array; check in ViewController.  Always an array.  
    _models = [NSArray arrayWithArray:tempModels];
    
    // Final cancellation check
    if ([self isCancelled])
    {
        _models = nil;
        responseArray = nil;
        
        if (_lock)
            *_lock = NO;
        return;
    }
    
    // Return to main thread for notification and client success block
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        // Notify observers
//        if (_successNote)
//            [[NSNotificationCenter defaultCenter] postNotificationName:_successNote object:self userInfo:@{ @"models" : _models }];
//            
//        // Run success client block
//        if (_success)
//            _success(_models);
//        
//        if (_lock)
//            *_lock = NO;
//    });
    
    // To make operation more testable, this was favored over the gcd dispatch_async, which sucks.
    [self performSelectorOnMainThread:@selector(mainThreadDispatch) withObject:nil waitUntilDone:YES];
    
}


- (void)mainThreadDispatch
{
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: ParseOp: Final dispatch");
    
    // Notify observers
    if (_successNote)
        [[NSNotificationCenter defaultCenter] postNotificationName:_successNote object:self userInfo:@{ @"models" : _models }];
    
    // Run success client block
    if (_success)
        _success(_models);
    
    if (_lock)
        *_lock = NO;

}
@end
