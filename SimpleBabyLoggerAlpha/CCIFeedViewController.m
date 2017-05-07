//
//  CCIFeedViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/18/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIFeedViewController.h"
#import "CCIEventStore.h"
#import "CCIDatePickerCell.h"
#import "CCITimePickerCell.h"
#import "CCISourceViewController.h"
#import "CCIEvent.h"
#import "CCINotesViewController.h"


@interface CCIFeedViewController ()

@property (nonatomic) UIDatePicker *startPicker;
@property (nonatomic) CCIDatePickerCell *dateCell;
@property (nonatomic) BOOL startPickerIsShowing;
@property (nonatomic) CCITimePickerCell *timeCell;
@property (nonatomic) UIDatePicker *timePicker;
@property (nonatomic) BOOL timePickerIsShowing;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) int sourceIndex;
@property (nonatomic) CCIEvent *originalEvent;
@property (nonatomic, copy) NSString *note;

@end

@implementation CCIFeedViewController

// Designated initializer
- (instancetype)initForNewFeedEvent:(BOOL)isNew
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
        
        
        UINib *timeNib = [UINib nibWithNibName:@"CCITimePickerCell"
                                        bundle:nil];
        
        [self.tableView registerNib:timeNib
             forCellReuseIdentifier:@"CCITimePickerCell"];
        
        self.timeCell = [self.tableView dequeueReusableCellWithIdentifier:@"CCITimePickerCell"];
        self.timePicker = [self.timeCell.contentView.subviews firstObject];
        
        [self.timePicker addTarget:self
                            action:@selector(timeChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
        if (isNew) {
            
            self.navigationItem.title = @"New Feeding Entry";
            
            UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(saveFeeding:)];
            self.navigationItem.rightBarButtonItem = doneButtonItem;
        
            dispatch_async(dispatch_get_main_queue(), ^{
            self.timePicker.countDownDuration = 60;
            });
        
            self.sourceIndex = 0;
        
        } else {
            
            self.navigationItem.title = @"Edit Feeding Entry";
            
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
                                   reason:@"Use initForNewFeedEvent:"
                                 userInfo:nil];
    return nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.startPicker.hidden = YES;
    self.timePicker.hidden = YES;
    self.startPickerIsShowing = NO;
    self.timePickerIsShowing = NO;
    
    if (self.event) {
        self.startPicker.date = self.event.startTime;
        self.timePicker.countDownDuration = self.event.feedDuration;
        self.sourceIndex = self.event.sourceIndex;
        self.originalEvent = self.event;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timePicker.countDownDuration = self.originalEvent.feedDuration;
        });
        
        if (self.event.note) {
            self.note = [self.event.note copy];
        }
        
        self.event = nil;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 5;
    } else {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"detailCell"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                detailCell.textLabel.text = @"Start Time";
                detailCell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.startPicker.date];
                return detailCell;
                break;
            case 1:
                return self.dateCell;
                break;
            case 2:
                detailCell.textLabel.text = @"Duration";
                detailCell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f min", self.timePicker.countDownDuration / 60];
                return detailCell;
                break;
            case 3:
                return self.timeCell;
                break;
            case 4:
                if (self.sourceIndex == 0) {
                    detailCell.detailTextLabel.text = @"Both";
                } else if (self.sourceIndex == 1) {
                    detailCell.detailTextLabel.text = @"Left";
                } else if (self.sourceIndex == 2) {
                    detailCell.detailTextLabel.text = @"Right";
                } else if (self.sourceIndex == 3) {
                    detailCell.detailTextLabel.text = @"Bottle";
                }
                
                detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                detailCell.textLabel.text = @"Source";
                
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

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1 && self.startPickerIsShowing == NO) {
        
        return 0.0f;
        
    } else if (indexPath.row == 1 && self.startPickerIsShowing == YES) {
        
        return 161.0f;
        
    } else if (indexPath.row == 3 && self.timePickerIsShowing == NO) {
        
        return 0.0f;
        
    } else if (indexPath.row == 3 && self.timePickerIsShowing == YES) {
        
        return 161.0f;
        
    } else {
        
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && self.startPickerIsShowing == NO) {
            [self showDatePickerCell];
        } else if (indexPath.row == 0 && self.startPickerIsShowing == YES) {
            [self hideDatePickerCell];
        } else if (indexPath.row == 2 && self.timePickerIsShowing == NO) {
            [self showTimePickerCell];
        } else if (indexPath.row == 2 && self.timePickerIsShowing == YES) {
            [self hideTimePickerCell];
        } else if (indexPath.row == 4) {
            
            CCISourceViewController *sourceView = [[CCISourceViewController alloc] init];
            
            sourceView.delegate = self;
            
            sourceView.sourceIndex = self.sourceIndex;
            
            [self.navigationController pushViewController:sourceView
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

    [self hideTimePickerCell];
    self.startPickerIsShowing = YES;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.startPicker.hidden = NO;
    self.startPicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
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

- (void)showTimePickerCell
{
    
    self.timePickerIsShowing = YES;
    [self hideDatePickerCell];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    self.timePicker.hidden = NO;
    self.timePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.timePicker.alpha = 1.0f;
    }];
    
    
}

- (void)hideTimePickerCell
{
    
    self.timePickerIsShowing = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.timePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.timePicker.hidden = YES;
                     }];
    
}


- (void)saveFeeding:(id)sender
{
    
    [[CCIEventStore sharedStore] createEventWithEventType:@"feedEvent"
                                                startTime:self.startPicker.date
                                                  bedTime:nil
                                                 wakeTime:nil
                                                    isNap:nil
                                             feedDuration:self.timePicker.countDownDuration
                                              sourceIndex:self.sourceIndex
                                              diaperIndex:0
                                                     note:self.note];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)dateChange:(id)sender
{
    [self.tableView reloadData];
}

- (void)timeChange:(id)sender
{
    if (self.timePicker.countDownDuration == 60) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timePicker.countDownDuration = 60;
        });
    }
    [self.tableView reloadData];
}

- (void)addSourceChoiceViewController:(CCISourceViewController *)controller didFinishEnteringSourceChoice:(short)choice
{

    self.sourceIndex = choice;
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
    editedEvent.feedDuration = self.timePicker.countDownDuration;
    editedEvent.sourceIndex = self.sourceIndex;
    editedEvent.note = self.note;
    
    NSArray *events = [[CCIEventStore sharedStore] allEvents];
    
    for (CCIEvent *event in events) {
        if ([event isEqual:self.originalEvent]) {
            [[CCIEventStore sharedStore] removeEvent:event];
            [[CCIEventStore sharedStore] createEventWithEventType:@"feedEvent"
                                                        startTime:editedEvent.startTime
                                                          bedTime:nil
                                                         wakeTime:nil
                                                            isNap:nil
                                                     feedDuration:editedEvent.feedDuration
                                                      sourceIndex:editedEvent.sourceIndex
                                                      diaperIndex:0
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
