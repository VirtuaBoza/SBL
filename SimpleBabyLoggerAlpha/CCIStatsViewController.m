//
//  CCIStatsViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/27/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIStatsViewController.h"
#import "CCIEvent.h"
#import "CCIEventStore.h"
#import "CCIFilterStatsViewController.h"

@interface CCIStatsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sleepTime;
@property (weak, nonatomic) IBOutlet UILabel *sleepWakeUps;

@property (weak, nonatomic) IBOutlet UILabel *napTime;
@property (weak, nonatomic) IBOutlet UILabel *napTimes;

@property (weak, nonatomic) IBOutlet UILabel *feedingTimes;
@property (weak, nonatomic) IBOutlet UILabel *feedingTime;
@property (weak, nonatomic) IBOutlet UILabel *feedingSourceRatio;

@property (weak, nonatomic) IBOutlet UILabel *diaperTimes;
@property (weak, nonatomic) IBOutlet UILabel *diaperTimesWet;
@property (weak, nonatomic) IBOutlet UILabel *diaperTimesDirty;

@property (nonatomic, copy) NSMutableArray *sortedAndFilteredArray;
@property (nonatomic) short dateOptionIndex;

- (void)sortAndFilterArray;
- (void)calcSleep;
- (void)calcNaps;
- (void)calcFeedings;
- (void)calcDiapers;

@end

@implementation CCIStatsViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    NSString *string;
    
    switch (self.dateOptionIndex) {
        case 0:
            string = @"Today's";
            break;
        case 1:
            string = @"Yesterday's";
            break;
        case 2:
            string = @"Past Week's";
            break;
        case 3:
            string = @"All Time";
            break;
    }
    
    UIButton *navTitleButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [navTitleButon addTarget:self
                      action:@selector(openFilter)
            forControlEvents:UIControlEventTouchUpInside];
    
    [navTitleButon setTitle:[NSString stringWithFormat:@"%@ Stats \u25be", string]
                   forState:UIControlStateNormal];
    
    [navTitleButon setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
    
    [navTitleButon.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium"
                                                      size:17]];
    self.navigationItem.titleView = navTitleButon;
    
    [self sortAndFilterArray];
    [self calcSleep];
    [self calcNaps];
    [self calcFeedings];
    [self calcDiapers];
    
}

- (void)sortAndFilterArray
{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    NSArray *sortedArray = [[[CCIEventStore sharedStore] allEvents] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSMutableArray *sortedAndFilteredArray = [[NSMutableArray alloc] init];
    
    NSDateComponents *dateComponentsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger yearToday = [dateComponentsToday year];
    
    NSInteger dayOfYearToday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                       inUnit:NSCalendarUnitYear
                                                                      forDate:[NSDate date]];
    
    for (CCIEvent *event in sortedArray) {
        
        NSDateComponents *dateComponentsEvent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                                fromDate:event.startTime];
        NSInteger yearEvent = [dateComponentsEvent year];
        
        NSInteger dayOfYearEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                           inUnit:NSCalendarUnitYear
                                                                          forDate:event.startTime];
        
        //NSInteger yearWakeEvent;
        NSInteger dayOfYearWakeEvent;
        
        if ([event.eventType isEqualToString:@"sleepEvent"] && event.wakeTime) {
            
            //NSDateComponents *dateComponentsWakeEvent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:event.wakeTime];
            
            //yearWakeEvent = [dateComponentsWakeEvent year];
            
            //dayOfYearWakeEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay                                                                               inUnit:NSCalendarUnitYear                                                                              forDate:event.wakeTime];
        }
        
        switch (self.dateOptionIndex) {
            case 0:
                
                dayOfYearWakeEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                             inUnit:NSCalendarUnitYear
                                                                            forDate:event.wakeTime];
                
                // Filter here for dateIndex 0 (Today)
                if ([event.eventType isEqualToString:@"sleepEvent"] && event.wakeTime && yearEvent == yearToday && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearWakeEvent == dayOfYearToday) {
                    [sortedAndFilteredArray addObject:event];
                } else if ([event.eventType isEqualToString:@"sleepEvent"] && event.wakeTime && yearEvent == yearToday - 1 && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearEvent == 1 && dayOfYearWakeEvent == dayOfYearToday) {
                    [sortedAndFilteredArray addObject:event];
                } else if (yearEvent == yearToday && dayOfYearEvent == dayOfYearToday) {
                    [sortedAndFilteredArray addObject:event];
                }
                break;
            case 1:
                // Filter here for dateIndex 1 (Yesterday)
                if (yearEvent == yearToday && dayOfYearEvent == dayOfYearToday - 1) {
                    [sortedAndFilteredArray addObject:event];
                } else if (yearEvent == yearToday - 1 && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearEvent == 1) {
                    [sortedAndFilteredArray addObject:event];
                }
                break;
            case 2:
                // Filter here for dateIndex 2 (Past Week)
                if (yearEvent == yearToday && dayOfYearEvent >= dayOfYearEvent - 6) {
                    [sortedAndFilteredArray addObject:event];
                } else if (yearEvent == yearToday - 1 && dayOfYearEvent >= dayOfYearToday - 6 && dayOfYearEvent < 7) {
                    [sortedAndFilteredArray addObject:event];
                }
                break;
            default:
                // No filter here for dateIndex 3 (All Time)
                [sortedAndFilteredArray addObject:event];
                break;
                
        }
        
    }
    
    self.sortedAndFilteredArray = [sortedAndFilteredArray copy];

    
}

