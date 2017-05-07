//
//  CCITimePickerCell.m
//  SimpleBabyLoggerAlpha
//
//  Created by Andrew Boza on 1/18/15.
//  Copyright (c) 2015 CoraCorp. All rights reserved.
//

#import "CCITimePickerCell.h"

@implementation CCITimePickerCell

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    
    [super willMoveToSuperview:newSuperview];
    
    self.timePicker.countDownDuration = 60;
    
}

@end
