//
//  CCIEvent.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/20/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIEvent.h"

@implementation CCIEvent

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
{
    
    self = [super init];
    
    self.eventType = eventType;
    self.startTime = startTime;
    self.bedTime = bedTime;
    self.wakeTime = wakeTime;
    self.isNap = isNap;
    self.feedDuration = feedDuration;
    self.sourceIndex = sourceIndex;
    self.diaperIndex = diaperIndex;
    self.note = note;
    
    if ([self.eventType isEqualToString:@"sleepEvent"]) {
        
        if (!self.bedTime && self.wakeTime) {
            
            self.startTime = self.wakeTime;
            
        } else {
            
            self.startTime = self.bedTime;
            
        }
        /*
        if (!self.bedTime || !self.wakeTime) {
            
            self.sleepDuration = 0.0;
            
        } else {
            
            self.sleepDuration = [self.wakeTime timeIntervalSinceDate:self.bedTime];
            NSLog(@"sleepDuration: %f", self.sleepDuration);
            
        }
         */
    }
    
    return self;
    
}

- (instancetype)init
{
    
    self = [self initWithEventType:nil
                         startTime:nil
                           bedTime:nil
                          wakeTime:nil
                             isNap:nil
                      feedDuration:0
                       sourceIndex:0
                       diaperIndex:0
                              note:nil];
    
    return self;
    
}

- (NSString *)description
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    //This may be breaking stats calculations if the events aren't loaded into the LogView before being added to StatsView. Like you only look at today in LogView and then look at all time once you get on StatsView
    if ([self.eventType isEqualToString:@"sleepEvent"]) {
        
        if (!self.bedTime || !self.wakeTime) {
            
            self.sleepDuration = 0.0;
            
        } else {
            
            self.sleepDuration = [self.wakeTime timeIntervalSinceDate:self.bedTime];
            NSLog(@"sleepDuration: %f", self.sleepDuration);
            
        }
        
        NSLog(@"%f", self.sleepDuration);
        
        NSString *bedTimeString = [dateFormatter stringFromDate:self.bedTime];
        NSString *wakeTimeString = [dateFormatter stringFromDate:self.wakeTime];
                
        long min = self.sleepDuration/60;
        long hrs = self.sleepDuration/60/60;
        long rMinutes = min - hrs * 60;
        
        if (!self.wakeTime && self.bedTime) {
            
            if (self.isNap) {
                return [[NSString alloc] initWithFormat:@"%@: Went Down for Nap", bedTimeString];

            } else {
                return [[NSString alloc] initWithFormat:@"%@: Went Down", bedTimeString];

            }
            
        } else if (self.wakeTime && !self.bedTime) {
            
            if (self.isNap) {
                return [[NSString alloc] initWithFormat:@"%@: Woke from Nap", wakeTimeString];
            } else {
                return [[NSString alloc] initWithFormat:@"%@: Woke", wakeTimeString];
            }
            
        } else if (self.sleepDuration <= 60) {
            
            if (self.isNap) {
                return [[NSString alloc] initWithFormat:@"%@: Napped - 1 min", bedTimeString];
            } else {
                return [[NSString alloc] initWithFormat:@"%@: Slept - 1 min", bedTimeString];
            }
            
        } else if (self.sleepDuration > 60 && self.sleepDuration < 60 * 60){
            
            if (self.isNap) {
                return [[NSString alloc] initWithFormat:@"%@: Napped - %ld min", bedTimeString, min];
            } else {
                return [[NSString alloc] initWithFormat:@"%@: Slept - %ld min", bedTimeString, min];
            }
        } else if (hrs == 1) {
            
            if (self.isNap) {
                return [[NSString alloc] initWithFormat:@"%@: Napped - 1 hr %ld min", bedTimeString, rMinutes];
            } else {
                return [[NSString alloc] initWithFormat:@"%@: Slept - 1 hr %ld min", bedTimeString, rMinutes];
            }
        } else {
            
            if (self.isNap) {
                return [[NSString alloc] initWithFormat:@"%@: Napped - %ld hrs %ld min", bedTimeString, hrs, rMinutes];
            } else {
                return [[NSString alloc] initWithFormat:@"%@: Slept - %ld hrs %ld min", bedTimeString, hrs, rMinutes];
            }
        }
        
    } else if ([self.eventType isEqualToString:@"feedEvent"]) {
        
        NSString *startTimeString = [dateFormatter stringFromDate:self.startTime];
        NSArray *sourceArray = @[@"Both", @"Left", @"Right", @"Bottle"];
        NSString *sourceString = sourceArray[self.sourceIndex];
        
        return [[NSString alloc] initWithFormat:@"%@: Fed - %@ - %d min", startTimeString, sourceString, self.feedDuration / 60];
        
    } else if ([self.eventType isEqualToString:@"diaperEvent"]) {
        
        NSString *startTimeString = [dateFormatter stringFromDate:self.startTime];
        NSArray *diaperArray = @[@"Wet and Dirty", @"Wet", @"Dirty"];
        NSString *diaperString = diaperArray[self.diaperIndex];
        
        return [[NSString alloc] initWithFormat:@"%@: %@ Diaper", startTimeString, diaperString];
    }
    
    return [super description];
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"eventType: %@", self.eventType);
    NSLog(@"startTime: %@", self.startTime);
    NSLog(@"bedTime: %@", self.bedTime);
    NSLog(@"wakeTime: %@", self.wakeTime);
    NSLog(@"isNap: %d", self.isNap);
    NSLog(@"feedDuration: %d", self.feedDuration);
    NSLog(@"sourceIndex: %d", self.sourceIndex);
    NSLog(@"diaperIndex: %d", self.diaperIndex);
    NSLog(@"note: %@", self.note);
    [aCoder encodeObject:self.eventType forKey:@"eventType"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.bedTime forKey:@"bedTime"];
    [aCoder encodeObject:self.wakeTime forKey:@"wakeTime"];
    [aCoder encodeBool:self.isNap forKey:@"isNap"];
    [aCoder encodeInt:self.feedDuration forKey:@"feedDuration"];
    [aCoder encodeInt:self.sourceIndex forKey:@"sourceIndex"];
    [aCoder encodeInt:self.diaperIndex forKey:@"diaperIndex"];
    [aCoder encodeObject:self.note forKey:@"note"];
    NSLog(@"Executing Encoding");
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    
    if (self) {
        _eventType = [aDecoder decodeObjectForKey:@"eventType"];
        _startTime = [aDecoder decodeObjectForKey:@"startTime"];
        _bedTime = [aDecoder decodeObjectForKey:@"bedTime"];
        _wakeTime = [aDecoder decodeObjectForKey:@"wakeTime"];
        _isNap = [aDecoder decodeBoolForKey:@"isNap"];
        _feedDuration = [aDecoder decodeIntForKey:@"feedDuration"];
        _sourceIndex = [aDecoder decodeIntForKey:@"sourceIndex"];
        _diaperIndex = [aDecoder decodeIntForKey:@"diaperIndex"];
        _note = [aDecoder decodeObjectForKey:@"note"];
        NSLog(@"eventType: %@", _eventType);
        NSLog(@"startTime: %@", _startTime);
        NSLog(@"bedTime: %@", _bedTime);
        NSLog(@"wakeTime: %@", _wakeTime);
        NSLog(@"isNap: %d", _isNap);
        NSLog(@"feedDuration: %d", _feedDuration);
        NSLog(@"sourceIndex: %d", _sourceIndex);
        NSLog(@"diaperIndex: %d", _diaperIndex);
        NSLog(@"note: %@", _note);
    }
    return self;
    
}

@end
