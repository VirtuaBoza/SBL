//
//  CCILogViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/16/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCILogViewController.h"
#import "CCIEventStore.h"
#import "CCINewEventViewController.h"
#import "CCIFilterLogViewController.h"
#import "CCIEvent.h"
#import "CCISleepViewController.h"
#import "CCIFeedViewController.h"
#import "CCIDiaperViewController.h"
#import "CCINotesViewController.h"

@interface CCILogViewController ()

@property (nonatomic) NSMutableArray *sortedAndFilteredArray;
@property (nonatomic) BOOL arrayIsAscending;
@property (nonatomic) short eventOptionIndex;
@property (nonatomic) short dateOptionIndex;
@property (nonatomic) NSString *firstString;
@property (nonatomic) NSString *secondString;

- (void)sortAndFilterArray;

@end

@implementation CCILogViewController

#pragma mark - Initializers

// Designated initializer
- (instancetype)init
{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

        UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                       target:self
                                                                                       action:@selector(addNewEvent:)];
        
        self.navigationItem.rightBarButtonItem = addButtonItem;
        
        self.arrayIsAscending = YES;
        UIBarButtonItem *sortButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Old to New"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(toggleSortMode:)];
        self.navigationItem.leftBarButtonItem = sortButtonItem;
        
        self.eventOptionIndex = 0;
        self.dateOptionIndex = 0;
        
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"UITableViewCell"];

    }
    
    return self;
}

#pragma mark - Displaying and working the table

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return [self.sortedAndFilteredArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    CCIEvent *event = self.sortedAndFilteredArray[indexPath.row];
    
    if ([event.eventType isEqualToString:@"sleepEvent"] && event.wakeTime) {
        
        NSDateComponents *dateComponentsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger yearToday = [dateComponentsToday year];
        
        NSInteger dayOfYearToday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                           inUnit:NSCalendarUnitYear
                                                                          forDate:[NSDate date]];
        
        NSDateComponents *dateComponentsEvent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                                fromDate:event.startTime];
        NSInteger yearEvent = [dateComponentsEvent year];
        
        NSInteger dayOfYearEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                           inUnit:NSCalendarUnitYear
                                                                          forDate:event.startTime];
        
        NSInteger dayOfYearWakeEvent;
        
        dayOfYearWakeEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                     inUnit:NSCalendarUnitYear
                                                                    forDate:event.wakeTime];
        if (event.wakeTime && yearEvent == yearToday && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearWakeEvent == dayOfYearToday) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:event.startTime], [event description]];
        } else if (event.wakeTime && yearEvent == yearToday - 1 && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearEvent == 1 && dayOfYearWakeEvent == dayOfYearToday) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:event.startTime], [event description]];
        } else {
            cell.textLabel.text = [event description];
        }
        
    } else if (self.dateOptionIndex == 2 || self.dateOptionIndex == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:event.startTime], [event description]];
    } else {
        
        cell.textLabel.text = [event description];
        
    }
    
    if (event.note) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    [self sortAndFilterArray];
    
    switch (self.dateOptionIndex) {
        case 0:
            self.firstString = @"Today's";
            break;
        case 1:
            self.firstString = @"Yesterday's";
            break;
        case 2:
            self.firstString = @"Past Week's";
            break;
        case 3:
            self.firstString = @"All Time";
            break;
    }
    
    switch (self.eventOptionIndex) {
        case 0:
            self.secondString = @"Log";
            break;
        case 1:
            self.secondString = @"Naps";
            break;
        case 2:
            self.secondString = @"Feedings";
            break;
        case 3:
            self.secondString = @"Poops";
            break;
    }
    
    UIButton *navTitleButon = [UIButton buttonWithType:UIButtonTypeSystem];
    [navTitleButon addTarget:self
                      action:@selector(openFilter:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [navTitleButon setTitle:[NSString stringWithFormat:@"%@ %@ \u25be", self.firstString, self.secondString]
                   forState:UIControlStateNormal];
    
    [navTitleButon setTitleColor:[UIColor blackColor]
                        forState:UIControlStateNormal];
    
    [navTitleButon.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium"
                                                      size:17]];
    self.navigationItem.titleView = navTitleButon;
    
    [self.tableView reloadData];
    
}

// To delete rows/events
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        CCIEvent *copyOfObjectToBeDeleted = self.sortedAndFilteredArray[indexPath.row];
        NSArray *events = [[CCIEventStore sharedStore] allEvents];
        for (CCIEvent *event in events) {
            
            if ([event isEqual:copyOfObjectToBeDeleted]) {
                
                [[CCIEventStore sharedStore] removeEvent:event];
                break;
                
            }
            
        }
        
        [self sortAndFilterArray];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];

        }
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCIEvent *selectedEvent = self.sortedAndFilteredArray[indexPath.row];
    
    NSArray *events = [[CCIEventStore sharedStore] allEvents];
    
    for (CCIEvent *event in events) {
        if ([event isEqual:selectedEvent]) {
            if ([event.eventType isEqualToString:@"sleepEvent"]) {
                CCISleepViewController *svc = [[CCISleepViewController alloc] initForNewSleepEvent:NO];
                svc.event = event;
                [self.navigationController pushViewController:svc
                                                     animated:YES];
            } else if ([event.eventType isEqualToString:@"feedEvent"]) {
                CCIFeedViewController *fvc = [[CCIFeedViewController alloc] initForNewFeedEvent:NO];
                fvc.event = event;
                [self.navigationController pushViewController:fvc
                                                     animated:YES];
            } else if ([event.eventType isEqualToString:@"diaperEvent"]) {
                CCIDiaperViewController *dvc = [[CCIDiaperViewController alloc] initForNewDiaperEvent:NO];
                dvc.event = event;
                [self.navigationController pushViewController:dvc
                                                     animated:YES];
            }
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Button actions

- (void)addNewEvent:(id)sender
{

    CCINewEventViewController *nevc = [[CCINewEventViewController alloc] init];
    [self.navigationController pushViewController:nevc
                                         animated:YES];
    
}

- (void)toggleSortMode:(id)sender
{
    
    if (self.arrayIsAscending == NO) {
        
        self.arrayIsAscending = YES;
        self.navigationItem.leftBarButtonItem.title = @"Old to New";
        [self sortAndFilterArray];
        
    } else {
        
        self.arrayIsAscending = NO;
        self.navigationItem.leftBarButtonItem.title = @"New to Old";
        [self sortAndFilterArray];
        
    }
    
    [self.tableView reloadData];
    
    
    
}

- (void)openFilter:(id)sender
{
    
    CCIFilterLogViewController *filterView = [[CCIFilterLogViewController alloc] init];
    
    filterView.delegate = self;
    
    filterView.eventOptionIndex = self.eventOptionIndex;
    filterView.dateOptionIndex = self.dateOptionIndex;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:filterView];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController
                       animated:YES
                     completion:NULL];
    
}

