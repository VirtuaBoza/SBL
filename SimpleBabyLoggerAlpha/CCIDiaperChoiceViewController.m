//
//  CCIDiaperChoiceViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/21/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIDiaperChoiceViewController.h"

@interface CCIDiaperChoiceViewController ()

@property (nonatomic, copy) NSArray *diaperOptions;

@property (nonatomic) NSIndexPath *lastOptionIndexPath;

@end

@implementation CCIDiaperChoiceViewController

- (instancetype)init
{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    self.diaperOptions = @[@"Wet and Dirty", @"Wet", @"Dirty"];
    
    self.navigationItem.title = @"Diaper";
    
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
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    self.lastOptionIndexPath = [NSIndexPath indexPathForRow:self.diaperIndex
                                                  inSection:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.diaperOptions count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [self.diaperOptions[indexPath.row] description];
    
    if (self.diaperIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView cellForRowAtIndexPath:self.lastOptionIndexPath].accessoryType = UITableViewCellAccessoryNone;
    
    self.diaperIndex = (int) indexPath.row;
    
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.lastOptionIndexPath = indexPath;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self save];
    
}

- (void)save
{
    
    [self.delegate addDiaperChoiceViewController:self
                   didFinishEnteringDiaperChoice:self.diaperIndex];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
