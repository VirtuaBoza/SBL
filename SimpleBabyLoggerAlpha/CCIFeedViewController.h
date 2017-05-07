//
//  CCIFeedViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/18/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCISourceViewController.h"
#import "CCINotesViewController.h"

@class CCIEvent;

@interface CCIFeedViewController : UITableViewController <CCISourceViewControllerDelegate, CCINotesViewControllerDelegate>

@property (nonatomic) CCIEvent *event;

- (instancetype)initForNewFeedEvent:(BOOL)isNew;

@end
