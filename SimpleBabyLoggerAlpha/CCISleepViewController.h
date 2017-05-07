//
//  CCISleepViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/17/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCINotesViewController.h"

@class CCIEvent;

@interface CCISleepViewController : UITableViewController <CCINotesViewControllerDelegate>

@property (nonatomic) CCIEvent *event;

- (instancetype)initForNewSleepEvent:(BOOL)isNew;

@end
