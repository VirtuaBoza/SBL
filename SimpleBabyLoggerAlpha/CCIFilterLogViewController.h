//
//  CCIFilterLogViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/18/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCIFilterLogViewController;

@protocol CCIFilterLogViewControllerDelegate <NSObject>

- (void)addEventChoiceViewController:(CCIFilterLogViewController *)controller didFinishEnteringEventChoice:(short)choice;
- (void)addDateChoiceViewController:(CCIFilterLogViewController *)controller didFinishEnteringDateChoice:(short)choice;

@end

@interface CCIFilterLogViewController : UITableViewController

@property (nonatomic, weak) id <CCIFilterLogViewControllerDelegate> delegate;

@property (nonatomic) short eventOptionIndex;
@property (nonatomic) short dateOptionIndex;

@end
