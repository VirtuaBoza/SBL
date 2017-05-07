//
//  CCIEvent.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/20/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCIEvent : NSObject <NSCoding>

@property (nonatomic, copy) NSString *eventType;
@property (nonatomic, strong) NSDate *startTime;

@property (nonatomic, strong) NSDate *bedTime;
@property (nonatomic, strong) NSDate *wakeTime;


@property (nonatomic) int feedDuration;
@property (nonatomic) int sourceIndex;

@property (nonatomic) int diaperIndex;

@property (nonatomic) NSString *note;

@property (nonatomic) double sleepDuration;
@property (nonatomic) BOOL isNap;


// Designated initializer
- (instancetype)initWithEventType:(NSString *)eventType
                        startTime:(NSDate *)startTime
                          bedTime:(NSDate *)bedTime
                         wakeTime:(NSDate *)wakeTime
                            isNap:(BOOL)isNap
                     feedDuration:(int)feedDuration
                      sourceIndex:(int)sourceIndex
                      diaperIndex:(int)diaperIndex
                             note:(NSString *)note;


@end
