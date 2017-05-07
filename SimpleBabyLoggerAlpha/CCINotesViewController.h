//
//  CCINotesViewController.h
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/22/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CCINotesViewController;
@class CCIEvent;

@protocol CCINotesViewControllerDelegate <NSObject>

- (void)addNoteFromController:(CCINotesViewController *)controller note:(NSString *)note;

@end

@interface CCINotesViewController : UIViewController

@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *eventType;
@property (nonatomic) CCIEvent *event;

@property (nonatomic, weak) id <CCINotesViewControllerDelegate> delegate;

- (instancetype)initFromLog:(BOOL)didInitFromLog;

@end
