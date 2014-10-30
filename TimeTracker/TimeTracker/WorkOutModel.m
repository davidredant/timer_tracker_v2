//
//  WorkOutModel.m
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "WorkOutModel.h"

@implementation WorkOutModel
-(id)initWithWorkoutName:(NSString *)workName workoutInterval:(NSInteger)workoutInterval restLength:(NSInteger)restLength numberOfInterval:(NSInteger)numberOfIntervals{
    if (self=[super init]) {
        _workoutName=[workName copy];
        _workoutInterval=workoutInterval;
        _restLength=restLength;
        _numberOfIntervals=numberOfIntervals;
    }
    return self;
}

@end
