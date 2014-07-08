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
    NSString* _alertPath;
    Class <BLModel> _alert;
}
@end

@implementation BLParseOperation

- (id)initWithResponseObject: (id)responseObject path: (NSString *)path  modelClass: (Class <BLModel>)model managedObjectContext: (NSManagedObjectContext *)moc successNote: (NSString *)successNote successBlock: (void (^)(NSArray* array))success lock:(BOOL *)lock alertPath: (NSString *)alertPath alertClass: (Class <BLModel>)alert
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
        _alertPath = alertPath;
        _alert = alert;
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
    NSArray* responseArray = [self arrayFromResponseObject:_responseObject path:_path];
    
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: ParseOp: Found Objects");
    
    
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: Alert Check Started");
    
    if (_alert && _alertPath)
    {
        NSArray* alertsArray = [self arrayFromResponseObject:_responseObject path:_alertPath];
        for (NSDictionary* alert in alertsArray)
        {
            id obj = nil;
            if (_alert)
            {
                obj = [[(Class)_alert alloc] initWithDictionary:alert];
            }
            if (obj)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBLParseOperationAlertFound object:self userInfo:@{ @"alert" : obj}];
                });
            }
        }
    }
    
    if ([self traceEnabled])
        NSLog(@"TraceEnabled: Alert Check Started");
    
    // Check cancellation again
    if ([self isCancelled])
    {
        responseArray = nil;
        
        if (_lock)
            *_lock = NO;
        return;
    }
    
    
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

- (NSArray *)arrayFromResponseObject: (id)responseObject path:(NSString *)path
{
    NSArray* responseArray = nil;
    
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        // Is there a keyed subpath?  Path will terminate at the first array it hits
        if (path)
        {
            NSArray* components = [_path componentsSeparatedByString:@"."];
            id marker = nil;
            for (NSString* item in components)
            {
                if ([components indexOfObject:item] == 0)
                    marker = responseObject[item];
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
            responseArray = @[responseObject];
    }
    // responseObject is already an array
    else if ([responseObject isKindOfClass:[NSArray class]])
        responseArray = responseObject;
    else
        responseArray = @[];
    
    return responseArray;
}

@end
