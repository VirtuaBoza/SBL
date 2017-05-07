//
//  CCIDiaperViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/21/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCIDiaperChoiceViewController.h"
#import "CCINotesViewController.h"

@class CCIEvent;

@interface CCIDiaperViewController : UITableViewController <CCIDiaperChoiceViewControllerDelegate, CCINotesViewControllerDelegate>

@property (nonatomic) CCIEvent *event;

- (instancetype)initForNewDiaperEvent:(BOOL)isNew;

@end
