//
//  TimerViewController.h
//  TimeTracker
//
//  Created by david on 28/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "WorkOutModel.h"

#define kWorkInterval @"Interval"
#define tRestLength @"Rest"
#define maxPlayLap 999

@interface TimerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSTimer *timer;
}
@property(strong, nonatomic)WorkOutModel *objWorkout;

@property(nonatomic,weak) IBOutlet UILabel *stageLabel;
@property(nonatomic,weak) IBOutlet UILabel *countdownLabel;
@property(nonatomic,weak) IBOutlet UIButton *btnStart;
@property(nonatomic,weak) IBOutlet UIButton *btnPause;
@property(nonatomic,weak) IBOutlet UIButton *btnReset;
@property(nonatomic,strong) IBOutlet UITableView *tableStages;



-(void)UpdateingCount:(NSTimer *)theTimer;
-(void)countdownTimer;
-(IBAction)StartTimer:(id)sender;
-(IBAction)PauseTimer:(id)sender;
-(IBAction)StopTimer:(id)sender;
-(IBAction)Reset:(id)sender;
-(void)SWitchStage;
-(NSString *)PrintLablelWithTimeFormat:(NSUInteger)isecondremains;
@end
