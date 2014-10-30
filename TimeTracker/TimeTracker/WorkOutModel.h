//
//  WorkOutModel.h
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkOutModel : NSObject
@property(nonatomic, copy)NSString *workoutName;
@property (assign,nonatomic)NSInteger workoutInterval;
@property (assign,nonatomic)NSInteger restLength;
@property (assign,nonatomic)NSInteger numberOfIntervals;

-(id)initWithWorkoutName:(NSString *)workName workoutInterval:(NSInteger)workoutInterval restLength:(NSInteger)restLength numberOfInterval :(NSInteger)numberOfIntervals;

@end
