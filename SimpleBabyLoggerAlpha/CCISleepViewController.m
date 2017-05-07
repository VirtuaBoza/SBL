//
//  CCISleepViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/17/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCISleepViewController.h"
#import "CCIEventStore.h"
#import "CCIDatePickerCell.h"
#import "CCIEvent.h"
#import "CCINotesViewController.h"

@interface CCISleepViewController () 

@property (weak, nonatomic) UIDatePicker *bedDatePicker;
@property (nonatomic) CCIDatePickerCell *bedDateCell;

@property (nonatomic) BOOL bedDateWillSave;
@property (weak, nonatomic) UIDatePicker *wakeDatePicker;
@property (nonatomic) CCIDatePickerCell *wakeDateCell;

@property (nonatomic) BOOL wakeDateWillSave;
@property (nonatomic, copy) NSString *note;
@property (nonatomic) CCIEvent *originalEvent;

@property (nonatomic) BOOL isNap;

@end

@implementation CCISleepViewController

// Designated initializer
- (instancetype)initForNewSleepEvent:(BOOL)isNew
{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINib *nib = [UINib nibWithNibName:@"CCIDatePickerCell"
                                    bundle:nil];
        
        [self.tableView registerNib:nib
             forCellReuseIdentifier:@"CCIDatePickerCell"];
        
        self.bedDateCell = [self.tableView dequeueReusableCellWithIdentifier:@"CCIDatePickerCell"];
        self.bedDatePicker = [self.bedDateCell.contentView.subviews firstObject];
        
        [self.bedDatePicker addTarget:self
                               action:@selector(bedDateChange:)
                     forControlEvents:UIControlEventValueChanged];
        
        self.wakeDateCell = [self.tableView dequeueReusableCellWithIdentifier:@"CCIDatePickerCell"];
        self.wakeDatePicker = [self.wakeDateCell.contentView.subviews firstObject];
        
        [self.wakeDatePicker addTarget:self
                                action:@selector(wakeDateChange:)
                      forControlEvents:UIControlEventValueChanged];
        
        [self.tableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"Switch Cell"];
        
        if (isNew) {
            
            self.navigationItem.title = @"New Sleep/Wake Entry";

            UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(saveSleepWake:)];
            self.navigationItem.rightBarButtonItem = doneButtonItem;
            
            self.bedDateWillSave = NO;
            self.wakeDateWillSave = NO;
            self.bedDatePicker.hidden = YES;
            
        } else {
            
            self.navigationItem.title = @"Edit Sleep/Wake Entry";
            
            UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelButtonItem;
            
            UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(saveChange:)];
            self.navigationItem.rightBarButtonItem = doneButtonItem;
            

        }
        
        
        
        
    }

    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewSleepEvent:"
                                 userInfo:nil];
    return nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (self.event) {
        
        if (self.event.bedTime) {
            self.bedDateWillSave = YES;
            self.bedDatePicker.date = self.event.bedTime;
        }
        if (self.event.wakeTime) {
            self.wakeDateWillSave = YES;
            self.wakeDatePicker.date = self.event.wakeTime;
        }
        if (self.event.note) {
            self.note = [self.event.note copy];
        }
        
        self.isNap = self.event.isNap;
        self.originalEvent = self.event;
        self.event = nil;
        
    }
    
}

#pragma mark - Displaying and working the table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    

    if (section == 0) {
        if (self.wakeDateWillSave) {
            return 5;
        } else {
            return 4;
        }
    } else {
        return 1;
    }

     
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"Switch Cell"];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    aCell.accessoryView = switchView;
    [switchView setOn:NO animated:YES];
    
    UITableViewCell *detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                detailCell.textLabel.text = @"Log as Nap";
                if (self.isNap) {
                    detailCell.detailTextLabel.text = @"Yes";
                } else {
                    detailCell.detailTextLabel.text = @"No";
                }
                return detailCell;
                break;
            case 1:
                if (self.bedDateWillSave == YES) {
                    [switchView setOn:YES];
                }
                
                [switchView addTarget:self
                               action:@selector(bedSwitchChanged:)
                     forControlEvents:UIControlEventValueChanged];
                
                aCell.textLabel.text = @"Log Bedtime";
                return aCell;
                break;
            case 2:
                return self.bedDateCell;
                break;
            case 3:
                if (self.wakeDateWillSave == YES) {
                    [switchView setOn:YES];
                }
                
                [switchView addTarget:self
                               action:@selector(wakeSwitchChanged:)
                     forControlEvents:UIControlEventValueChanged];
                
                aCell.textLabel.text = @"Log Waking";
                return aCell;
                break;
            case 4:
                return self.wakeDateCell;
                break;
            default:
                return nil;
                break;
        }

    } else {
        
        detailCell.textLabel.text = @"Note";
        detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.note) {
            detailCell.detailTextLabel.text = self.note;
        }
        return detailCell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (self.isNap) {
            self.isNap = NO;
            [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"No";
        } else {
            self.isNap = YES;
            [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text = @"Yes";
        }
    }
    
    if (indexPath.section == 1) {
        CCINotesViewController *nvc = [[CCINotesViewController alloc] initFromLog:NO];
        nvc.delegate = self;
        nvc.eventType = @"sleepEvent";
        nvc.note = self.note;
        if (self.event) {
            nvc.event = self.event;
        }
        [self.navigationController pushViewController:nvc animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2  && self.bedDateWillSave == NO) {
            return 0.0f;
        } else if (indexPath.row == 2 && self.bedDateWillSave == YES) {
            return 161.0f;
        } else if (indexPath.row == 4 ) {
            return 161.0f;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Switch controls

- (void)bedSwitchChanged:(id)sender
{
    
    if (self.bedDateWillSave == NO) {

        self.bedDateWillSave = YES;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        self.bedDatePicker.hidden = NO;
        self.bedDatePicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.bedDatePicker.alpha = 1.0f;
                         }];
    
    } else {
        
        self.bedDateWillSave = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.bedDatePicker.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             self.bedDatePicker.hidden = YES;
                         }];
        
    }
    
}

