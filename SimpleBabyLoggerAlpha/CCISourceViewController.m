//
//  CCISourceViewController.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/20/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCISourceViewController.h"

@interface CCISourceViewController ()

@property (nonatomic, copy) NSArray *sourceOptions;

@property (nonatomic) NSIndexPath *lastOptionIndexPath;

@end

@implementation CCISourceViewController

- (instancetype)init
{
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    self.sourceOptions = @[@"Both", @"Left", @"Right", @"Bottle"];
    
    self.navigationItem.title = @"Source";
    
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
    
    self.lastOptionIndexPath = [NSIndexPath indexPathForRow:self.sourceIndex
                                                  inSection:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.sourceOptions count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    
    cell.textLabel.text = [self.sourceOptions[indexPath.row] description];
    
    if (self.sourceIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView cellForRowAtIndexPath:self.lastOptionIndexPath].accessoryType = UITableViewCellAccessoryNone;
    
    self.sourceIndex = (int) indexPath.row;
    
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.lastOptionIndexPath = indexPath;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self save];
    
}

- (void)save
{

    [self.delegate addSourceChoiceViewController:self
                   didFinishEnteringSourceChoice:self.sourceIndex];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
