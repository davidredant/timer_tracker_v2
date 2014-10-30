//
//  WorkoutList.m
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "WorkoutList.h"
#import "AppDelegate.h"


@interface WorkoutList()
@property (strong,nonatomic)NSMutableArray *workOuts;

@end

@implementation WorkoutList
+(instancetype)sharedWorkoutsList{
    static WorkoutList *shared=nil;
 //   static dispatch_once_t oneToken;
  //  dispatch_once(&oneToken, ^{
    //     shared=[[self alloc]init];
  //  });
    shared=[[self alloc]init];

    return shared;
}


-(void)addWorkout:(WorkOutModel *)item{
    [_workOuts insertObject:item atIndex:0];
    
    
    [self saveNewWorkout:item];
}

-(void)removeWorkout:(id)item{
    [_workOuts removeObject:item];
    [self deleteWorkout:item];
}

-(void)updateWorkout:(WorkOutModel *)item{
    [self updatingWorkout:item];
}





-(instancetype)init{
    self=[super init];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSEntityDescription *WorkOut=[NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    
    
    [request setEntity:WorkOut];
    
    NSError *error;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    
    if ([objects count]>0) {
        self.workOuts=[[NSMutableArray alloc] init];
        for (NSManagedObject *obj in objects){
            
            WorkOutModel *aWorkOut=[[WorkOutModel alloc] init];
            aWorkOut.workoutName=[obj valueForKey:@"name"];
            aWorkOut.workoutInterval=[[obj valueForKey:@"intervals"] integerValue];
            aWorkOut.restLength=[[obj valueForKey:@"rest"] integerValue];
            aWorkOut.numberOfIntervals=[[obj valueForKey:@"laps"] integerValue];
            
            
            [_workOuts addObject:aWorkOut];
        }
        
    }
    else
    {
        self.workOuts=[NSMutableArray array];
    }
    return self;

}
-(void)saveNewWorkout:(WorkOutModel *)aWorkOut{
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    
    
    
    NSManagedObject *newWorkOut;
    newWorkOut=[NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:context];
    
    [newWorkOut setValue: aWorkOut.workoutName forKey:@"name"];
    [newWorkOut setValue: [NSNumber numberWithInteger:aWorkOut.workoutInterval] forKey:@"intervals"];
    [newWorkOut setValue: [NSNumber numberWithInteger:aWorkOut.restLength] forKey:@"rest"];
    [newWorkOut setValue: [NSNumber numberWithInteger:aWorkOut.numberOfIntervals] forKey:@"laps"];
    newWorkOut=nil;
    NSError *error;
    [context save:&error];
    

}


-(void)deleteWorkout:(WorkOutModel *)dworkout{

 
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSEntityDescription *WorkOut=[NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:WorkOut];

    NSPredicate *predString=[NSPredicate predicateWithFormat:@"name=%@",dworkout.workoutName];
    [request setPredicate:predString];
 
    
    NSError *error;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in objects) {
        [context deleteObject:obj];
        [context save:&error];
    }
 
 
 
}

-(void)updatingWorkout:(WorkOutModel *)uWorkOut{
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    NSEntityDescription *WorkOut=[NSEntityDescription entityForName:@"Workout" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:WorkOut];
    
    NSPredicate *predString=[NSPredicate predicateWithFormat:@"name=%@",uWorkOut.workoutName];
    [request setPredicate:predString];
    
    
    NSError *error;
    NSArray *objects=[context executeFetchRequest:request error:&error];
    for (NSManagedObject *obj in objects) {
        [obj setValue: uWorkOut.workoutName forKey:@"name"];
        [obj setValue: [NSNumber numberWithInteger:uWorkOut.workoutInterval] forKey:@"intervals"];
        [obj setValue: [NSNumber numberWithInteger:uWorkOut.restLength] forKey:@"rest"];
        [obj setValue: [NSNumber numberWithInteger:uWorkOut.numberOfIntervals] forKey:@"laps"];

    }
    
    [context save:&error];

    

}

@end
