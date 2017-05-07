//
//  CCINewEventViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/16/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCINewEventViewController.h"
#import "CCISleepViewController.h"
#import "CCIEventStore.h"
#import "CCIFeedViewController.h"
#import "CCIDiaperViewController.h"
#import "CCINotesViewController.h"

@implementation CCINewEventViewController

// Designated initializer
- (instancetype)init
{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.navigationItem.title = @"New Event";
        
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:nil
                                                                                action:nil];
        
        if (!self.events) {
            self.events = @[@"Sleep/Wake", @"Feeding", @"Diaper Change"];
            self.quickEvents = @[@"Just Went Down", @"Just Woke Up"];
        }
        
        UIImage *bottleImage = [UIImage imageNamed:@"Bottle.png"];
        UIImage *moonImage = [UIImage imageNamed:@"moon.png"];
        UIImage *poopImage = [UIImage imageNamed:@"Poop.png"];
        UIImage *sunImage = [UIImage imageNamed:@"Sun.png"];
        UIImage *zzzImage = [UIImage imageNamed:@"Zzz.png"];
        self.eventImages = @[zzzImage, bottleImage, poopImage];
        self.quickEventImages = @[moonImage, sunImage];
        
    }
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"selectCell"];
    
    return self;
}

// Point toward designated initializer
/*
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return [self init];
    
}
*/
#pragma mark - Displaying and working the table

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"selectCell"];
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"quickCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.events[indexPath.row];
            cell.imageView.image = self.eventImages[indexPath.row];
            return cell;
            break;
        case 1:
            c.textLabel.text = self.quickEvents[indexPath.row];
            c.imageView.image = self.quickEventImages[indexPath.row];
            return c;
            break;
        default:
            return cell;
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1; //I'm pretty sure this is how I killed off the second section with the quick Wake/Sleep options
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        CCISleepViewController *svc = [[CCISleepViewController alloc] initForNewSleepEvent:YES];
        [self.navigationController pushViewController:svc
                                             animated:YES];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
     
        CCIFeedViewController *fvc = [[CCIFeedViewController alloc] initForNewFeedEvent:YES];
        [self.navigationController pushViewController:fvc
                                             animated:YES];
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        CCIDiaperViewController *dvc = [[CCIDiaperViewController alloc] initForNewDiaperEvent:YES];
        [self.navigationController pushViewController:dvc
                                             animated:YES];
        
    } /* else if (indexPath.section == 1 && indexPath.row == 0) {
        
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:[NSDate date]
                                                     wakeTime:nil
                                                        isNap:nil
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:nil
                                                     wakeTime:[NSDate date]
                                                        isNap:nil
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } */
    
}


@end
