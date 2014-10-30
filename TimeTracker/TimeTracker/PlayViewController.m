//
//  PlayViewController.m
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "PlayViewController.h"
#import "WorkoutList.h"
#import "WorkOutModel.h"
#import "TimerViewController.h"

@interface PlayViewController ()
@property(nonatomic,strong)NSMutableArray *workouts;

@end

@implementation PlayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [_workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    WorkOutModel *aWorkout=[_workouts objectAtIndex:[indexPath row]];
    UILabel *label_name=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 25)];
    label_name.tag=kLabelTag;
    label_name.font=[UIFont boldSystemFontOfSize:16];
    label_name.text=aWorkout.workoutName;
    [cell.contentView addSubview:label_name];
    
    UILabel *label_Interval=[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 100, 25)];
    label_Interval.tag=kLabelTag;
    label_Interval.font=[UIFont boldSystemFontOfSize:10];
    label_Interval.text=[NSString stringWithFormat:@"%@%@",@"Intervals: ",[self ConvertIntToDateTime:aWorkout.workoutInterval]];
    [cell.contentView addSubview:label_Interval];
    
    UILabel *label_rest=[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 105, 25)];
    label_rest.tag=kLabelTag;
    label_rest.font=[UIFont boldSystemFontOfSize:10];
    label_rest.text=[NSString stringWithFormat:@"%@%@",@"Rest: ",[self ConvertIntToDateTime:aWorkout.restLength]];
    [cell.contentView addSubview:label_rest];
    
    UILabel *label_Laps=[[UILabel alloc] initWithFrame:CGRectMake(180, 10, 105,50)];
    label_Laps.tag=kLabelTag;
    label_Laps.font=[UIFont boldSystemFontOfSize:20];
    label_Laps.text=[NSString stringWithFormat:@"%@%d",@"X ",aWorkout.numberOfIntervals];
    [cell.contentView addSubview:label_Laps];
    
    
    UILabel *label_paly=[[UILabel alloc] initWithFrame:CGRectMake(220, 35, 40,15)];
    
    label_paly.font=[UIFont boldSystemFontOfSize:12];
    label_paly.text=@"Start";
    label_paly.backgroundColor=[UIColor grayColor];
    label_paly.textColor=[UIColor whiteColor];
    label_paly.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:label_paly];
    
    
    
    
    
    
    
    return cell;

}



-(void)viewWillAppear:(BOOL)animated{
    
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.rowHeight=60.0f;
    
    _workouts=[[NSMutableArray alloc]init];
    WorkoutList *listWorkout=[WorkoutList sharedWorkoutsList];
    
    _workouts=[listWorkout.workOuts mutableCopy];
    
    [self.tableView reloadData];

    
    
  }



-(NSString *)ConvertIntToDateTime :(NSUInteger)inputSeconds{
    NSString *formatterDate=@"00:00:00";
    NSUInteger hours,minutes,seconds;
    hours=inputSeconds/3600;
    minutes=(inputSeconds%3600)/60;
    seconds=(inputSeconds%3600)%60;
    formatterDate=[NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];
    return formatterDate;
}

-(WorkOutModel *)getWorkoutObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    WorkOutModel *obj=_workouts[indexPath.row];
    return obj;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath=[self.tableView indexPathForCell:sender];
    WorkOutModel *workout=[self getWorkoutObjectAtIndexPath:indexPath];
    
    [segue.destinationViewController navigationItem].title=workout.workoutName;
    
    
    TimerViewController *timerViewController=segue.destinationViewController;
    timerViewController.objWorkout=workout;

}



@end
