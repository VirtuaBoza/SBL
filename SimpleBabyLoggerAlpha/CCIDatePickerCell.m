//
//  CCIDatePickerCell.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/17/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCIDatePickerCell.h"

@implementation CCIDatePickerCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
    [super willMoveToSuperview:newSuperview];
    
    self.datePicker.maximumDate = [NSDate date];
    
}

@end
