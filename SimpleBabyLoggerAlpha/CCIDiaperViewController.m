//
//  CCIDiaperViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/21/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIDiaperViewController.h"
#import "CCIEventStore.h"
#import "CCIDatePickerCell.h"
#import "CCIDiaperChoiceViewController.h"
#import "CCIEvent.h"
#import "CCINotesViewController.h"

@interface CCIDiaperViewController ()

@property (nonatomic) UIDatePicker *startPicker;
@property (nonatomic) CCIDatePickerCell *dateCell;
@property (nonatomic) BOOL startPickerIsShowing;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) int diaperIndex;
@property (nonatomic) CCIEvent *originalEvent;
@property (nonatomic, copy) NSString *note;

@end

@implementation CCIDiaperViewController

// Designated initializer
- (instancetype)initForNewDiaperEvent:(BOOL)isNew
{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        
        UINib *dateNib = [UINib nibWithNibName:@"CCIDatePickerCell"
                                        bundle:nil];
        
        [self.tableView registerNib:dateNib
             forCellReuseIdentifier:@"CCIDatePickerCell"];
        
        self.dateCell = [self.tableView dequeueReusableCellWithIdentifier:@"CCIDatePickerCell"];
        
        self.startPicker = [self.dateCell.contentView.subviews firstObject];
        
        [self.startPicker addTarget:self
                             action:@selector(dateChange:)
                   forControlEvents:UIControlEventValueChanged];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];

        
        if (isNew) {
            
            self.navigationItem.title = @"New Diaper Entry";
            
            UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(saveDiaperChange:)];
            
            self.navigationItem.rightBarButtonItem = doneButtonItem;

            self.diaperIndex = 0;
            
        } else {
            
            self.navigationItem.title = @"Edit Diaper Entry";
            
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
                                   reason:@"Use initForNewDiaperEvent:"
                                 userInfo:nil];
    return nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.startPicker.hidden = YES;
    self.startPickerIsShowing = NO;
    
    if (self.event) {
        self.startPicker.date = self.event.startTime;
        self.diaperIndex = self.event.diaperIndex;
        
        if (self.event.note) {
            self.note = [self.event.note copy];
        }
        
        self.originalEvent = self.event;
        self.event = nil;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:@"detailCell"];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                detailCell.textLabel.text = @"Time";
                detailCell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.startPicker.date];
                return detailCell;
                break;
            case 1:
                return self.dateCell;
                break;
            case 2:
                switch (self.diaperIndex) {
                    case 0:
                        detailCell.detailTextLabel.text = @"Wet and Dirty";
                        break;
                    case 1:
                        detailCell.detailTextLabel.text = @"Wet";
                        break;
                    case 2:
                        detailCell.detailTextLabel.text = @"Dirty";
                        break;
                    default:
                        break;
                }
                detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                detailCell.textLabel.text = @"Diaper";
                return detailCell;
                break;
            default:
                return detailCell;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1 && self.startPickerIsShowing == NO) {
        return 0.0f;
    } else if (indexPath.row == 1 && self.startPickerIsShowing == YES) {
        return 161.0f;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && self.startPickerIsShowing == NO) {
            [self showDatePickerCell];
        } else if (indexPath.row == 0 && self.startPickerIsShowing == YES) {
            [self hideDatePickerCell];
        } else if (indexPath.row == 2) {
            CCIDiaperChoiceViewController *diaperView = [[CCIDiaperChoiceViewController alloc] init];
            
            diaperView.delegate = self;
            
            diaperView.diaperIndex = self.diaperIndex;
            
            [self.navigationController pushViewController:diaperView
                                                 animated:YES];
            
        }
        
    } else {
        
        CCINotesViewController *nvc = [[CCINotesViewController alloc] initFromLog:NO];
        nvc.delegate = self;
        nvc.eventType = @"feedEvent";
        nvc.note = self.note;
        if (self.event) {
            nvc.event = self.event;
        }
        [self.navigationController pushViewController:nvc animated:YES];
        
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)showDatePickerCell
{
    
    self.startPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.startPicker.hidden = NO;
    self.startPicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startPicker.alpha = 1.0f;
                     }];
    
}

- (void)hideDatePickerCell
{
    
    self.startPickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startPicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.startPicker.hidden = YES;
                     }];
    
}

- (void)saveDiaperChange:(id)sender
{
 
    [[CCIEventStore sharedStore] createEventWithEventType:@"diaperEvent"
                                                startTime:self.startPicker.date
                                                  bedTime:nil
                                                 wakeTime:nil
                                                    isNap:nil
                                             feedDuration:0
                                              sourceIndex:0
                                              diaperIndex:self.diaperIndex
                                                     note:self.note];

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)dateChange:(id)sender
{
    
    [self.tableView reloadData];
    
}

- (void)addDiaperChoiceViewController:(CCIDiaperChoiceViewController *)controller didFinishEnteringDiaperChoice:(short)choice
{
    
    self.diaperIndex = choice;
    [self.tableView reloadData];
    
}

- (void)cancel:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)saveChange:(id)sender
{
    
    CCIEvent *editedEvent = [[CCIEvent alloc] init];
    
    editedEvent.startTime = self.startPicker.date;
    editedEvent.diaperIndex = self.diaperIndex;
    editedEvent.note = self.note;
    
    NSArray *events = [[CCIEventStore sharedStore] allEvents];
    
    for (CCIEvent *event in events) {
        if ([event isEqual:self.originalEvent]) {
            [[CCIEventStore sharedStore] removeEvent:event];
            [[CCIEventStore sharedStore] createEventWithEventType:@"diaperEvent"
                                                        startTime:editedEvent.startTime
                                                          bedTime:nil
                                                         wakeTime:nil
                                                            isNap:nil
                                                     feedDuration:0
                                                      sourceIndex:0
                                                      diaperIndex:editedEvent.diaperIndex
                                                             note:editedEvent.note];
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)addNoteFromController:(CCINotesViewController *)controller note:(NSString *)note
{
    
    if (note) {
        self.note = [note copy];
    } else {
        self.note = nil;
    }
    
    [self.tableView reloadData];
    
}

@end
