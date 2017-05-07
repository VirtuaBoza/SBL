//
//  CCIEventStore.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/16/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCISleepEvent;
@class CCIFeedEvent;
@class CCIEvent;

@interface CCIEventStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allEvents;

+ (instancetype)sharedStore;

- (CCIEvent *)createEventWithEventType:(NSString *)eventType
                             startTime:(NSDate *)startTime
                               bedTime:(NSDate *)bedTime
                              wakeTime:(NSDate *)wakeTime
                                 isNap:(BOOL)isNap
                          feedDuration:(int)feedDuration
                           sourceIndex:(int)sourceIndex
                           diaperIndex:(int)diaperIndex
                                  note:(NSString *)note;


- (void)removeEvent:(CCIEvent *)event;

- (BOOL)saveChanges;

@end
