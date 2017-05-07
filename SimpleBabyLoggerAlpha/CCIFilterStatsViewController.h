//
//  CCIFilterStatsViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/30/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCIFilterStatsViewController;

@protocol CCIFilterStatsViewControllerDelegate <NSObject>

- (void)addDateChoiceViewController:(CCIFilterStatsViewController *)controller didFinishEnteringDateChoice:(short)choice;

@end

@interface CCIFilterStatsViewController : UITableViewController

@property (nonatomic, weak) id <CCIFilterStatsViewControllerDelegate> delegate;

@property (nonatomic) short dateOptionIndex;

@end