- (void)openFilter
{
    
    CCIFilterStatsViewController *filterView = [[CCIFilterStatsViewController alloc] init];
    
    filterView.delegate = self;

    filterView.dateOptionIndex = self.dateOptionIndex;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:filterView];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController
                       animated:YES
                     completion:NULL];
    
}

- (void)addDateChoiceViewController:(CCIFilterStatsViewController *)controller didFinishEnteringDateChoice:(short)choice
{
    
    self.dateOptionIndex = choice;
    
}

- (void)calcSleep
{
    
    BOOL isAsleep = NO;
    
    double totalSleepDuration = 0;
    
    NSDate *lastBedTime = [[NSDate alloc] init];
    
    for (CCIEvent *event in self.sortedAndFilteredArray) {
        if ([event.eventType isEqualToString:@"sleepEvent"] && !event.isNap) {

            if (event.sleepDuration != 0.0) {
                
                totalSleepDuration = totalSleepDuration + event.sleepDuration;
                
            } else if (!event.wakeTime && event.bedTime) {
                
                isAsleep = YES;
                lastBedTime = event.bedTime;
                
            } else if (event.wakeTime && !event.bedTime) {
                
                if (isAsleep) {
                    totalSleepDuration = totalSleepDuration + [event.wakeTime timeIntervalSinceDate:lastBedTime];
                }
                
                isAsleep = NO;
                
            }
            
        }

    }
    
    long min = totalSleepDuration/60;
    long hrs = totalSleepDuration/60/60;
    long rMinutes = min - hrs * 60;
    
    self.sleepTime.text = [[NSString alloc] initWithFormat:@"%ld Hrs %ld Min", hrs, rMinutes];
    
    short totalWakeUps = 0;
    
    for (CCIEvent *event in self.sortedAndFilteredArray) {
        if ([event.eventType isEqualToString:@"sleepEvent"] && !event.isNap && event.wakeTime) {
            totalWakeUps++;
        }
    }
    
    self.sleepWakeUps.text = [[NSString alloc] initWithFormat:@"%hd Wake Ups", totalWakeUps];
    
}

