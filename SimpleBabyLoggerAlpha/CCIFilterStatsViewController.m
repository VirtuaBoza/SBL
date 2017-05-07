//
//  CCIFilterStatsViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/30/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIFilterStatsViewController.h"

@interface CCIFilterStatsViewController ()

@property (nonatomic, copy) NSArray *filterDateOptions;

@property (nonatomic) NSIndexPath *lastDateOptionIndexPath;

@end

@implementation CCIFilterStatsViewController

- (instancetype)init
{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    self.filterDateOptions = @[@"Today", @"Yesterday", @"Past Week", @"All Time"];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
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
    
    self.lastDateOptionIndexPath = [NSIndexPath indexPathForRow:self.dateOptionIndex inSection:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{

    return [self.filterDateOptions count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [self.filterDateOptions[indexPath.row] description];
        
    if (self.dateOptionIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    return cell;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView cellForRowAtIndexPath:self.lastDateOptionIndexPath].accessoryType = UITableViewCellAccessoryNone;
    self.dateOptionIndex = indexPath.row;
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.lastDateOptionIndexPath = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self save];
    
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{

    return @"Filter by Date";
    
}

- (void)save
{

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
