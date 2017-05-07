//
//  CCINotesViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/22/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCINotesViewController.h"
#import "CCIEvent.h"
#import "CCIEventStore.h"

@interface CCINotesViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) CCIEvent *originalEvent;

@end

@implementation CCINotesViewController

- (instancetype)initFromLog:(BOOL)didInitFromLog
{
    
    self = [super init];
    
    if (didInitFromLog) {
        
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                        target:self
                                                                                        action:@selector(saveChange)];
        self.navigationItem.rightBarButtonItem = doneButtonItem;
        
    } else {
        
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                        target:self
                                                                                        action:@selector(save)];
        self.navigationItem.rightBarButtonItem = doneButtonItem;
    }
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
    
    if (self.note) {
        self.textView.text = [self.note copy];
    }
    
    if (self.event) {
        self.eventType = self.event.eventType;
        self.textView.text = [self.event.note copy];
    }
    
    if ([self.eventType isEqualToString:@"sleepEvent"]) {
        self.navigationItem.title = @"Sleep Notes";
    } else if ([self.eventType isEqualToString:@"feedEvent"]) {
        self.navigationItem.title = @"Feeding Notes";
    } else if ([self.eventType isEqualToString:@"diaperEvent"]) {
        self.navigationItem.title = @"Diaper Change Notes";
    }
    
    self.originalEvent = self.event;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.layer.borderWidth = 8.0f;
    
    self.textView.layer.cornerRadius = 16;
    
    self.textView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    
    self.textView.textContainerInset = UIEdgeInsetsMake(16, 10, 16, 10);
    
    [self.textView setScrollIndicatorInsets:UIEdgeInsetsMake(16, 10, 16, 10)];
    
    [self.textView setAlwaysBounceVertical:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}

- (void)save
{

    if (![self.textView.text isEqualToString:@""]) {
        self.note = [self.textView.text copy];
        
        [self.delegate addNoteFromController:self
                                        note:self.note];

    } else {
        [self.delegate addNoteFromController:self
                                        note:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)saveChange
{
    
    if ([self.textView.text isEqualToString:@""]) {
        self.event.note = nil;
    }
    
    NSArray *events = [[CCIEventStore sharedStore] allEvents];
    
    for (CCIEvent *event in events) {
        if ([event isEqual:self.originalEvent]) {
            [[CCIEventStore sharedStore] removeEvent:event];
            [[CCIEventStore sharedStore] createEventWithEventType:self.event.eventType
                                                        startTime:self.event.startTime
                                                          bedTime:self.event.bedTime
                                                         wakeTime:self.event.wakeTime
                                                            isNap:self.event.isNap
                                                     feedDuration:self.event.feedDuration
                                                      sourceIndex:self.event.sourceIndex
                                                      diaperIndex:self.event.diaperIndex
                                                             note:self.textView.text];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