- (void)wakeSwitchChanged:(id)sender
{
    
    if (self.wakeDateWillSave == NO) {
        
        self.wakeDateWillSave = YES;
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil]
                              withRowAnimation:UITableViewRowAnimationTop];
        
    } else {
        
        self.wakeDateWillSave = NO;

        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil]
    withRowAnimation:UITableViewRowAnimationTop];
        
    }
    
}

#pragma mark - Button actions

- (void)bedDateChange:(id)sender
{
    
    [self.tableView reloadData];
    
}

- (void)wakeDateChange:(id)sender
{
    
    [self.tableView reloadData];
    
}

- (void)saveSleepWake:(id)sender
{
    
    if (self.bedDateWillSave == NO && self.wakeDateWillSave == NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Unable to save anything if neither option was selected." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
        
    } else if ([self.wakeDatePicker.date timeIntervalSinceDate:self.bedDatePicker.date] < 0) {
    
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:self.bedDatePicker.date
                                                     wakeTime:nil
                                                        isNap:self.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:nil];
        
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:nil
                                                     wakeTime:self.wakeDatePicker.date
                                                        isNap:self.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:self.note];
    
    } else if (self.bedDateWillSave == YES && self.wakeDateWillSave == NO) {
        
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:self.bedDatePicker.date
                                                     wakeTime:nil
                                                        isNap:self.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:self.note];
                
    } else if (self.bedDateWillSave == NO && self.wakeDateWillSave == YES) {
                
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:nil
                                                     wakeTime:self.wakeDatePicker.date
                                                        isNap:self.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:self.note];
                
    } else {
                
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:self.bedDatePicker.date
                                                     wakeTime:self.wakeDatePicker.date
                                                        isNap:self.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:self.note];
                
    }
            
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)cancel:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)saveChange:(id)sender
{
    
    if (self.bedDateWillSave == NO && self.wakeDateWillSave == NO) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Unable to save anything if neither option was selected." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
        
    } else {
        
        NSArray *events = [[CCIEventStore sharedStore] allEvents];
        
        for (CCIEvent *event in events) {
            if ([event isEqual:self.originalEvent]) {
                [[CCIEventStore sharedStore] removeEvent:event];
            }
        }
        
        CCIEvent *editedEvent = [[CCIEvent alloc] init];
        
        if (self.bedDateWillSave) {
            editedEvent.bedTime = self.bedDatePicker.date;
        }
                
        if (self.wakeDateWillSave) {
            editedEvent.wakeTime = self.wakeDatePicker.date;
        }
        
        editedEvent.isNap = self.isNap;
        
        if ([self.wakeDatePicker.date timeIntervalSinceDate:self.bedDatePicker.date] < 0) {
        
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:editedEvent.bedTime
                                                     wakeTime:nil
                                                        isNap:editedEvent.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:nil];
        
        [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                    startTime:nil
                                                      bedTime:nil
                                                     wakeTime:editedEvent.wakeTime
                                                        isNap:editedEvent.isNap
                                                 feedDuration:0
                                                  sourceIndex:0
                                                  diaperIndex:0
                                                         note:self.note];
        } else if (self.bedDateWillSave == YES && self.wakeDateWillSave == NO) {
                
                [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                            startTime:nil
                                                              bedTime:editedEvent.bedTime
                                                             wakeTime:nil
                                                                isNap:editedEvent.isNap
                                                         feedDuration:0
                                                          sourceIndex:0
                                                          diaperIndex:0
                                                                 note:self.note];
                
        } else if (self.bedDateWillSave == NO && self.wakeDateWillSave == YES) {
                
                [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                            startTime:nil
                                                              bedTime:nil
                                                             wakeTime:editedEvent.wakeTime
                                                                isNap:editedEvent.isNap
                                                         feedDuration:0
                                                          sourceIndex:0
                                                          diaperIndex:0
                                                                 note:self.note];
                
        } else {
                
                [[CCIEventStore sharedStore] createEventWithEventType:@"sleepEvent"
                                                            startTime:nil
                                                              bedTime:editedEvent.bedTime
                                                             wakeTime:editedEvent.wakeTime
                                                                isNap:editedEvent.isNap
                                                         feedDuration:0
                                                          sourceIndex:0
                                                          diaperIndex:0
                                                                note:self.note];
                
        }
            
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addNoteFromController:(CCINotesViewController *)controller
                         note:(NSString *)note
{
    if (note) {
        self.note = [note copy];
    } else {
        self.note = nil;
    }
    
    [self.tableView reloadData];
    
}

@end
