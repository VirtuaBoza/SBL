//
//  CCINewEventViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/16/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCINewEventViewController : UITableViewController

@property (nonatomic, copy) NSArray *events;
@property (nonatomic, copy) NSArray *quickEvents;
@property (nonatomic, copy) NSArray *eventImages;
@property (nonatomic, copy) NSArray *quickEventImages;

@end
