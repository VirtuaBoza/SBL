//
//  CCISourceViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/20/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCISourceViewController;

@protocol CCISourceViewControllerDelegate <NSObject>

- (void)addSourceChoiceViewController:(CCISourceViewController *)controller didFinishEnteringSourceChoice:(short)choice;

@end

@interface CCISourceViewController : UITableViewController

@property (nonatomic, weak) id <CCISourceViewControllerDelegate> delegate;

@property (nonatomic) int sourceIndex;

@end