- (void)addEventChoiceViewController:(CCIFilterLogViewController *)controller didFinishEnteringEventChoice:(short)choice
{
    self.eventOptionIndex = choice;
}

- (void)addDateChoiceViewController:(CCIFilterLogViewController *)controller didFinishEnteringDateChoice:(short)choice
{
    self.dateOptionIndex = choice;
}

- (void)sortAndFilterArray
{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:self.arrayIsAscending];
    NSArray *sortedArray = [[[CCIEventStore sharedStore] allEvents] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
    NSMutableArray *sortedAndFilteredArray = [[NSMutableArray alloc] init];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
        
    for (CCIEvent *event in sortedArray) {
        
        switch (self.eventOptionIndex) {
            case 1:
                if ([event.eventType isEqualToString:@"sleepEvent"]) {
                    [sortedAndFilteredArray addObject:event];
                }
                break;
            case 2:
                if ([event.eventType isEqualToString:@"feedEvent"]) {
                    [sortedAndFilteredArray addObject:event];
                }
                break;
            case 3:
                if ([event.eventType isEqualToString:@"diaperEvent"]) {
                    [sortedAndFilteredArray addObject:event];
                }
                break;
            default:
                [sortedAndFilteredArray addObject:event];
                break;
                
        }

    }
    
    NSDateComponents *dateComponentsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger yearToday = [dateComponentsToday year];
    
    NSInteger dayOfYearToday = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                        inUnit:NSCalendarUnitYear
                                                                       forDate:[NSDate date]];
    
    for (CCIEvent *event in sortedAndFilteredArray) {
        
        NSDateComponents *dateComponentsEvent = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                      fromDate:event.startTime];
        NSInteger yearEvent = [dateComponentsEvent year];
        
        NSInteger dayOfYearEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                            inUnit:NSCalendarUnitYear
                                                                           forDate:event.startTime];
        
        NSInteger dayOfYearWakeEvent;
        
        switch (self.dateOptionIndex) {
            case 0:
                
                dayOfYearWakeEvent = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay
                                                                             inUnit:NSCalendarUnitYear
                                                                            forDate:event.wakeTime];
                
                // Filter here for dateIndex 0 (Today)
                if ([event.eventType isEqualToString:@"sleepEvent"] && event.wakeTime && yearEvent == yearToday && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearWakeEvent == dayOfYearToday) {
                    [finalArray addObject:event];
                } else if ([event.eventType isEqualToString:@"sleepEvent"] && event.wakeTime && yearEvent == yearToday - 1 && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearEvent == 1 && dayOfYearWakeEvent == dayOfYearToday) {
                    [finalArray addObject:event];
                } else if (yearEvent == yearToday && dayOfYearEvent == dayOfYearToday) {
                    [finalArray addObject:event];
                }
                break;
            case 1:
                // Filter here for dateIndex 1 (Yesterday)
                if (yearEvent == yearToday && dayOfYearEvent == dayOfYearToday - 1) {
                    [finalArray addObject:event];
                } else if (yearEvent == yearToday - 1 && dayOfYearEvent == dayOfYearToday - 1 && dayOfYearEvent == 1) {
                    [finalArray addObject:event];
                }
                break;
            case 2:
                // Filter here for dateIndex 2 (Past Week)
                if (yearEvent == yearToday && dayOfYearEvent >= dayOfYearEvent - 6) {
                    [finalArray addObject:event];
                } else if (yearEvent == yearToday - 1 && dayOfYearEvent >= dayOfYearToday - 6 && dayOfYearEvent < 7) {
                    [finalArray addObject:event];
                }
                break;
            default:
                // No filter here for dateIndex 3 (All Time)
                [finalArray addObject:event];
                break;
        
        }
    
    }
    
    self.sortedAndFilteredArray = [finalArray copy];
    
}


- (void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    
    CCIEvent *selectedEvent = self.sortedAndFilteredArray[indexPath.row];
    
    NSArray *events = [[CCIEventStore sharedStore] allEvents];
    
    for (CCIEvent *event in events) {
        if ([event isEqual:selectedEvent]) {

            CCINotesViewController *nvc = [[CCINotesViewController alloc] initFromLog:YES];
            nvc.event = event;
            [self.navigationController pushViewController:nvc
                                                     animated:YES];
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
