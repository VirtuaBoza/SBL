//
//  CCIFilterLogViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/18/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIFilterLogViewController.h"

@interface CCIFilterLogViewController ()

@property (nonatomic, copy) NSArray *filterEventOptions;
@property (nonatomic, copy) NSArray *filterDateOptions;

@property (nonatomic) NSIndexPath *lastEventOptionIndexPath;
@property (nonatomic) NSIndexPath *lastDateOptionIndexPath;

@end

@implementation CCIFilterLogViewController

- (instancetype)init
{

    self = [super initWithStyle:UITableViewStyleGrouped];
    
    self.filterEventOptions = @[@"All Events", @"Sleep Events", @"Feeding Events", @"Diaper Changes"];
    self.filterDateOptions = @[@"Today", @"Yesterday", @"Past Week", @"All Time"];
    

    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.navigationItem.title = @"Filter";
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    

    
    return self;
    
}
/*
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    
    return [self init];
    
}
*/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.lastEventOptionIndexPath = [NSIndexPath indexPathForRow:self.eventOptionIndex inSection:0];
    self.lastDateOptionIndexPath = [NSIndexPath indexPathForRow:self.dateOptionIndex inSection:1];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [self.filterEventOptions count];
    } else {
        return [self.filterDateOptions count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = [self.filterEventOptions[indexPath.row] description];
        
        if (self.eventOptionIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
        
    } else {
        
        cell.textLabel.text = [self.filterDateOptions[indexPath.row] description];
        
        if (self.dateOptionIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        [self.tableView cellForRowAtIndexPath:self.lastEventOptionIndexPath].accessoryType = UITableViewCellAccessoryNone;
        self.eventOptionIndex = indexPath.row;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastEventOptionIndexPath = indexPath;
        
    } else {
        
        [self.tableView cellForRowAtIndexPath:self.lastDateOptionIndexPath].accessoryType = UITableViewCellAccessoryNone;
        self.dateOptionIndex = indexPath.row;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastDateOptionIndexPath = indexPath;
        
    }
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return @"Filter by Event Type";
    } else {
        return @"Filter by Date";
    }
    
    
}

- (void)save:(id)sender
{
    
    [self.delegate addEventChoiceViewController:self didFinishEnteringEventChoice:self.eventOptionIndex];
    [self.delegate addDateChoiceViewController:self didFinishEnteringDateChoice:self.dateOptionIndex];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:NULL];
    
}

- (void)cancel:(id)sender
{
    
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:NULL];
    
}

@end