- (void)calcNaps
{
    
    BOOL isAsleep = NO;
    
    double totalSleepDuration = 0;
    
    NSDate *lastBedTime = [[NSDate alloc] init];
    
    for (CCIEvent *event in self.sortedAndFilteredArray) {
        if ([event.eventType isEqualToString:@"sleepEvent"] && event.isNap) {
            
            if (event.sleepDuration != 0.0) {
                
                totalSleepDuration = totalSleepDuration + event.sleepDuration;
                
            } else if (!event.wakeTime && event.bedTime) {
                
                isAsleep = YES;
                lastBedTime = event.bedTime;
                
            } else if (event.wakeTime && !event.bedTime) {
                
                if (isAsleep) {
                    totalSleepDuration = totalSleepDuration + [event.wakeTime timeIntervalSinceDate:lastBedTime];
                }
                
                isAsleep = NO;
                
            }
            
        }
        
    }
    
    long min = totalSleepDuration/60;
    long hrs = totalSleepDuration/60/60;
    long rMinutes = min - hrs * 60;
    
    self.napTime.text = [[NSString alloc] initWithFormat:@"%ld Hrs %ld Min", hrs, rMinutes];
    
    short totalNaps = 0;
    
    for (CCIEvent *event in self.sortedAndFilteredArray) {
        if ([event.eventType isEqualToString:@"sleepEvent"] && event.isNap && event.bedTime) {
            totalNaps++;
        }
    }
    
    self.napTimes.text = [[NSString alloc] initWithFormat:@"%hd Times", totalNaps];
    
}

- (void)calcFeedings
{
    
    short feedingTimes = 0;
    double totalFeedingDuration = 0;
    double totalBothFeedingDuration = 0;
    double totalLeftFeedingDuration = 0;
    double totalRightFeedingDuration = 0;
    double totalBottleFeedingDuration = 0;
    
    for (CCIEvent *event in self.sortedAndFilteredArray) {
        if ([event.eventType isEqualToString:@"feedEvent"]) {
            feedingTimes++;
            totalFeedingDuration = totalFeedingDuration + event.feedDuration;
            switch (event.sourceIndex) {
                case 0:
                    totalBothFeedingDuration = totalBothFeedingDuration + event.feedDuration;
                    break;
                case 1:
                    totalLeftFeedingDuration = totalLeftFeedingDuration + event.feedDuration;
                    break;
                case 2:
                    totalRightFeedingDuration = totalRightFeedingDuration + event.feedDuration;
                    break;
                case 3:
                    totalBottleFeedingDuration = totalBottleFeedingDuration + event.feedDuration;
                    break;
                default:
                    break;
            }
        }
    }
    
    long min = totalFeedingDuration/60;
    long hrs = totalFeedingDuration/60/60;
    long rMinutes = min - hrs * 60;
    
    self.feedingTimes.text = [[NSString alloc] initWithFormat:@"%hd Times", feedingTimes];
    self.feedingTime.text = [[NSString alloc] initWithFormat:@"%ld Hrs %ld Min", hrs, rMinutes];
    self.feedingSourceRatio.text = [[NSString alloc] initWithFormat:@"%.0f/%.0f/%.0f/%.0f", totalBothFeedingDuration / 60.0, totalLeftFeedingDuration / 60.0, totalRightFeedingDuration / 60.0, totalBottleFeedingDuration / 60.0];
    
}

- (void)calcDiapers
{
    
    short diaperTimes = 0;
    short timesWet = 0;
    short timesDirty = 0;
    
    for (CCIEvent *event in self.sortedAndFilteredArray) {
        if ([event.eventType isEqualToString:@"diaperEvent"]) {
            diaperTimes++;
            switch (event.diaperIndex) {
                case 0:
                    timesWet++;
                    timesDirty++;
                    break;
                case 1:
                    timesWet++;
                    break;
                case 2:
                    timesDirty++;
                    break;
                default:
                    break;
            }
        }
    }
    
    self.diaperTimes.text = [[NSString alloc] initWithFormat:@"%hd Times", diaperTimes];
    self.diaperTimesWet.text = [[NSString alloc] initWithFormat:@"%hd Wet", timesWet];
    self.diaperTimesDirty.text = [[NSString alloc] initWithFormat:@"%hd Dirty", timesDirty];
    
}

@end
