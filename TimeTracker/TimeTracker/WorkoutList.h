//
//  WorkoutList.h
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkOutModel.h"

@interface WorkoutList : NSObject
+(instancetype)sharedWorkoutsList;
-(NSArray *)workOuts;
-(void)addWorkout:(WorkOutModel *)item;
-(void)removeWorkout:(WorkOutModel *)item;
-(void)updateWorkout:(WorkOutModel *)item;
@end
