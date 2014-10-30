//
//  EditViewController.h
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkOutModel.h"
#define kNunmberofRows  4
#define kWorkoutNameIndex 0
#define kWorkoutInterval 1
#define kRestLength 2
#define kNumberOfIntervals 3

#define kPickerAnimationDuration 0.40
#define kDatePickerTag  99


#define kTitlle @"title"
#define kDateKey @"Date"

@interface EditViewController : UIViewController<UITextFieldDelegate>
@property(strong, nonatomic)WorkOutModel *objWorkout;

@end
