//
//  CCIDiaperChoiceViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/21/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCIDiaperChoiceViewController;

@protocol CCIDiaperChoiceViewControllerDelegate <NSObject>

- (void)addDiaperChoiceViewController:(CCIDiaperChoiceViewController *)controller didFinishEnteringDiaperChoice:(short)choice;

@end

@interface CCIDiaperChoiceViewController : UITableViewController

@property (nonatomic, weak) id <CCIDiaperChoiceViewControllerDelegate> delegate;

@property (nonatomic) int diaperIndex;

@end
