//
//  CCIEventStore.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/16/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIEventStore.h"
#import "CCIEvent.h"

@interface CCIEventStore ()

@property (nonatomic) NSMutableArray *privateEvents;

@end

@implementation CCIEventStore

// Designated initializer for singleton
- (instancetype)initPrivate
{
    
    self = [super init];
    
    if (self) {
        
        NSString *path = [self eventArchivePath];
        _privateEvents = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create an empty one
        if (!_privateEvents) {
            _privateEvents = [[NSMutableArray alloc] init];
            NSLog(@"Did NOT load events");
        } else {
            NSLog(@"Loaded events");
            NSLog(@"%@", _privateEvents);
        }
        
    }
    return self;
}

// Throw exception if you try to init other than sharedStore
- (instancetype)init
{
    
    [NSException raise:@"Singleton"
                format:@"Use +[CCIEventStore sharedStore]"];
    return nil;
    
}

// Create singleton
+ (instancetype)sharedStore
{
    
    static CCIEventStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });

    return sharedStore;
}

- (NSArray *)allEvents
{
    return [self.privateEvents copy];
}

- (CCIEvent *)createEventWithEventType:(NSString *)eventType
                             startTime:(NSDate *)startTime
                               bedTime:(NSDate *)bedTime
                              wakeTime:(NSDate *)wakeTime
                                 isNap:(BOOL)isNap
                          feedDuration:(int)feedDuration
                           sourceIndex:(int)sourceIndex
                           diaperIndex:(int)diaperIndex
                                  note:(NSString *)note
{
    
    CCIEvent *event = [[CCIEvent alloc] initWithEventType:eventType
                                                startTime:startTime
                                                  bedTime:bedTime
                                                 wakeTime:wakeTime
                                                    isNap:isNap
                                             feedDuration:feedDuration
                                              sourceIndex:sourceIndex
                                              diaperIndex:diaperIndex
                                                     note:note];
    [self.privateEvents addObject:event];
    return event;
    
}

- (void)removeEvent:(NSObject *)event
{
    
    [self.privateEvents removeObjectIdenticalTo:event];
    
}

- (NSString *)eventArchivePath
{
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"events.archive"];
    
}

- (BOOL)saveChanges
{
    
    NSString *path = [self eventArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateEvents
                                       toFile:path];
    
}




@end
