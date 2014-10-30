//
//  WorkOutListViewController.h
//  TimeTracker
//
//  Created by david on 27/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutList.h"
#define kLabelTag 999

@interface WorkOutListViewController : UITableViewController<UITabBarControllerDelegate,UITableViewDataSource>
@property(nonatomic,strong) WorkoutList *listWorkout;
@end
